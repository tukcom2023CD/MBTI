//
//  testViewController.swift
//  ios
//
//  Created by 장지수 on 2023/04/29.
//

import UIKit
import Speech
import AVFoundation


class testViewController: UIViewController {
    
    @IBOutlet weak var speechText: UITextView!
    var text : String = ""
    let synthesizer = AVSpeechSynthesizer()
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    @IBOutlet weak var userDefaultText: UILabel!
    private let audioEngine = AVAudioEngine()
    @IBOutlet weak var speechButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "myStringKey") != nil {
            userDefaultText.text = UserDefaults.standard.string(forKey: "myStringKey")
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func SpeechTotext(_ sender: Any) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            speechButton.isEnabled = false
            speechButton.setTitle("Start Recording", for: .normal)
            if !text.contains("QR") && !text.contains("알레르기"){
                TextCheck(text)
            }
        } else {
            startRecording()
            speechButton.setTitle("Stop Recording", for: .normal)
        }
    }
    func TextCheck(_ text : String) {
        var state = false
        if text.contains("계란") {
            state = true
            let string = "계란"
            changeUserDefault(text: string)
        }
        if text.contains("우유") {
            state = true
            let string = "우유"
            changeUserDefault(text: string)
        }
        if text.contains("곡류") {
            state = true
            let string = "곡류"
            changeUserDefault(text: string)
        }
        if text.contains("게") {
            state = true
            let string = "게"
            changeUserDefault(text: string)
        }
        if text.contains("새우") {
            state = true
            let string = "새우"
            changeUserDefault(text: string)
        }
        
        if text.contains("땅콩") {
            state = true
            let string = "땅콩"
            changeUserDefault(text: string)
        }
        if text.contains("호두") {
            state = true
            let string = "호두"
            changeUserDefault(text: string)
        }
        if text.contains("고등어") {
            state = true
            let string = "고등어"
            changeUserDefault(text: string)
        }
        if text.contains("조개류") {
            state = true
            let string = "조개류"
            changeUserDefault(text: string)
        }
        if text.contains("아산황류") {
            state = true
            let string = "아산황류"
            changeUserDefault(text: string)
        }
        if text.contains("오징어") {
            state = true
            let string = "오징어"
            changeUserDefault(text: string)
        }
        if text.contains("돼지고기") {
            state = true
            let string = "돼지고기"
            changeUserDefault(text: string)
        }
        if text.contains("닭고기") {
            state = true
            let string = "닭고기"
            changeUserDefault(text: string)
        }
        if text.contains("쇠고기") {
            state = true
            let string = "쇠고기"
            changeUserDefault(text: string)
        }
        if text.contains("토마토") {
            state = true
            let string = "토마토"
            changeUserDefault(text: string)
        }
        if text.contains("잣") {
            state = true
            let string = "잣"
            changeUserDefault(text: string)
        }
        if text.contains("없음") {
            state = true
            let string = "없음"
            changeUserDefault(text: string)
        }
        if state == false {
            textToSpeech("해당 알레르기가 존재하지 않습니다.",synthesizer)
        }
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
        
        speechText.text =  "Say something, I'm listening!"
        
        
    }
    
    func changeUserDefault(text : String) {
        
        var myString = UserDefaults.standard.string(forKey: "myStringKey") ?? ""
        if text == "없음" {
            myString = text
            UserDefaults.standard.set(myString, forKey: "myStringKey")
            textToSpeech(" 없음이 입력되어 모든 알레르기 설정이 삭제되었습니다.", synthesizer)
        }
        else {
            myString = myString.replacingOccurrences(of: "없음", with: "")
            if myString.contains(text) {
                myString = myString.replacingOccurrences(of: text, with: "")
                
                if myString == "" {
                    myString.append("없음")
                    UserDefaults.standard.set(myString, forKey: "myStringKey")
                    textToSpeech("모든 알레르기가 삭제되어 없음으로 설정됩니다.", synthesizer)
                }
                else {
                    UserDefaults.standard.set(myString, forKey: "myStringKey")
                    textToSpeech("\(text) 알레르기가 삭제되었습니다.", synthesizer)
                }
            }
            else {
                myString.append(text)
                UserDefaults.standard.set(myString, forKey: "myStringKey")
                textToSpeech("\(text) 알레르기가 추가되었습니다.", synthesizer)
            }
        }
        
        
        userDefaultText.text = myString
    }
    
    
}



func textToSpeech(_ errorText:String, _ synthesizer:AVSpeechSynthesizer) {
    
    let audioSession = AVAudioSession.sharedInstance()
    
    do {
        try audioSession.setCategory(.playback, mode: .default)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
        print("Error setting audio session: \(error.localizedDescription)")
    }
    
    let utterance = AVSpeechUtterance(string: errorText)
    utterance.voice = AVSpeechSynthesisVoice(language:"ko-KR")
    utterance.rate = 0.6
    utterance.volume = 1.0
    synthesizer.speak(utterance)
}
