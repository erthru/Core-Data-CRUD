//
//  ViewUserCell.swift
//  Core Data CRUD
//
//  Created by Suprianto Djamalu on 21/03/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import UIKit

class ViewUserCell: UITableViewCell {

    @IBOutlet weak var lbEmail:UILabel!
    @IBOutlet weak var lbFullName:UILabel!
    @IBOutlet weak var lbPhone:UILabel!
    
    var user: User!
    var parent: ViewController!
    
    func setData(parent: ViewController,_ user:User){
        self.user = user
        self.parent = parent
        
        lbEmail.text = user.email
        lbFullName.text = user.full_name
        lbPhone.text = user.phone
    }
    
    @IBAction func updateData(){
        parent.updateData(user.email,user.full_name,user.phone)
    }
    
    @IBAction func deleteData(){
        parent.deleteData(user.email)
    }

}
