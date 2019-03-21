//
//  ViewController.swift
//  Core Data CRUD
//
//  Created by Suprianto Djamalu on 21/03/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet weak var tableUser:UITableView!
    
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Core Data"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(createData))
        
        tableUser.delegate = self
        tableUser.dataSource = self
        
        loadData()
        
    }


    @objc private func createData(){
        
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
 
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // entity for new record
        let userEntity = NSEntityDescription.entity(forEntityName: "EN_USER", in:managedContext)
        
        // creating alert for adding data
        let alert = UIAlertController(title: "New", message: "Fill text below", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Email"
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Full Name"
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.placeholder = "Phone"
        })
        
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            
            if (alert.textFields?[0].text?.isEmpty)! || (alert.textFields?[1].text?.isEmpty)! || (alert.textFields?[2].text?.isEmpty)! {
                
                let alert1 = UIAlertController(title: "Failed", message: "Field can't empty", preferredStyle: UIAlertController.Style.alert)
                
                alert1.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert1, animated: true)
                
            }else{
                
                // add data
                let user = NSManagedObject(entity:userEntity!, insertInto: managedContext)
                user.setValue(alert.textFields?[0].text, forKey: "user_email")
                user.setValue(alert.textFields?[1].text, forKey: "user_full_name")
                user.setValue(alert.textFields?[2].text, forKey: "user_phone")
                
                do{
                    try managedContext.save()
                }catch let error as NSError{
                    print(error)
                }
                
                self.loadData()
                
                
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    
    private func loadData(){
        
        users.removeAll()
        
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EN_USER")
        
        do{
            
            let result = try managedContext.fetch(fetchRequest) as! [NSManagedObject]
            
            for i in 0 ..< result.count{
                
                users.append(User(
                    result[i].value(forKey: "user_email") as! String,
                    result[i].value(forKey: "user_full_name") as! String,
                    result[i].value(forKey: "user_phone") as! String
                ))
                
            }
            
            tableUser.reloadData()
            
        }catch let e{
            print(e)
        }
        
    }
    
    func updateData(_ email:String, _ fullName:String, _ phone:String){
        
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data to update
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EN_USER")
        fetchRequest.predicate = NSPredicate(format: "user_email = %@", email)
        
        let alert = UIAlertController(title: "Update Data", message: "Update data below", preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: { tf in
            tf.text = email
            tf.isEnabled = false
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.text = fullName
        })
        
        alert.addTextField(configurationHandler: { tf in
            tf.text = phone
        })
        
        alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { action in
            
            if (alert.textFields?[1].text?.isEmpty)! || (alert.textFields?[2].text?.isEmpty)! {
                
                let alert1 = UIAlertController(title: "Failed", message: "Field can't empty", preferredStyle: UIAlertController.Style.alert)
                
                alert1.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                
                self.present(alert1, animated: true)
                
            }else{
                
                // update data
                do{
                    
                    let test = try managedContext.fetch(fetchRequest)
                    let objectUpdate = test[0] as! NSManagedObject
                    objectUpdate.setValue(alert.textFields?[0].text, forKey: "user_email")
                    objectUpdate.setValue(alert.textFields?[1].text, forKey: "user_full_name")
                    objectUpdate.setValue(alert.textFields?[2].text, forKey: "user_phone")
                    
                    try managedContext.save()
                    
                }catch let error as NSError{
                    print(error)
                }
                
                self.loadData()
                
                
            }
            
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
        
    }
    
    func deleteData(_ email:String){
        
        // refer to Appdelegate
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // create a context
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // fetch data to delete
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "EN_USER")
        fetchRequest.predicate = NSPredicate(format: "user_email = %@", email)
        
        let alert = UIAlertController(title: "Delete Data", message: "Delete data ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { action in
            
            // delete data
            do{
                
                let test = try managedContext.fetch(fetchRequest)
                let objectToDelete = test[0] as! NSManagedObject
                managedContext.delete(objectToDelete)
                
                try managedContext.save()
                
            }catch let e{
                print(e)
            }
            
            self.loadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true)
        
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewUserCell") as! ViewUserCell
        
        cell.setData(parent: self, users[indexPath.row])
        
        return cell
        
    }
    
}
