//
//  KWLoginVC.swift
//  KittyWar
//
//  Created by Hejia Su on 10/17/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit
import Starscream

class KWLoginVC: KWAlertVC {

    override func viewDidLoad() {
        super.viewDidLoad()
        // add background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)

        // Do any additional setup after loading the view.
    }


    @IBOutlet private weak var usernameTextField: UITextField!
    @IBOutlet private weak var passwordTextField: UITextField!

    private struct StoryBoard {

    }

    @IBAction func login(_ sender: UIButton) {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""

        // register to notification center
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(KWLoginVC.handleLoginResult(notification:)),
                       name: loginResultNotification,
                       object: nil)

        // login
        KWNetwork.shared.webServerLogin(username: username, password: password)
    }

    func handleLoginResult(notification: Notification) {
        if let result = notification.userInfo?[WebServerResponseKey.result] as? LoginResult {
            switch result {
            case .success:
                print("Login Success")

                // save username locally
                UserDefaults.standard.set(notification.userInfo?[InfoKey.username] as! String,
                                          forKey: KWUserDefaultsKey.username)

                // save token locally
                UserDefaults.standard.set(notification.userInfo?[InfoKey.token] as! String,
                                          forKey: KWUserDefaultsKey.token)

                // dismiss the login navigation controller
                navigationController?.presentingViewController?.dismiss(animated: true, completion: nil)
                break
            case .failure:
                // alert fail
                showAlert(title: "Login Fail",
                          message: "Username or password is wrong")
                break
            }
        }
    }

}
