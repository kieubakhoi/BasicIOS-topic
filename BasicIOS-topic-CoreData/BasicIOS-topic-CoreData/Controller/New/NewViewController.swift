//
//  NewViewController.swift
//  BasicIOS-topic-CoreData
//
//  Created by Apple on 15/08/2021.
//

import UIKit
import CoreData
class NewViewController: UIViewController {

    @IBOutlet weak var genderSegmetedControl: UISegmentedControl!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var ageTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }

    func setupUI() {
        title = "New"
        
        //navigation bar
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    
    func setupData() {
        
    }
    
    //MARK: - Navigation Bar
    @objc func done () {
        // get AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get Manager Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // get Entity name
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        // make new Manager Object --> insert
        let user = User(entity: entity, insertInto: managedContext)
        
        // set value for  new object
        user.name = nameTextField.text
        user.age = Int16(ageTextField.text!) ?? 0
        user.gender = genderSegmetedControl.selectedSegmentIndex == 0 ? true: false
        
        //save context
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
