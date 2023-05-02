//
//  SelectViewController.swift
//  ios
//
//  Created by 장지수 on 2023/04/02.
//

import AVFoundation
import UIKit

class SelectViewController : UIViewController {
    
    var selectedProduct: Product?
    var selectedDBProduct : [Product]?
    let synthesizer = AVSpeechSynthesizer()
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var manufacturer: UILabel!
    
    @IBOutlet weak var allergy: UILabel!
    
    @IBOutlet weak var DBTest: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        // 선택된 제품의 이름을 productNameLabel에 표시
        if selectedDBProduct == nil {
            productName.text = selectedProduct?.productName ?? "Unknown"
            manufacturer.text = selectedProduct?.manufacturer ?? "Unknown"
            allergy.text = selectedProduct?.allergy ?? "Unknown"
            DBTest.text = "DB에 없는 내용"
        }
        else {
            let firstProduct = selectedDBProduct?.first
            allergy.text = firstProduct?.allergy ?? "Unknown"
            productName.text = firstProduct?.productName ?? "Unknown"
            manufacturer.text = firstProduct?.manufacturer ?? "Unknown"
            DBTest.text = "DB에 있는 내용"
        }
        let productAllergy = allergy.text ?? ""
        let userDefaultAllergy = UserDefaults.standard.string(forKey: "myStringKey") ?? ""
        let productArray = productAllergy.components(separatedBy: ",")
        let userArray = userDefaultAllergy.components(separatedBy: ",")
        print(productArray)
        print(userArray)

        var checkAllergy = [String]()
        for allergy in productArray {
            let trimmedAllergy = allergy.trimmingCharacters(in: .whitespacesAndNewlines)
            if userArray.contains(trimmedAllergy) {
                checkAllergy.append(trimmedAllergy)
            }
        }

        let finalCheckAllergy = checkAllergy.joined(separator: ",")
        print(finalCheckAllergy)

        if !checkAllergy.isEmpty {
            textToSpeech("\(finalCheckAllergy) 알레르기를 유발하는 제품입니다. 주의하세요", synthesizer)
        }
    }
    @IBAction func QRButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
