//
//  ViewController.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
// test

import UIKit
import Speech

class MainViewController: UIViewController,SFSpeechRecognizerDelegate {

    

    @IBOutlet weak var speechButton: UIButton!
    
    @IBOutlet weak var speechText: UITextView!
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
        } else {
            //startRecording()
            speechButton.setTitle("Stop Recording", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        speechRecognizer?.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

