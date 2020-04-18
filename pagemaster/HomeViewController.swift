//
//  HomeViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 4/17/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTotalPagesRead()
    }
    
    func setTotalPagesRead() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            for session in sessions! {
                let sessionData = session.value as? NSDictionary
                print("sessionsData")
                print(sessionData)
                let pagesReadStr = sessionData?["pagesRead"] as? String ?? "0"
                print(pagesReadStr)
                
            }
        }
    }
    
}
