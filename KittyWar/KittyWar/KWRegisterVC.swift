//
//  KWRegisterVC.swift
//  KittyWar
//
//  Created by Hejia Su on 10/17/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWRegisterVC: KWAlertVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        // Do any additional setup after loading the view.
    }

    
    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var reenterEmailTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!
    
    // check whether the two passwords are the same
    private func twoEmailsAreSame() -> Bool {
        return emailTextField.text == reenterEmailTextField.text
    }
    
    @IBAction func register(_ sender: UIButton) {
        if !twoEmailsAreSame() {
            showAlert(title: "Email Error", message: "Two emails don't match")
            return
        }
        
        // register to notification center
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(KWRegisterVC.handleRegisterResult(notification:)),
                       name: registerResultNotification,
                       object: nil)
        
        // let network singleton register
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let email = emailTextField.text ?? ""
        KWNetwork.shared.register(username: username, email: email, password: password)
    }
    
    func handleRegisterResult(notification: Notification) {
        if let result = notification.userInfo?[InfoKey.result] as? RegisterResult {
            switch result {
            case .usernameIsTaken:
                showAlert(title: "Register Error",
                               message: "Username is taken")
                break
            case .success:
                showAlert(title: "Register Success",
                               message: "Register Success")
                break
            case .failure:
                showAlert(title: "Register Error",
                               message: "Registore Error")
                break
            }
        }
    }
    
}
