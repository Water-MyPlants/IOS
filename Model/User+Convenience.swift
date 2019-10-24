//
//  User+Convenience.swift
//  Water da Plants
//
//  Created by William Chen on 10/23/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @discardableResult convenience init(username: String, phoneNumber: Int64, password: String, id: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
       
        self.username = username
        self.phoneNumber = phoneNumber
        self.password = password
        self.id = id

    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let username = userRepresentation.username,
            let phoneNumber = userRepresentation.phoneNumber,
            let password = userRepresentation.password,
            let id = userRepresentation.id else { return nil }
        self.init(username: username, phoneNumber: phoneNumber, password: password, id: id, context: context)
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(username: username, phoneNumber: phoneNumber, password: password, id: id)
        
    }
}
