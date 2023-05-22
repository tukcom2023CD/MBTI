//
//  TutorialViewController.swift
//  ios
//
//  Created by 박세인 on 2023/05/22.
//

import AVFoundation
import UIKit

class TutorialViewcontroller : UIViewController{
    var tutorialcheck = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tutorialcheck = UserDefaults.standard.bool(forKey: "tutorialcheckkey")
    }
    @IBAction func TutorialCheck(_ sender: Any) {
        tutorialcheck = true
        UserDefaults.standard.set(tutorialcheck, forKey: "tutorialcheckkey")
    }
}
