//
//  KWFindMatch.swift
//  KittyWar
//
//  Created by Hejia Su on 10/17/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWFindMatchVC: KWAlertVC {

    private struct StoryBoard {
        static let gameViewControllerSegue = "Game View Controller Segue"
    }

    @IBOutlet weak var findMatchIndicator: UIActivityIndicatorView!

    @IBAction func findMatch(_ sender: UIButton) {
        // register to notification center
        let nc = NotificationCenter.default
        nc.addObserver(self,
                       selector: #selector(KWFindMatchVC.handleFindMatchResult(notification:)),
                       name: findMatchResultNotification,
                       object: nil)

        // find match indicator start animation
        findMatchIndicator.startAnimating()

        // find game
        KWNetwork.shared.findMatch()
    }

    func handleFindMatchResult(notification: Notification) {
        // stop animate the indicator
        findMatchIndicator.stopAnimating()

        if let result = notification.userInfo?[InfoKey.result] as? FindMatchResult {
            switch result {
            case .success:
                // successfully found a match
                performSegue(withIdentifier: StoryBoard.gameViewControllerSegue, sender: self)
            case .failure:
                showAlert(title: "Find Match Failed", message: "Find match failed")
            }
        }
    }

}

