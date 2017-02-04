//
//  KWChanceTVC.swift
//  KittyWar
//
//  Created by Janet Zhang on 11/20/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWChanceTVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // add background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        // Do any additional setup after loading the view.
    }
    
    var chanceName: String?
    
    var chance = ["Double Purring", "Guaranteed Purring", "Purr and Draw", "Reverse Scratch", "Guard and Heal",
                  "Guard and Draw", "Can't Reverse", "Can't Guard", "Double Scratch"]
    
    // MARK: -Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chance.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChanceCell", for: indexPath)
        
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        //cell.textLabel?.text = content[indexPath.row]
        
        let chanceName = chance[indexPath.row]
        cell.textLabel?.text = chanceName
        //cell.detailTextLabel?.text = "Choose me! Meow~"
        cell.imageView?.image = UIImage(named: chanceName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showChance"{
            let vc = segue.destination as! KWChanceDetailVC
            //vc.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    chanceName = chance[index]
                    vc.chanceName = chanceName!
                    print(chanceName!)
                }
            }
        }
    }

    
    
    
    

  
}
