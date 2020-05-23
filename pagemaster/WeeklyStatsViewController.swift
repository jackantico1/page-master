//
//  WeeklyStatsViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 5/8/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class WeeklyStatsViewController: UIViewController {
    
    @IBOutlet weak var weekLabel: UILabel!
    var weeksAgo = 0
    @IBOutlet weak var totalPagesReadLabel: UILabel!
    @IBOutlet weak var totalReadingSessionsLabel: UILabel!
    @IBOutlet weak var pagesReadPerSessionLabel: UILabel!
    @IBOutlet weak var pagesReadPerDayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        setWeek()
        setData()
    }
    
    func setWeek() {
        if (weeksAgo == 0) {
            weekLabel.text = "Current Week"
        } else if (weeksAgo == 1){
            weekLabel.text = "\(weeksAgo) Week Ago"
        } else {
            weekLabel.text = "\(weeksAgo) Weeks Ago"
        }
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
                let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
                let weekNum = currentWeekOfYear - self.weeksAgo
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(i)"] as? NSDictionary
                    let weekOfEntry = sessionData?["weekOfYear"] as? Int ?? 0
                    if (weekOfEntry == weekNum) {
                        let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                        let title = sessionData?["title"] as? String ?? ""
                        if (!newTitlesRead.contains(title) && title != "") {
                            newTitlesRead.append(title)
                        }
                        totalPagesRead += pagesRead
                        totalNumOfSessions += 1
                    } else if (weekOfEntry <= weekNum){
                        break
                    }
                }
                let averagePagesReadPerSessionFloat = Double(totalPagesRead) / Double(totalNumOfSessions)
                var averagePagesReadPerSession = round(10*averagePagesReadPerSessionFloat)/10
                if (totalPagesRead == 0) {
                    averagePagesReadPerSession = 0.0
                }
                let averagePagesReadPerDayDouble = Double(totalPagesRead) / Double(Calendar.current.component(.weekday, from: Date()))
                let averagePagesReadPerDay = round(10*averagePagesReadPerDayDouble) / 10
                self.totalPagesReadLabel.text =  "Total Pages Read: \(totalPagesRead)"
                self.totalReadingSessionsLabel.text = "Total Reading Sessions: \(totalNumOfSessions)"
                self.pagesReadPerSessionLabel.text = "Pages Read / Session: \(averagePagesReadPerSession)"
                self.pagesReadPerDayLabel.text = "Pages Read / Day: \(averagePagesReadPerDay)"
            }
        }
    }
    
    @IBAction func weekBeforePressed(_ sender: UIButton) {
        if (weeksAgo != 0) {
            weeksAgo -= 1
            setWeek()
            setData()
        }
    }
    
    @IBAction func weekAfterPressed(_ sender: UIButton) {
        weeksAgo += 1
        setWeek()
        setData()
    }
}
