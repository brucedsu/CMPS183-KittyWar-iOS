//
//  KWUserDefaults.swift
//  KittyWar
//
//  Created by Hejia Su on 11/3/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import Foundation

struct KWUserDefaultsKey {
    static let token = "token"
    static let username = "username"
}

class KWUserDefaults {
    
    class func getToken() -> String {
        return (UserDefaults.standard.object(forKey: KWUserDefaultsKey.token) as? String) ?? ""
    }
    
    class func getUsername() -> String {
        return (UserDefaults.standard.object(forKey: KWUserDefaultsKey.username) as? String) ?? ""
    }
    
}
