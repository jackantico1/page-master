//
//  SettingsViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 4/18/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {
    
    
    @IBOutlet weak var autoFillSetting: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAutoFillSetting()
    }
    
    @IBAction func autoFillSettingChanged(_ sender: UISegmentedControl) {
        let uid = Auth.auth().currentUser?.uid
        setData(path: "usersSettings/\(uid!)/autoFill", value: ["setting": (autoFillSetting.selectedSegmentIndex)])
    }
    
    func setAutoFillSetting() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "usersSettings/\(uid!)/autoFill") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let setting = value?["setting"] as? Int ?? 1
            self.autoFillSetting.selectedSegmentIndex = setting
        }
    }
    
}
