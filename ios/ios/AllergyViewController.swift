//
//  AllergyViewController.swift
//  ios
//
//  Created by 장지수 on 2023/02/12.
//

import UIKit

class AllergyViewController: UITableViewController {
    
    @IBOutlet weak var MilkSwitch: UISwitch!
    @IBOutlet weak var EggSwitch: UISwitch!
    @IBOutlet weak var CerealSwitch: UISwitch!
    @IBOutlet weak var CrabSwitch: UISwitch!
    @IBOutlet weak var ShrimpSwitch: UISwitch!
    @IBOutlet weak var PeanutSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaultState(EggSwitch, "eggSwitchState")
        UserDefaultState(MilkSwitch, "milkSwitchState")
        UserDefaultState(CerealSwitch, "cerealSwitchState")
        UserDefaultState(CrabSwitch, "crabSwitchState")
        UserDefaultState(ShrimpSwitch, "shrimpSwitchState")
        UserDefaultState(PeanutSwitch, "peanutSwitchState")
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func switchAction(_ sender: UISwitch) {
        UserDefaults.standard.set(EggSwitch.isOn, forKey: "eggSwitchState")
        UserDefaults.standard.set(MilkSwitch.isOn, forKey: "milkSwitchState")
        UserDefaults.standard.set(CerealSwitch.isOn, forKey: "cerealSwitchState")
        UserDefaults.standard.set(CrabSwitch.isOn, forKey: "crabSwitchState")
        UserDefaults.standard.set(ShrimpSwitch.isOn, forKey: "shrimpSwitchState")
        UserDefaults.standard.set(PeanutSwitch.isOn, forKey: "peanutSwitchState")
    }
    func UserDefaultState(_ switchname: UISwitch, _ switchkeyname: String) {
        switchname.isOn = UserDefaults.standard.bool(forKey: switchkeyname)
    }
}

/*
 EggSwitch.isOn =  UserDefaults.standard.bool(forKey: "eggSwitchState")
 MilkSwitch.isOn =  UserDefaults.standard.bool(forKey: "milkSwitchState")
 CerealSwitch.isOn =  UserDefaults.standard.bool(forKey: "cerealSwitchState")
 CrabSwitch.isOn =  UserDefaults.standard.bool(forKey: "crabSwitchState")
 ShrimpSwitch.isOn =  UserDefaults.standard.bool(forKey: "shrimpSwitchState")
 PeanutSwitch.isOn =  UserDefaults.standard.bool(forKey: "peanutSwitchState")
 */
