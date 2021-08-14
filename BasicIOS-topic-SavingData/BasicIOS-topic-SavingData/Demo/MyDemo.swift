//
//  MyDemo.swift
//  BasicIOS-topic-SavingData
//
//  Created by Apple on 14/08/2021.
//

import Foundation

class MyDemo {
    func save(key: String, value: Any){
        let myData: NSDictionary = [key: value]
        let fileManager = FileManager.default
        
        // make url and name
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyInfo2.plist")
        // write file and make a new file if not exist
        myData.write(to: path, atomically: true)
        //print path of file Property list
        print(path)
    }
    
    func getMyPList(key: String)-> Any? {
        // get url file Property list
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyInfo2.plist")
        // using NSDictionary to get content
        guard let myDict = NSDictionary(contentsOf: path) else { return nil }
        //print path of file Property list
        print(path)
        // return value from key in Dictionary
        print("The value is:  \(myDict[key] ?? "not found")")
        return myDict[key]
    }
    
    func saveMyPList(key: String, value: Any) {
        let fileManager = FileManager.default
        // make url file
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyInfo2.plist")
        guard let myDict = NSMutableDictionary(contentsOf: path) else {
            // if file is not exist , save in new file with first key and value
            let myData: NSDictionary = [key: value]
            myData.write(to: path, atomically: true)
            return
        }
        // if file is exist, update the value
        myDict[key] = value
        myDict.write(to: path, atomically: true)
        print("the value is \(myDict[key] ?? "not found")")
        print(path)
    }
    
    func removeMyPList(key: String) {
        let fileManager = FileManager.default
        
        let path = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("MyInfo2.plist")
        guard let myDict = NSMutableDictionary(contentsOf: path) else { return  }
        // if file is exist, update value
        myDict.removeObject(forKey: key)
        myDict.write(to: path, atomically: true)
        print("Remove done")
    }
}
