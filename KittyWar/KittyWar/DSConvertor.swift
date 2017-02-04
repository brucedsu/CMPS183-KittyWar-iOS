//
//  DSConvertor.swift
//  KittyWar
//
//  Created by Hejia Su on 11/8/16.
//  Copyright © 2016 DeiSu. All rights reserved.
//

import Foundation

class DSConvertor {
    
    public static func intToByteArray(number: Int) -> [UInt8] {
        var result = [UInt8]()
        
        var _number: Int = number
        let mask8Bits = 0xFF
        
        for _ in (0 ..< MemoryLayout<Int>.size).reversed() {
            result.insert(UInt8(_number & mask8Bits), at: 0)
            _number >>= 8
        }
        
        return result
    }
    
    public static func stringToBytes(string: String) -> [UInt8] {
        var result = [UInt8]()
        
        for char in string.utf8 {
            result += [char]
        }
        
        return result
    }

}
