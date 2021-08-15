//
//  HomeViewController.swift
//  BasicIOS-topic-CoreData
//
//  Created by Apple on 15/08/2021.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet weak var tableView: UITableView!
    
    var fetchedResultsController: NSFetchedResultsController<User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
    }
    
    //MARK: - config
    func setupUI() {
        title = "Home"
        
        // table view
        tableView.delegate = self
        tableView.dataSource = self
        
        let nib = UINib(nibName: "HomeCell", bundle: .main)
        tableView.register(nib, forCellReuseIdentifier: "cell")
        
        //navigation bar
        let addNewBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(gotoAddNew))
        self.navigationItem.rightBarButtonItem = addNewBarButtonItem
        let deleteBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteAll))
        self.navigationItem.leftBarButtonItem = deleteBarButtonItem
        
        
    }
    func setupData() {
//        save(name: "Tí", age: 10, gender: true)
//        save(name: "Tèo", age: 12, gender: true)
//        save(name: "Linh", age: 9, gender: false)
//        save(name: "Trang", age: 8, gender: false)
        initializeFetchResultsController()
    }
    @objc func gotoAddNew() {
        let vc = NewViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func deleteAll() {
        let alert = UIAlertController(title: "Confirm",
                                      message: "Do you want to delete all items?",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK", style: .default ) {
            (alert) in
            print("Delete All")
        
        // lấy AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // lấy Managed Object Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Create Fetch Request
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        
        // Initialize Batch Delete Request
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            // execute delete
            try managedContext.execute(deleteRequest)
            
            // save
            try managedContext.save()
            
            // Perform Fetch
            try self.fetchedResultsController.performFetch()
            
            // Reload Table View
            self.tableView.reloadData()
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    //MARK: - dummy Data
    func save(name: String, age: Int, gender: Bool) {
        // get AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get Manager Context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Make entity name
        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
        
        // make new Object and insert in Manager Object Context
        let user = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // set value for new object
        user.setValue(name, forKey: "name")
        user.setValue(age, forKey: "age")
        user.setValue(gender, forKey: "gender")
        
        do {
            // save
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! HomeCell
        
        let user = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = user.name
        cell.genderLabel.text = user.gender ? "Male" : "Female"
        cell.ageLabel.text = "\(user.age) years old"
        
        return cell
    }
    // get id to get update
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = EditViewController()
        
        // get object and fill to
        vc.user = fetchedResultsController.object(at: indexPath)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // get action "style edit" to get delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // lấy AppDelegate
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            // lấy Managed Object Context
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // get  item(user) to delete
            let user = fetchedResultsController.object(at: indexPath)
            //delete
            managedContext.delete(user)
            
            //save context
            do {
                try managedContext.save()
            } catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }


}

//MARK: - Core Data
extension HomeViewController: NSFetchedResultsControllerDelegate {
    // init fetch result
    func initializeFetchResultsController() {
        
        //Create Fetch Request
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        
//        // Predicate
//        fetchRequest.predicate = NSPredicate(format: "gender == false")
        //Config Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        // get AppDelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        // get Manager Object Conext
        let managedContext = appDelegate.persistentContainer.viewContext
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                              managedObjectContext: managedContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
    }
    // delegate
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            print("insert")
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .delete:
            print("delete")
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            print("update")
            tableView.reloadRows(at: [indexPath!], with: .automatic)
            break;
        default:
            print("default")
        }
    }
}
