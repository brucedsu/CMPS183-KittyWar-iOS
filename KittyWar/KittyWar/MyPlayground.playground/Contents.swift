//: Playground - noun: a place where people can play

import Foundation

class DeiSu {
    var sleep = 0 {
        didSet {
            print("Sleep")
        }
    }
}

let d = DeiSu()
d.sleep += 1

