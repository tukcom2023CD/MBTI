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


    @IBAction func QRView(_ sender: Any) {
        self.performSegue(withIdentifier: "QRShow", sender: self)
    }
}

