//
//  AddSessionViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 4/17/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class AddSessionViewController: UIViewController {
    
    @IBOutlet weak var bookTitleField: UITextField!
    @IBOutlet weak var startingPageNumField: UITextField!
    @IBOutlet weak var endingPageNumField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        wantsAutoFillSetting { (wantsSetting) in
            if (wantsSetting) {
                self.addLastSessionData()
            }
        }
    }
    
    @IBAction func addReadingSessionPressed(_ sender: UIButton) {
        let bookTitle = bookTitleField.text ?? "Invalid Title"
        let startingPageNumStr = startingPageNumField.text ?? "0"
        let endingPageNumStr = endingPageNumField.text ?? "0"
        if (startingPageNumStr.isntInt || endingPageNumStr.isntInt) {
            showErrorMessage(messageTitle: "Error:", messageText: "Please enter a number for the starting and ending page numbers.")
            return
        }
        let date = returnDayMonthYear()
        let weekOfYear = NSDateComponents().weekOfYear
        let startingPageNum = Int(startingPageNumStr) ?? 0
        let endingPageNum = Int(endingPageNumStr) ?? 0
        let pagesRead = endingPageNum - startingPageNum
        let uid = Auth.auth().currentUser?.uid
        getNumOfSessions { (numOfSessions) in
            self.setData(path: "users/\(uid!)/sessions/session\(numOfSessions)", value: ["title": bookTitle, "startingPageNum": startingPageNum, "endingPageNum": endingPageNum, "pagesRead": pagesRead, "month": date[0], "year": date[1], "day": date[2], "weekOfYear": weekOfYear])
        }
    }
    
    func addLastSessionData() {
        let uid = Auth.auth().currentUser?.uid
        getDataSnapshot(path: "users/\(uid!)/sessions") { (snapshot) in
            let sessionNum = Int(snapshot.childrenCount) - 1
            let value = snapshot.value as? NSDictionary
            let sessionData = value?["session\(sessionNum)"] as? NSDictionary
            let lastBookTitleRead = sessionData?["title"] as? String ?? ""
            let lastPageNum = sessionData?["endingPageNum"] as? Int ?? 0
            self.bookTitleField.text = lastBookTitleRead
            self.startingPageNumField.text = "\(lastPageNum)"
        }
    }
    
    func wantsAutoFillSetting(completion: @escaping (Bool) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("usersSettings/\(uid!)/autoFill").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let settingInt = value?["setting"] as? Int ?? 1
            let settingBool = settingInt == 1
            completion(settingBool)
        }) { (error) in
            self.showErrorMessage(messageTitle: "Error:", messageText: error.localizedDescription)
        }
    }
    
}

extension String {
    var isntInt: Bool {
        return Int(self) == nil
    }
}
