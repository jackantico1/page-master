//
//  ViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 4/17/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @IBAction func signInPressed(_ sender: UIButton) {
        let email =  emailTextField?.text ?? "Invalid email"
        let password = passwordTextField?.text ?? "Invalid password"
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
            if error == nil {
                self?.performSegue(withIdentifier: "logInToHome", sender: nil)
            } else {
                self?.showErrorMessage(messageTitle: "Error:", messageText: "\(error!.localizedDescription)")
            }
        }
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "logInToSignUp", sender: nil)
    }
    
}

extension UIViewController {
    func setData(path: String, value: [String: Any]) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child(path).setValue(value)
    }
    
    func getDataSnapshot(path: String, completion: @escaping (DataSnapshot) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        ref.child("\(path)").observeSingleEvent(of: .value, with: { (snapshot) in
            completion(snapshot)
        }) { (error) in
            self.showErrorMessage(messageTitle: "Error:", messageText: error.localizedDescription)
        }
    }
    
    func getNumOfSessions(completion: @escaping (Int) -> ()) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = Auth.auth().currentUser?.uid
        ref.child("users/\(uid!)/sessions").observeSingleEvent(of: .value, with: { (snapshot) in
            let numOfSessions = Int(snapshot.childrenCount)
            self.logSomething(data: snapshot)
            completion(numOfSessions)
        }) { (error) in
            self.showErrorMessage(messageTitle: "Error:", messageText: error.localizedDescription)
        }
    }
    
    func showErrorMessage(messageTitle: String, messageText: String) {
        let alert = UIAlertController(title: messageTitle, message: messageText, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func returnDayMonthYear() -> [Int] {
        let day = Calendar.current.component(.day, from: Date.init(timeIntervalSinceNow: 0))
        let month = Calendar.current.component(.month, from: Date.init(timeIntervalSinceNow: 0))
        let year = Calendar.current.component(.year, from: Date.init(timeIntervalSinceNow: 0))
        return [day, month, year]
    }
    
    func returnMonthName(monthNum: Int) -> String {
        switch monthNum {
        case 1:
            return "January"
        case 2:
            return "Febuary"
        case 3:
            return "March"
        case 4:
            return "Abril"
        case 5:
            return "May"
        case 6:
            return "June"
        case 7:
            return "July"
        case 8:
            return "August"
        case 9:
            return "September"
        case 10:
            return "October"
        case 11:
            return "November"
        case 12:
            return "December"
        default:
            return "January"
        }
    }
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard))

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
    
    func logSomething(data: Any) {
        print("")
        print("")
        print("")
        print(data)
        print("")
        print("")
        print("")
    }
}



