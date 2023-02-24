//
//  AllergyViewController.swift
//  ios
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit
import Speech

class AllergyViewController: UITableViewController,SFSpeechRecognizerDelegate {
    
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var MilkSwitch: UISwitch!
    @IBOutlet weak var EggSwitch: UISwitch!
    @IBOutlet weak var CerealSwitch: UISwitch!
    @IBOutlet weak var CrabSwitch: UISwitch!
    @IBOutlet weak var ShrimpSwitch: UISwitch!
    @IBOutlet weak var PeanutSwitch: UISwitch!
    
    @IBOutlet weak var speechText: UITextView!
    @IBOutlet weak var speechButton: UIButton!
    
    var text : String = ""
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer?.delegate = self
        UserDefaultState(EggSwitch, "eggSwitchState")
        UserDefaultState(MilkSwitch, "milkSwitchState")
        UserDefaultState(CerealSwitch, "cerealSwitchState")
        UserDefaultState(CrabSwitch, "crabSwitchState")
        UserDefaultState(ShrimpSwitch, "shrimpSwitchState")
        UserDefaultState(PeanutSwitch, "peanutSwitchState")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func speechToText(_ sender: Any) {
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
        if text.contains("계란") {
            changeState(EggSwitch, "eggSwitchState")
        }
        if text.contains("우유") {
            changeState(MilkSwitch, "milkSwitchState")
        }
        if text.contains("곡류") {
            changeState(CerealSwitch, "cerealSwitchState")
        }
        if text.contains("게") {
            changeState(CrabSwitch, "crabSwitchState")
        }
        if text.contains("새우") {
            changeState(ShrimpSwitch, "shrimpSwitchState")
        }

        if text.contains("땅콩") {
            changeState(PeanutSwitch, "peanutSwitchState")
        }
        else{
            textToSpeech("해당 알레르기가 존재하지 않습니다.")
        }
    }
    func changeState(_ SwitchName : UISwitch, _ SwitchKeyName : String) {
        if SwitchName.isOn == true{
            SwitchName.isOn = false
            SwitchSetting(SwitchName, SwitchKeyName)
            UserDefaultState(SwitchName, SwitchKeyName)
        }
        else{
            SwitchName.isOn = true
            SwitchSetting(SwitchName, SwitchKeyName)
            UserDefaultState(SwitchName, SwitchKeyName)
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
        
        speechText.text = "Say something, I'm listening!"
        
        
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        SwitchSetting(EggSwitch, "eggSwitchState")
        SwitchSetting(MilkSwitch, "milkSwitchState")
        SwitchSetting(CerealSwitch, "cerealSwitchState")
        SwitchSetting(CrabSwitch, "crabSwitchState")
        SwitchSetting(ShrimpSwitch, "shrimpSwitchState")
        SwitchSetting(PeanutSwitch, "peanutSwitchState")
    }
    func SwitchSetting(_ switchname: UISwitch, _ switchkeyname: String){
        UserDefaults.standard.set(switchname.isOn, forKey: switchkeyname)
    }
    func UserDefaultState(_ switchname: UISwitch, _ switchkeyname: String) {
        switchname.isOn = UserDefaults.standard.bool(forKey: switchkeyname)
    }
    func textToSpeech(_ errorText:String) {
        let utterance = AVSpeechUtterance(string: errorText)
        utterance.voice = AVSpeechSynthesisVoice(language:"ko-KR")
        utterance.rate = 0.4
        synthesizer.speak(utterance)
    }
}

/*
 EggSwitch.isOn =  UserDefaults.standard.bool(forKey: "eggSwitchState")
 MilkSwitch.isOn =  UserDefaults.standard.bool(forKey: "milkSwitchState")
 CerealSwitch.isOn =  UserDefaults.standard.bool(forKey: "cerealSwitchState")
 CrabSwitch.isOn =  UserDefaults.standard.bool(forKey: "crabSwitchState")
 ShrimpSwitch.isOn =  UserDefaults.standard.bool(forKey: "shrimpSwitchState")
 PeanutSwitch.isOn =  UserDefaults.standard.bool(forKey: "peanutSwitchState")
 */
