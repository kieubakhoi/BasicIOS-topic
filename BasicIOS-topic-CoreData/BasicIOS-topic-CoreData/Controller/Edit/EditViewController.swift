//
//  EditViewController.swift
//  BasicIOS-topic-CoreData
//
//  Created by Apple on 15/08/2021.
//

import UIKit

class EditViewController: UIViewController {

    var user: User!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var genderSegmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK: - Config
    func setupUI() {
        title = "Edit"
        
        //navigation bar
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        self.navigationItem.rightBarButtonItem = doneBarButtonItem
    }
    func setupData() {
        if let user = user {
            nameTextField.text = user.name
            ageTextField.text = "\(user.age)"
            genderSegmentedControl.selectedSegmentIndex = user.gender ? 0 : 1
            
        }
    }
    @objc func done () {
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // set value for object
        user.name = nameTextField.text
        user.age = Int16(ageTextField.text!) ?? 0
        user.gender = genderSegmentedControl.selectedSegmentIndex == 0 ? true : false
        
        // save context
        do {
            try managedContext.save()
            self.navigationController?.popViewController(animated: true)
        } catch  let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
