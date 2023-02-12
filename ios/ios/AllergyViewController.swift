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
        UserDefaultState()
        // Do any additional setup after loading the view.
    }
    @IBAction func switchAction(_ sender: Any) {
        UserDefaults.standard.set(EggSwitch.isOn, forKey: "eggSwitchState")
    }
    
    @IBAction func switchAction1(_ sender: Any) {
        UserDefaults.standard.set(MilkSwitch.isOn, forKey: "milkSwitchState")
    }
    @IBAction func switchAction2(_ sender: Any) {
        UserDefaults.standard.set(CerealSwitch.isOn, forKey: "cerealSwitchState")
    }
    @IBAction func switchAction3(_ sender: Any) {
        UserDefaults.standard.set(CrabSwitch.isOn, forKey: "crabSwitchState")
    }
    @IBAction func switchAction4(_ sender: Any) {
        UserDefaults.standard.set(ShrimpSwitch.isOn, forKey: "shrimpSwitchState")
    }
    @IBAction func switchAction5(_ sender: Any) {
        UserDefaults.standard.set(PeanutSwitch.isOn, forKey: "peanutSwitchState")
    }
    func UserDefaultState() {
        EggSwitch.isOn =  UserDefaults.standard.bool(forKey: "eggSwitchState")
        MilkSwitch.isOn =  UserDefaults.standard.bool(forKey: "milkSwitchState")
        CerealSwitch.isOn =  UserDefaults.standard.bool(forKey: "cerealSwitchState")
        CrabSwitch.isOn =  UserDefaults.standard.bool(forKey: "crabSwitchState")
        ShrimpSwitch.isOn =  UserDefaults.standard.bool(forKey: "shrimpSwitchState")
        PeanutSwitch.isOn =  UserDefaults.standard.bool(forKey: "peanutSwitchState")
    }
}
