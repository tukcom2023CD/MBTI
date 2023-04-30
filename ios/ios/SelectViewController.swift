//
//  SelectViewController.swift
//  ios
//
//  Created by 장지수 on 2023/04/02.
//

import Foundation
import UIKit

class SelectViewController : UIViewController {
    
    var selectedProduct: Product?
    var selectedDBProduct : [Product]?
    
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
        
    }
    @IBAction func QRButton(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
