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
    
    @IBOutlet weak var productName: UILabel!
    
    @IBOutlet weak var manufacturer: UILabel!
    
    @IBOutlet weak var allergy: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.frame = UIScreen.main.bounds
        // 선택된 제품의 이름을 productNameLabel에 표시
        productName.text = selectedProduct?.productName ?? "Unknown"
        manufacturer.text = selectedProduct?.manufacturer ?? "Unknown"
        allergy.text = selectedProduct?.allergy ?? "Unknown"
    }
    @IBAction func mainButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        
    }
}
