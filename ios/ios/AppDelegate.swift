//
//  AppDelegate.swift
//  ios
//
//  Created by 장지수 on 2023/01/09.
//

import UIKit
import RealmSwift
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    override init() {
            super.init()
            do {
                try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.allowBluetooth, .allowAirPlay, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
            } catch let error {
                print(error.localizedDescription)
            }
        }
 
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if granted {
                // 마이크 권한이 허용된 경우에 대한 처리
                print("Microphone permission granted")
            } else {
                // 마이크 권한이 거부된 경우에 대한 처리
                print("Microphone permission denied")
            }
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestMicrophonePermission()
        // Override point for customization after application launch
        //
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

