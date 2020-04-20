//
//  SignUpViewController.swift
//  pagemaster
//
//  Created by Jack Antico on 4/17/20.
//  Copyright © 2020 Jack Antico. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
    }
    
    @IBAction func signUpPressed(_ sender: Any) {
        let email = emailTextField?.text ?? "Invalid Username"
        let password = passwordTextField?.text ?? "Invalid Password"
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user, error == nil {
                self.setData(path: "users/\(user.uid)", value: ["email": email])
                self.setData(path: "usersSettings/\(user.uid)/autoFill", value: ["setting": 1])
                self.performSegue(withIdentifier: "signUpToHome", sender: nil)
            } else {
                self.showErrorMessage(messageTitle: "Error:", messageText: "\(error!.localizedDescription)")
            }
        }
    }
    
}
