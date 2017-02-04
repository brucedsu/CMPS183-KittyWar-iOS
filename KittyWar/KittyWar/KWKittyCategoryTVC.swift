//
//  KWKittyCategoryTableViewController.swift
//  KittyWar
//
//  Created by Janet Zhang on 11/8/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import UIKit

class KWKittyCategoryTVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // add background img
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
        
        // Do any additional setup after loading the view.
    }
    
    
    
    var cats = ["Abyssinian Cat", "Exotic Shorthair Cat", "Maine Coon Cat", "Persian Cat", "Ragdoll Cat", "Siamese Cat"]
    
    var kittyName: String?
    var kittyInfo: String?
    
    // MARK: -Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cats.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        //cell.textLabel?.text = "Section \(indexPath.section) Row \(indexPath.row)"
        //cell.textLabel?.text = content[indexPath.row]
        
        let catName = cats[indexPath.row]
        cell.textLabel?.text = catName
        cell.detailTextLabel?.text = "Choose me! Meow~"
        cell.imageView?.image = UIImage(named: catName)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showKitty"{
            let vc = segue.destination as! KWKittyVC
            //vc.view.backgroundColor = UIColor(patternImage: UIImage(named: "background.jpg")!)
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = indexPath?.row {
                    kittyName = cats[index]
                    vc.kittyName = kittyName!
                    print(kittyName!)
                }
            }
        }
    }

    
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Kitty Category"
//    }

}
