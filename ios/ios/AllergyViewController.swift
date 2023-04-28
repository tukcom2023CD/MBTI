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
    
    @IBOutlet weak var WalnutSwitch: UISwitch!
    @IBOutlet weak var MackerelSwitch: UISwitch!
    @IBOutlet weak var ShellfishSwitch: UISwitch!
    @IBOutlet weak var SulfiteSwitch: UISwitch!
    @IBOutlet weak var SquidSwitch: UISwitch!
    @IBOutlet weak var PorkSwitch: UISwitch!
    @IBOutlet weak var ChickenSwitch: UISwitch!
    @IBOutlet weak var BeefSwitch: UISwitch!
    @IBOutlet weak var TomatoSwitch: UISwitch!
    @IBOutlet weak var PinenutSwitch: UISwitch!
    
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
        UserDefaultState(WalnutSwitch, "walnutSwitchState")
        UserDefaultState(MackerelSwitch, "mackerelSwitchState")
        UserDefaultState(ShellfishSwitch, "shellfishSwitchState")
        UserDefaultState(SulfiteSwitch, "sulfiteSwitchState")
        UserDefaultState(SquidSwitch, "squidSwitchState")
        UserDefaultState(PorkSwitch, "porkSwitchState")
        UserDefaultState(ChickenSwitch, "chickenSwitchState")
        UserDefaultState(BeefSwitch, "beefSwitchState")
        UserDefaultState(TomatoSwitch, "tomatoSwitchState")
        UserDefaultState(PinenutSwitch, "pinenutSwitchState")
    }
    
    @IBAction func speechToText(_ sender: Any) {
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
    func moveSpeechView(_ sender: Any, _ identifier : String){
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: identifier) else{
            return
        }
        
        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(svc, animated: true)
    }
    func TextCheck(_ text : String) {
        var state = false
        if text.contains("계란") {
            state = true
            changeState(EggSwitch, "eggSwitchState")
        }
        if text.contains("우유") {
            state = true
            changeState(MilkSwitch, "milkSwitchState")
        }
        if text.contains("곡류") {
            state = true
            changeState(CerealSwitch, "cerealSwitchState")
        }
        if text.contains("게") {
            state = true
            changeState(CrabSwitch, "crabSwitchState")
        }
        if text.contains("새우") {
            state = true
            changeState(ShrimpSwitch, "shrimpSwitchState")
        }
        
        if text.contains("땅콩") {
            state = true
            changeState(PeanutSwitch, "peanutSwitchState")
        }
        if text.contains("호두") {
            state = true
            changeState(WalnutSwitch, "walnutSwitchState")
        }
        if text.contains("고등어") {
            state = true
            changeState(MackerelSwitch, "mackerelSwitchState")
        }
        if text.contains("조개류") {
            state = true
            changeState(ShellfishSwitch, "shellfishSwitchState")
        }
        if text.contains("아산황류") {
            state = true
            changeState(SulfiteSwitch, "sulfiteSwitchState")
        }
        if text.contains("오징어") {
            state = true
            changeState(SquidSwitch, "squidSwitchState")
        }
        if text.contains("돼지고기") {
            state = true
            changeState(PorkSwitch, "porkSwitchState")
        }
        if text.contains("닭고기") {
            state = true
            changeState(ChickenSwitch, "chickenSwitchState")
        }
        if text.contains("쇠고기") {
            state = true
            changeState(BeefSwitch, "beefSwitchState")
        }
        if text.contains("토마토") {
            state = true
            changeState(TomatoSwitch, "tomatoSwitchState")
        }
        if text.contains("잣") {
            state = true
            changeState(PinenutSwitch, "pinenutSwitchState")
        }
        if state == false {
            textToSpeech("해당 알레르기가 존재하지 않습니다.",synthesizer)
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
        SwitchSetting(WalnutSwitch, "walnutSwitchState")
        SwitchSetting(MackerelSwitch, "mackerelSwitchState")
        SwitchSetting(ShellfishSwitch, "shellfishSwitchState")
        SwitchSetting(SulfiteSwitch, "sulfiteSwitchState")
        SwitchSetting(SquidSwitch, "squidSwitchState")
        SwitchSetting(PorkSwitch, "porkSwitchState")
        SwitchSetting(ChickenSwitch, "chickenSwitchState")
        SwitchSetting(BeefSwitch, "beefSwitchState")
        SwitchSetting(TomatoSwitch, "tomatoSwitchState")
        SwitchSetting(PinenutSwitch, "pinenutSwitchState")
    }
    func SwitchSetting(_ switchname: UISwitch, _ switchkeyname: String){
        UserDefaults.standard.set(switchname.isOn, forKey: switchkeyname)
    }
    func UserDefaultState(_ switchname: UISwitch, _ switchkeyname: String) {
        switchname.isOn = UserDefaults.standard.bool(forKey: switchkeyname)
    }
}

