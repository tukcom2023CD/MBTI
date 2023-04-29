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
    @IBAction func mainButton(_ sender: Any) {
        let mainViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
        mainViewController.modalPresentationStyle = .fullScreen // 화면이 사라지지 않는 문제가 계속 발생할 경우 추가해주세요.
        self.present(mainViewController, animated: true, completion: nil)
    }
    @IBAction func QRButton(_ sender: Any) {
//
//            let qrViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRReaderView")
//            as! QRViewController
//            qrViewController.modalPresentationStyle = .fullScreen
//            self.present(qrViewController,animated: true,completion: nil)
        if let qrViewController = self.navigationController?.viewControllers.first(where: { $0 is QRViewController }) as? QRViewController {
            // QRViewController가 navigationController 스택 안에 있다면 navigationController 스택에서 그것을 pop합니다.
            self.navigationController?.popToViewController(qrViewController, animated: true)
            qrViewController.modalPresentationStyle = .fullScreen
        } else {
            // QRViewController가 navigationController 스택 안에 없다면 present를 이용하여 그것을 보여줍니다.
            let qrViewController = self.storyboard?.instantiateViewController(withIdentifier: "QRReaderView") as! QRViewController
            qrViewController.modalPresentationStyle = .fullScreen
            self.present(qrViewController, animated: true, completion: nil)
        }
    }
}
