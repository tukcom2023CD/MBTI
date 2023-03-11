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

class MainViewController: UIViewController,SFSpeechRecognizerDelegate {
    

    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var speechButton: UIButton!
    @IBOutlet weak var speechText: UITextView!
    var text : String = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    @IBAction func SpeechToText(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            speechButton.setTitle("Start Recording", for: .normal)
            TextCheck(text)
        } else {
            startRecording()
            speechButton.setTitle("Stop Recording", for: .normal)
        }
    }
    func moveSpeechView(_ sender: Any, _ identifier : String){
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else{
            return
        }
        
        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(svc, animated: true)
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
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
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

func textToSpeech(_ errorText:String, _ synthesizer:AVSpeechSynthesizer) {
    let utterance = AVSpeechUtterance(string: errorText)
    utterance.voice = AVSpeechSynthesisVoice(language:"ko-KR")
    utterance.rate = 0.4
    synthesizer.speak(utterance)
}
