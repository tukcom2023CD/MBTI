//
//  ViewController.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
// test

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func moveQR(_ sender: UIButton) {
        guard let svc = self.storyboard?.instantiateViewController(withIdentifier: "QRViewC") else {
            return
        }
        
        svc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        
        self.present(svc, animated: true)
    }
}

