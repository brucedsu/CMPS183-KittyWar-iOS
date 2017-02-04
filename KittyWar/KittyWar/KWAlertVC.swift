//
//  KWAlertVC.swift
//  KittyWar
//
//  Created by Hejia Su on 11/3/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWAlertVC: UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK",
                                                style: UIAlertActionStyle.default,
                                                handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

}
