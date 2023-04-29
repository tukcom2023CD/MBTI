//
//  ViewController.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
// test

import UIKit
import Speech
import AVFoundation
import RealmSwift

class MainViewController: UIViewController,SFSpeechRecognizerDelegate, AVSpeechSynthesizerDelegate {
    
    
    let realmInstance = try! Realm()
    @IBOutlet weak var allergyRead: UILabel!
    let testState = UserDefaults.standard.bool(forKey: "eggSwitchState")
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var speechText: UITextView!
    var text : String = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBAction func QRButton(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            TextCheck(text)
            speechButton.setTitle("Start Recording", for: .normal)
        }
        let QRViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRReaderView") as! QRViewController
        QRViewController.modalPresentationStyle = .fullScreen // 화면이 사라지지 않는 문제가 계속 발생할 경우 추가해주세요.
        self.present(QRViewController, animated: true, completion: nil)
    }
    @IBAction func AllergyButton(_ sender: UIButton) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            TextCheck(text)
            speechButton.setTitle("Start Recording", for: .normal)
        }
        let AllergyViewController = self.storyboard?.instantiateViewController(withIdentifier: "allergySetting") as! AllergyViewController
        AllergyViewController.modalPresentationStyle = .fullScreen // 화면이 사라지지 않는 문제가 계속 발생할 경우 추가해주세요.
        self.present(AllergyViewController, animated: true, completion: nil)
    }
    @IBAction func SpeechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            TextCheck(text)
            speechButton.setTitle("Start Recording", for: .normal)
        } else {
            synthesizer.stopSpeaking(at: .immediate)
            startRecording()
            speechButton.setTitle("Stop Recording", for: .normal)
        }
    }
    func moveSpeechView(_ sender: Any, _ identifier : String){
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else{
            return
        }
        
        //        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        svc.modalPresentationStyle = .fullScreen
        self.present(svc, animated: true,completion: nil)
    }
    func TextCheck(_ text : String) {
        if (text.contains("알레") || text.contains("알러")) && (text.contains("QR") || text.contains("큐알")) {
            textToSpeech("화면 이동 키워드가 중복되었습니다. 다시 시도해주세요",synthesizer)
        }
        else if text.contains("알레") || text.contains("알러") {
            moveSpeechView((Any).self,"allergySetting")
        }
        else if text.contains("QR") || text.contains("큐알") {
            moveSpeechView((Any).self,"QRReaderView")
        }
        else{
            textToSpeech("화면 이동 키워드가 입력되지 않았습니다",synthesizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer?.delegate = self
        AVSpeechSynthesisVoice.speechVoices()
        
        if UserDefaults.standard.bool(forKey: "eggSwitchState") == false{
            let bViewController = storyboard?.instantiateViewController(withIdentifier: "allergySetting") as! AllergyViewController
                        present(bViewController, animated: true, completion: nil)
        }
        else {
            let QRViewController = storyboard?.instantiateViewController(withIdentifier: "QRReaderView") as!
            QRViewController
            present(QRViewController,animated: true,completion:  nil)
        }
        // Do any additional setup after loading the view.
        
    }
    
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                self.speechText.text = result?.bestTranscription.formattedString
                self.text = self.speechText.text
                isFinal = (result?.isFinal)!
                
                if self.text.contains("알레르기")||self.text.contains("QR") { // 특정 값이 인식되면
                    self.audioEngine.stop() // 오디오 엔진 정지
                    inputNode.removeTap(onBus: 0)
                    
                    self.recognitionRequest?.endAudio() // 인식 요청 종료
                    self.recognitionRequest = nil
                    self.recognitionTask = nil
                    
                    self.speechButton.isEnabled = true // 녹음 버튼 활성화
                    
                    if isFinal {
                                self.TextCheck(self.text) // recognitionTask가 취소되는 시점에 TextCheck 함수 호출
                            }
                }
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest?.endAudio()
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.speechButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        speechText.text = "Say something, I'm listening!"
    }
}

//func textToSpeech(_ errorText:String, _ synthesizer:AVSpeechSynthesizer) {
//
//    let audioSession = AVAudioSession.sharedInstance()
//
//    do {
//        try audioSession.setCategory(.playback, mode: .default)
//        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
//    } catch {
//        print("Error setting audio session: \(error.localizedDescription)")
//    }
//
//    let utterance = AVSpeechUtterance(string: errorText)
//    utterance.voice = AVSpeechSynthesisVoice(language:"ko-KR")
//    utterance.rate = 0.6
//    utterance.volume = 1.0
//    synthesizer.speak(utterance)
//}
