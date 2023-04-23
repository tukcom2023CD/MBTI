//
//  Product.swift
//  ios
//
//  Created by 장지수 on 2023/03/07.
//
import Foundation
import RealmSwift

class Product: Object {
    @objc dynamic var productId:Int = 0
    @objc dynamic var allergy:String = ""
    @objc dynamic var productname:String = ""
    @objc dynamic var manufacturer:String = ""
    
    override static func primaryKey() -> String? {
         return "productId"
       }
}
