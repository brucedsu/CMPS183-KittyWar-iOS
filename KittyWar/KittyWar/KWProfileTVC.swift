//
//  KWProfileTVC.swift
//  KittyWar
//
//  Created by Hejia Su on 10/17/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWProfileTVC: UITableViewController {

    @IBOutlet private weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameLabel.text = KWUserDefaults.getUsername()
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        
    }
    
}
