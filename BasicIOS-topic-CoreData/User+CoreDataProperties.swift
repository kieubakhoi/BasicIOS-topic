//
//  User+CoreDataProperties.swift
//  BasicIOS-topic-CoreData
//
//  Created by Apple on 15/08/2021.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var age: Int16
    @NSManaged public var gender: Bool
    @NSManaged public var name: String?

}
