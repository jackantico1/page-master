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
    
    
    @IBOutlet weak var totalPagesReadLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setWeeklyData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            if (sessions != nil) {
                var totalPagesRead = 0
                var totalNumOfSessions = sessions!.count
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(n)"] as? NSDictionary
                    let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                    totalPagesRead += pagesRead
                }
                let averagePagesReadPerDay = totalPagesRead / 7
                
            }
        }
    }
    
}
