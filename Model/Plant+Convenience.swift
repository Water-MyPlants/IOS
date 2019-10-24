//
//  Plant+Convenience.swift
//  Water da Plants
//
//  Created by Jonalynn Masters on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

extension Plant {
    @discardableResult convenience init(id: String?,
                                        nickName: String,
                                        species: String,
                                        image: String? = nil,
                                        h2oFrequency: Double,
                                        userID: String?,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = id
        self.nickName = nickName
        self.species = species
        self.image = image
        self.h2oFrequency = h2oFrequency
        self.userID = userID
    }
    
    @discardableResult convenience init?(plantRepresentation: PlantRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let id = plantRepresentation.id,
        let nickName = plantRepresentation.nickName,
        let species = plantRepresentation.species,
        let h2oFrequency = plantRepresentation.h2oFrequency,
        let userID = plantRepresentation.userID else { return nil }
        self.init(id: id, nickName: nickName, species: species, h2oFrequency: h2oFrequency, userID: userID, context: context)
    }
    
    var plantRepresentation: PlantRepresentation {
        return PlantRepresentation(id: id, nickName: nickName, species: species, h2oFrequency: h2oFrequency, userID: userID, image: image)
    }
}

