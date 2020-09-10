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
    
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "settingsToLogIn", sender: nil)
    }
    
    @IBAction func deleteAccountPressed(_ sender: UIButton) {
        
        let deleteAlert = UIAlertController(title: "Delete Account:", message: "Are you sure you want to permanently delete your account?", preferredStyle: UIAlertController.Style.alert)

        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
              let user = Auth.auth().currentUser
              user?.delete { error in
                  if error != nil {
                      self.showErrorMessage(messageTitle: "Error:", messageText: "For some reason your account couldn't be deleted. Please text me at +18606144966 and I will delete your account.")
                  } else {
                      //Actual data on database won't get deleted
                      self.performSegue(withIdentifier: "settingsToLogIn", sender: nil)
                  }
              }
        }))

        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
              
        }))

        present(deleteAlert, animated: true, completion: nil)
        
    }
    
}
