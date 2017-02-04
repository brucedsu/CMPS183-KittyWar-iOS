//
//  KWChanceDetailVC.swift
//  KittyWar
//
//  Created by Janet Zhang on 11/21/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWChanceDetailVC: UIViewController {
    
    @IBOutlet weak var chanceNameLabel: UILabel!
    var chanceName = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "kittybg.jpg")!)
        // Do any additional setup after loading the view.
        chanceNameLabel.text = chanceName
    }

    
}
