//
//  YearlyStatsViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 5/8/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class YearlyStatsViewController: UIViewController {
    
    @IBOutlet weak var yearLabel: UILabel!
    var yearsAgo = 0
    @IBOutlet weak var totalPagesReadLabel: UILabel!
    @IBOutlet weak var totalReadingSessionsLabel: UILabel!
    @IBOutlet weak var pagesReadPerSessionLabel: UILabel!
    @IBOutlet weak var pagesReadPerDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        setYear()
        setData()
    }
    
    func setYear() {
        let currentYear = Calendar.current.component(.year, from: Date.init(timeIntervalSinceNow: 0))
        let yearToDisplay = currentYear - yearsAgo
        yearLabel.text = "\(yearToDisplay)"
    }
    
    func setData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            if (sessions != nil) {
                var totalPagesRead = 0
                var totalNumOfSessions = 0
                var newTitlesRead = [String]()
                let currentYear = Calendar.current.component(.year, from: Date.init(timeIntervalSinceNow: 0))
                let year = currentYear - self.yearsAgo
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(i)"] as? NSDictionary
                    let yearOfEntry = sessionData?["year"] as? Int ?? 0
                    if (yearOfEntry == year) {
                        let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                        let title = sessionData?["title"] as? String ?? ""
                        if (!newTitlesRead.contains(title) && title != "") {
                            newTitlesRead.append(title)
                        }
                        totalPagesRead += pagesRead
                        totalNumOfSessions += 1
                    } else if (yearOfEntry <= year) {
                        break
                    }
                }
                let averagePagesReadPerSessionFloat = Double(totalPagesRead) / Double(totalNumOfSessions)
                var averagePagesReadPerSession = round(10*averagePagesReadPerSessionFloat)/10
                if (totalPagesRead == 0) {
                    averagePagesReadPerSession = 0.0
                }
                let averagePagesReadPerDayDouble = Double(totalPagesRead) / 30
                let averagePagesReadPerDay = round(10*averagePagesReadPerDayDouble) / 10
                self.totalPagesReadLabel.text =  "Total Pages Read: \(totalPagesRead)"
                self.totalReadingSessionsLabel.text = "Total Reading Sessions: \(totalNumOfSessions)"
                self.pagesReadPerSessionLabel.text = "Pages Read / Session: \(averagePagesReadPerSession)"
                self.pagesReadPerDayLabel.text = "Pages Read / Day: \(averagePagesReadPerDay)"
            }
        }
    }
    
    @IBAction func yearBeforePressed(_ sender: UIButton) {
        yearsAgo += 1
        setYear()
        setData()
    }
    
    @IBAction func yearAfterPressed(_ sender: UIButton) {
        if (yearsAgo != 0) {
            yearsAgo -= 1
            setYear()
            setData()
        }
    }
    
    
    
}
