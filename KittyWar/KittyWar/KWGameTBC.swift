//
//  KWGameTBC.swift
//  KittyWar
//
//  Created by Hejia Su on 11/7/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWGameTBC: UITabBarController {
    
    private struct StoryBoard {
        static let welcomeNavController = "Welcome Nav Controller"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let token = UserDefaults.standard.object(forKey: KWUserDefaultsKey.token) {
            print("Token is \(token)")
            KWNetwork.shared.startReadingGameServerResponse()
        } else {
            // token doesn't exist
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginNav = storyboard.instantiateViewController(withIdentifier: StoryBoard.welcomeNavController)
            present(loginNav, animated: true, completion: nil)
        }
    }
    
}
