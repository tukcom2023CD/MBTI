//
//  TutorialViewController.swift
//  ios
//
//  Created by 박세인 on 2023/05/22.
//

import AVFoundation
import UIKit

class TutorialViewcontroller : UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func TutorialCheck(_ sender: Any) {
        var tutorialcheck = "OK"
        UserDefaults.standard.set(tutorialcheck, forKey: "tutorialcheckkey")
        self.dismiss(animated: true)
    }
}
