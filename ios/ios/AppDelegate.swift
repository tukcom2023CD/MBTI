//
//  AppDelegate.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        print(Realm.Configuration.defaultConfiguration.fileURL)
//
//        let product = DBProduct()
//        product.allergy = "밀, 대두, 우유, 계란, 돼지고기, 쇠고기, 닭고기"
//        product.productId = 19760342001242
//        product.manufacturer = "㈜농심"
//        product.productname = "육개장사발면"
//        let product1 = DBProduct()
//        product.productId = 2009044204019
//        product.allergy = "대두"
//        product.manufacturer = "(주)풀무원녹즙"
//        product.productname = "위러브플러스"
//        do {
//            let realm = try! Realm()
//            try! realm.write {
//                realm.add(product)
//                realm.add(product1)
//            }
//            } catch {
//                print("Error initialising new realm \(error)")
//
//
//            }
                
            return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

