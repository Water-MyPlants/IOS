//
//  PlantController.swift
//  Water da Plants
//
//  Created by Andrew Ruiz on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String{
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case noToken
    case badRequest
    case noData
    case noDecode
    case noEncode
    case failure
    case otherError(Error)
}

class PlantController{
    
    
    let baseURL = URL(string: "https://my-json-server.typicode.com/")!

    
    func fetchPlantsFromServer(completion: @escaping () -> Void = {}) {
        let requestURL = baseURL.appendingPathComponent("lightdarkphoton/demo/db")
        var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
          
        URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching courses from server: \(error)")
                    return
                }
                guard let data = data else {
                    NSLog("No data returned from data task")
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let plantsRepresentations = try decoder.decode([PlantRepresentation].self, from: data)
                    print(plantsRepresentations)
//                    // loop through the course representations
                    let moc = CoreDataStack.shared.container.newBackgroundContext()
                    self.updatePlants(with: plantsRepresentations, context: moc)
                }catch {
                    NSLog("Error decoding: \(error)")
                }
                completion()
            }.resume()
        }
    //holy cow this is weird
//    $0= go through every element of the array and grab it
    func updateEntries(with representations: [PlantRepresentation]) {
       
       
    // Which representations do we already have in Core Data?
        let identifiersToFetch = representations.map({ $0.id })
    // [UUID: EntryRepresentation]
    let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
    // Make a mutable copy of the dictionary above
    var plantsToCreate = representationsByID
    do {
        let context = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        // Only fetch the tasks with the identifiers that are in this identifier
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        guard let existingPlants = try? context.fetch(fetchRequest) else {return}
        // Update the ones we do have
        for plant in existingPlants {
            // Grab the EntryRepresentation that corresponds to this Entry
                let identifier = plant.id,
                let representation = representationsByID[identifier] else { continue }
            plant.id = represention.id
            plant.bodyText = representation.bodyText
            plant.timestamp = representation.timestamp
            plant.mood = representation.mood
            // We just updated an entry, we don't need to create a new Entry for this identifier
            entriesToCreate.removeValue(forKey: identifier)
        }

    
//    private func updatePlants(with plantsRepresentations: [PlantRepresentation] , context: NSManagedObjectContext) {
//        context.performAndWait {
//            for plantRepresentation in plantsRepresentations {
//                //see if a task with the same identifier exist in core data
//                guard let id = plantRepresentation.id else { continue }
//                // update it if one does exist, or create a Task if it doesn't
//                if let plant = Plant {
//                    //task exist in core data, update it
//                    course.name = plantRepresentation.name
//                    course.location = courseRepresentation.location
//                    course.type = courseRepresentation.type
//                } else {
//                    //task not exist, make new one
//                    Course(courseRepresentation: courseRepresentation, context: context)
//                }
//            }
//            do {
//                try CoreDataStack.shared.save(context: context)
//            } catch {
//                NSLog("Error saving \(error)")
//                context.reset()
//            }
//        }
//    }
    
}
}
}
