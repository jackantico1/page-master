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
        let startingPageNum = Int(startingPageNumStr) ?? 0
        let endingPageNum = Int(endingPageNumStr) ?? 0
        let pagesRead = endingPageNum - startingPageNum
        let uid = Auth.auth().currentUser?.uid
        getNumOfSessions { (numOfSessions) in
            self.writeData(path: "users/\(uid!)/sessions/session\(numOfSessions)", value: ["title": bookTitle, "startingPageNum": startingPageNum, "endingPageNum": endingPageNum, "pagesRead": pagesRead, "month": date[0], "year": date[1],"day": date[2]])
        }
    }
    
}

extension String {
    var isntInt: Bool {
        return Int(self) == nil
    }
}
