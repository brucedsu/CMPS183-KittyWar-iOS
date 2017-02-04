//
//  KWKittyVC.swift
//  KittyWar
//
//  Created by Janet Zhang on 11/20/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWKittyVC: UIViewController {

    @IBOutlet weak var kittyNameLabel: UILabel!
    var kittyName = ""
    var kittyInfo = ""

    @IBOutlet weak var kittyImg: UIImageView!
    
    @IBOutlet weak var kittyInfoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "kittybg.jpg")!)
        
        kittyNameLabel.text = kittyName
        kittyImg.image = UIImage(named: kittyName)
        kittyInfoLabel.text = kittyInfo
    }
    
}
