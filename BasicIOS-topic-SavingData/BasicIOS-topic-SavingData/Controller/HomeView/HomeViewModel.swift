//
//  HomeViewModel.swift
//  BasicIOS-topic-SavingData
//
//  Created by Apple on 15/08/2021.
//

import Foundation
import RealmSwift
final class HomeViewModel {
    private var books: [Book] = []
    
    enum Action {
        case reloadData
    }

    private var notificationToken: NotificationToken?
    
    //Data
    
    func fetchData(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(Book.self)
            print(Realm.Configuration.defaultConfiguration.fileURL)
            // convert to array
            books = Array(results)
            print(books[0].title)

            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
    }
    
    func deleteAll(completion: (Bool) -> ()) {
        do {
            // realm
            let realm = try Realm()
            
            // results
            let results = realm.objects(Book.self)
            
            // delete all items
            try realm.write {
                realm.delete(results)
            }
            
            // call back
            completion(true)
            
        } catch {
            // call back
            completion(false)
        }
    }
}
