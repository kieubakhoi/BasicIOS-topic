//
//  User.swift
//  BasicIOS-topic-SavingData
//
//  Created by Apple on 14/08/2021.
//

import Foundation
import RealmSwift

final class Book: Object {
    @objc dynamic var title = ""
    @objc dynamic var subTitle = ""
    @objc dynamic var price = 0
    
}
