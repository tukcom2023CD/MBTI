//
//  ViewController.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
// test

import UIKit
import Speech

class MainViewController: UIViewController,SFSpeechRecognizerDelegate {

    
    @IBOutlet weak var SpeechView: UILabel!
    @IBOutlet weak var SpeechButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

