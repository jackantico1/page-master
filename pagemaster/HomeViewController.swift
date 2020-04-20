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
    
    var titlesRead = ["", "", "", "", ""]
    @IBOutlet weak var timePeriodSelected: UISegmentedControl!
    @IBOutlet weak var totalPagesReadLabel: UILabel!
    @IBOutlet weak var totalReadingSessionsLabel: UILabel!
    @IBOutlet weak var pagesReadPerSession: UILabel!
    @IBOutlet weak var pagesReadPerDayLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadData()
    }
    
    @IBAction func timePeriodChanged(_ sender: UISegmentedControl) {
        loadData()
    }
    
    func loadData() {
        if (timePeriodSelected.selectedSegmentIndex == 0) {
            setWeeklyData()
        } else if (timePeriodSelected.selectedSegmentIndex == 1) {
            setMonthlyData()
        } else if (timePeriodSelected.selectedSegmentIndex == 2) {
            setYearlyData()
        }
    }
    
    
    func setWeeklyData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            if (sessions != nil) {
                var totalPagesRead = 0
                var newTitlesRead = [String]()
                let totalNumOfSessions = sessions!.count
                let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: Date.init(timeIntervalSinceNow: 0))
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(i)"] as? NSDictionary
                    let weekOfEntry = sessionData?["weekOfYear"] as? Int ?? 0
                    if (weekOfEntry == currentWeekOfYear) {
                        let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                        let title = sessionData?["title"] as? String ?? ""
                        if (!newTitlesRead.contains(title) && title != "") {
                            newTitlesRead.append(title)
                        }
                        totalPagesRead += pagesRead
                    } else {
                        break
                    }
                }
                let averagePagesReadPerSession = totalPagesRead / totalNumOfSessions
                let averagePagesReadPerDay = totalPagesRead / Calendar.current.component(.weekday, from: Date())
                self.titlesRead = newTitlesRead
                self.totalPagesReadLabel.text =  "Total Pages Read: \(totalPagesRead)"
                self.totalReadingSessionsLabel.text = "Total Reading Sessions: \(totalNumOfSessions)"
                self.pagesReadPerSession.text = "Pages Read / Session: \(averagePagesReadPerDay)"
                self.pagesReadPerDayLabel.text = "Pages Read / Day: \(averagePagesReadPerDay)"
                print("titlesRead: \(self.titlesRead)")
                self.tableView.reloadData()
            }
        }
    }
    
    func setMonthlyData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            if (sessions != nil) {
                var totalPagesRead = 0
                let totalNumOfSessions = sessions!.count
                let currentMonth = Calendar.current.component(.month, from: Date.init(timeIntervalSinceNow: 0))
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(i)"] as? NSDictionary
                    let monthOfEntry = sessionData?["month"] as? Int ?? 0
                    if (monthOfEntry == currentMonth) {
                        let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                        totalPagesRead += pagesRead
                    } else {
                        break
                    }
                }
                let averagePagesReadPerDay = totalPagesRead / 29
                self.totalPagesReadLabel.text =  "Total Pages Read: \(totalPagesRead)"
                self.totalReadingSessionsLabel.text = "Total Reading Sessions: \(totalNumOfSessions)"
                self.pagesReadPerDayLabel.text = "Pages Read / Day: \(averagePagesReadPerDay)"
            }
        }
    }
    
    func setYearlyData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)") { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let sessions = value?["sessions"] as? NSDictionary
            if (sessions != nil) {
                var totalPagesRead = 0
                let totalNumOfSessions = sessions!.count
                let currentYear = Calendar.current.component(.year, from: Date.init(timeIntervalSinceNow: 0))
                var i = 0
                for n in 0...(sessions!.count - 1) {
                    i = (sessions!.count - 1) - n
                    let sessionData = sessions!["session\(i)"] as? NSDictionary
                    let yearOfEntry = sessionData?["year"] as? Int ?? 0
                    if (yearOfEntry == currentYear) {
                        let pagesRead = sessionData?["pagesRead"] as? Int ?? 0
                        totalPagesRead += pagesRead
                    } else {
                        break
                    }
                }
                let averagePagesReadPerDay = totalPagesRead / 365
                self.totalPagesReadLabel.text =  "Total Pages Read: \(totalPagesRead)"
                self.totalReadingSessionsLabel.text = "Total Reading Sessions: \(totalNumOfSessions)"
                self.pagesReadPerDayLabel.text = "Pages Read / Day: \(averagePagesReadPerDay)"
            }
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titlesRead.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = titlesRead[indexPath.row]
        return cell
    }
}
