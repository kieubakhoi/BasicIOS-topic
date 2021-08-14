//
//  Employee.swift
//  BasicIOS-topic-SavingData
//
//  Created by Apple on 14/08/2021.
//

import Foundation
import UIKit

class Employee: NSObject, NSCoding {

    
    // use User Default to save in file
    let name: String
    let dob: String
    // initializer
    init(name: String, dob: String) {
        self.name = name
        self.dob = dob
    }
    // init with NSCoder to decode
    required convenience init(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let dob = aDecoder.decodeObject(forKey: "dob") as! String
        self.init(name: name, dob: dob)
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.dob, forKey: "dob")
    }
}
