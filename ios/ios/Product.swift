//
//  Product.swift
//  ios
//
//  Created by 장지수 on 2023/03/07.
//
import Foundation
import RealmSwift

class Product: Object {
    @objc dynamic var prdno:String = "0"
    @objc dynamic var allergy:String = ""
    @objc dynamic var num:Int = 0
    
    override static func primaryKey() -> String? {
         return "num"
       }
}
