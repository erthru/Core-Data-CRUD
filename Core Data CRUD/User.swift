//
//  User.swift
//  Core Data CRUD
//
//  Created by Suprianto Djamalu on 21/03/19.
//  Copyright © 2019 Suprianto Djamalu. All rights reserved.
//

import Foundation

class User{
    
    var email:String
    var full_name:String
    var phone:String
    
    init(_ email:String, _ full_name:String, _ phone:String) {
        
        self.email = email
        self.full_name = full_name
        self.phone = phone
        
    }
    
}
