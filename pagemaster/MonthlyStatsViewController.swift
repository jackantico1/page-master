//
//  MonthlyStatsViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 5/8/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class MonthlyStatsViewController: UIViewController {
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var totalPagesRead: UILabel!
    @IBOutlet weak var totalReadingSessionsLabel: UILabel!
    @IBOutlet weak var pagesReadPerSessionLabel: UILabel!
    @IBOutlet weak var pagesReadPerDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @IBAction func monthBeforePressed(_ sender: UIButton) {
    }

    @IBAction func monthAfterPressed(_ sender: UIButton) {
    }
    
    
}
