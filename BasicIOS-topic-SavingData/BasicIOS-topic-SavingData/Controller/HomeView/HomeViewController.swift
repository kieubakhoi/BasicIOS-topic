//
//  HomeViewController.swift
//  BasicIOS-topic-SavingData
//
//  Created by Apple on 14/08/2021.
//

import UIKit
import RealmSwift
class HomeViewController: UIViewController {
    
    var viewmodel = HomeViewModel()

    var myPList = MyDemo()
    var employee = Employee(name: "Khoi", dob: "28/02/2000")
    override func viewDidLoad() {
        super.viewDidLoad()
        // Property List
//        myPList.save(key: "Greeting", value: "Hello everyone")
//        myPList.getMyPList(key: "Greeting")
//        myPList.saveMyPList(key: "Greeting", value: "Hello part 2")
//        myPList.removeMyPList(key: "Greeting")
        
        // User Default
//        // save
//        let udf = UserDefaults.standard
//        do {
//            let encodeData = try NSKeyedArchiver.archivedData(withRootObject: employee, requiringSecureCoding: false)
//            udf.set(encodeData,forKey: "emp")
//            udf.synchronize()
//        } catch {
//            print(error)
//        }
//        // get
//        guard let decode = udf.data(forKey: "emp") else { return }
//        let decodeEmp = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decode) as? Employee
//        print(decodeEmp?.name ?? "not found")
//        print(decodeEmp?.dob ?? "not found")
        
        //using Keychain
//        savePass("kbk2000", for: "khoikb")
//        print(getPass(for: "khoikb"))
        
        // using Realm
        setupData()
//        deleteAll()
    }
    // keychain
    func savePass(_ password: String, for account: String) {
        let password = password.data(using: String.Encoding.utf8)
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrAccount as String : account,
                                    kSecValueData as String: password! ]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            return print("Save error")
        }
    }
    func getPass(for account:String) -> String {
        let query:[String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                     kSecAttrAccount as String: account,
                                     kSecMatchLimit as String: kSecMatchLimitOne,
                                     kSecReturnData as String: kCFBooleanTrue!]
        var retrivedData: AnyObject? = nil
        let _ = SecItemCopyMatching(query as CFDictionary, &retrivedData)
        guard let data = retrivedData as? Data else { return "Error" }
        return String(data: data, encoding: String.Encoding.utf8)!
    }
    //Realm
    func setupData() {
        //Dummy Data
//        addBook(title: "M???t Bi???c", subTitle: "Truy???n d??i t??nh c???m", price: 100000)
//        addBook(title: "?????c nh??n t??m", subTitle: "S??ch gi??p ?????i gi??p ng?????i", price: 100000)
        
        //fetch data
        fetchData()
    }
    func fetchData() {
        viewmodel.fetchData { (done) in
            if done {
                print("Data added")
            } else {
                print("L???i fetch data t??? realm")
            }
        }
    }
    func deleteAll() {
        viewmodel.deleteAll { (done) in
            if done {
                self.fetchData()
                print("Deleting done")
            } else {
                print("L???i xo?? t???t c??? ?????i t?????ng")
            }
        }
    }
    //MARK: - Realm data
    func addBook(title: String, subTitle: String, price: Int) {
        // t???o realm
        let realm = try! Realm()
        
        // t???o 1 book
        let book = Book()
        book.title = title
        book.subTitle = subTitle
        book.price = price
        
        //realm write
        try! realm.write {
            realm.add(book)
        }
    }

}
