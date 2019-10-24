//
//  PlantController.swift
//  Water da Plants
//
//  Created by Andrew Ruiz on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import Foundation
import CoreData
import UIKit


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
    case noUser
    case noLogin
    case otherError(Error)
}

class PlantController{
    
    var currentUserRepresentation : UserRepresentation?
    var currentUser: User?
    var bearer: Bearer?

    
//    let baseURL = URL(string: "https://my-json-server.typicode.com/")!
    let baseURL = URL(string: "https://build-week-4.herokuapp.com/")!
    let firebaseURL = URL(string: "https://planttest-aca2a.firebaseio.com/")!
    var plants: [PlantRepresentation] = []

    init() {
        print("We're in the init")
    }
    // MARK: Fetch Plant from Server
    func fetchPlantsFromServer(completion: @escaping () -> Void = {}) {
        
        guard let bearer = bearer else {
            completion()
            return
        }
        let requestURL = baseURL.appendingPathComponent("api/plants/")
        var request = URLRequest(url: requestURL)
            request.httpMethod = HTTPMethod.get.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue(bearer.token, forHTTPHeaderField: "Authorization")
            
        
          
        URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let error = error {
                    NSLog("Error fetching courses from server: \(error)")
                    return
                }
                guard let data = data else {
                    
                    NSLog("No data returned from data task")
                    return
                }
            print(String(data: data, encoding: .utf8))
                do {
                    let decoder = JSONDecoder()
//                    let plantsRepresentations = Array(try decoder.decode([String: PlantRepresentation].self, from: data).values)
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
   
    // MARK: updatePlants
    func updatePlants(with representations: [PlantRepresentation], context: NSManagedObjectContext) {
    // Which representations do we already have in Core Data?
        let identifiersToFetch = representations.compactMap({ $0.id })
    // [UUID: EntryRepresentation]
    let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
    // Make a mutable copy of the dictionary above
    var plantsToCreate = representationsByID
    do {
        let context = CoreDataStack.shared.container.newBackgroundContext()
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        // Only fetch the tasks with the identifiers that are in this identifier
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        guard let existingPlants = try? context.fetch(fetchRequest) else {return}
        // Update the ones we do have
        for plant in existingPlants {
            // Grab the EntryRepresentation that corresponds to this Entry
                let identifier = plant.id ?? ""
            guard let representation = representationsByID[identifier],
                let ID = representation.id,
            let h2oFrequency = representation.h2oFrequency else { continue }
            plant.id = ID
            plant.nickName = representation.nickName
            plant.image = representation.image
            plant.species = representation.species
            plant.h2oFrequency = h2oFrequency

            // We just updated an entry, we don't need to create a new Entry for this identifier
            plantsToCreate.removeValue(forKey: identifier)
        }
                // Figure out which ones we don't have
                for representation in plantsToCreate.values {
                    Plant(plantRepresentation: representation, context: context)
                }
                // Persist all the changes (updating and creating of entries) to Core Data
                CoreDataStack.shared.saveToPersistentStore()
            } catch {
                NSLog("Error fetching entries from persistent store: \(error)")
            }
        }
    // MARK: delete Plant from Server
    func deletePlantFromServer(plant: Plant?, completion: @escaping(Error?) -> Void = { _ in }) {
        guard let identifier = plant?.id else {
               completion(nil)
               return
           }
           let requestURL = firebaseURL
            .appendingPathComponent("\(identifier)")
               .appendingPathExtension("json")
           var request = URLRequest(url: requestURL)
           request.httpMethod = HTTPMethod.delete.rawValue
           URLSession.shared.dataTask(with: request) { (_, _, error) in
               if let error = error {
                   NSLog("Error deleting movie: \(error)")
               }
               completion(nil)
               }.resume()
       }

    // MARK: Create Plant
    func createPlant(with species: String?, nickName: String?, h2oFrequency: Double?, image: String?, userID: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let species = species,
        let nickName = nickName,
        let h2oFrequency = h2oFrequency
            else { return }
        let moc = CoreDataStack.shared.container.newBackgroundContext()
           moc.performAndWait {
            let number = Int.random(in: 0...1_000_000).description
            let plant = Plant(id: number, nickName: nickName, species: species, image: nil, h2oFrequency: h2oFrequency, userID: nil)
            
            NotificationHelper.scheduleNotification(at: h2oFrequency, for: plant)
      
               do {
                   try CoreDataStack.shared.save(context: context)
               } catch {
                   NSLog("Error saving context when creating new plant: \(error)")
               }
            
            put(plant: plant)
        }
    }
    
    
// MARK: Delete Plant
    func deletePlant(plant: Plant, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
            deletePlantFromServer(plant: plant)
            context.performAndWait {
                let moc = CoreDataStack.shared.mainContext
                moc.delete(plant)

                do {
                    try CoreDataStack.shared.save(context: context)
                } catch {
                    NSLog("Error when saving context when deleting Plant: \(error)")
                }
            }
        }

    
    // MARK: Search for Plants
    func searchForPlants(with searchTerm: String, completion: @escaping (Error?) -> Void) {
        var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let queryParameters = ["query": searchTerm]
        components?.queryItems = queryParameters.map({URLQueryItem(name: $0.key, value: $0.value)})
        guard let requestURL = components?.url else {
            completion(NSError())
            return
        }
        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in
            if let error = error {
                NSLog("Error searching for movie with search term \(searchTerm): \(error)")
                completion(error)
                return
            }
            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }
            do {
                let plantRepresentations = try JSONDecoder().decode(PlantRepresentations.self, from: data).posts
                self.plants = plantRepresentations
                completion(nil)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    // MARK: fetch image
    func fetchImage(from imageURL: String, completion: @escaping(UIImage?) -> Void) {
        guard let imageURL = URL(string: imageURL) else {
            completion(nil)
            return }
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get.rawValue
        URLSession.shared.dataTask(with: request) { (imageData, _, error) in
            if let error = error {
                NSLog("Error fetching image: \(error)")
                return
            }
            guard let data = imageData else {
                NSLog("No data provided for image: \(imageURL)")
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
    
    // MARK: PUT func
    func put(plant: Plant, completion: @escaping(Error?) -> Void = { _ in }) {
        let number = Int.random(in: 0...1_000_000)
        let identifier = plant.id ?? "\(number)"
        let requestURL = firebaseURL
        .appendingPathComponent(identifier)
        .appendingPathExtension("json")
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        do {
            let plantData = try JSONEncoder().encode(plant.plantRepresentation)
            request.httpBody = plantData
        } catch {
            NSLog("Error encoding plant representation: \(error)")
            completion(error)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTing plant representation to server: \(error)")
            }
            completion(nil)
            }.resume()
    }

    // MARK: Update
    func update(plant: Plant, plantRepresentation: PlantRepresentation) {
        guard let id = plantRepresentation.id else { return }
        plant.id = id
    }
    
    // MARK: Update Persistent Store
    func updatePersistentStore(with plantRepresentations: [PlantRepresentation], context: NSManagedObjectContext) {
            context.performAndWait {
                for plantRepresentation in plantRepresentations {
                    guard let identifier = plantRepresentation.id else { continue }
                    let plant = self.fetchingSinglePlantFromPersistentStore(id: "\(identifier)", context: context)

                    if let plant = plant {
                        if plantRepresentation != plant {
                            self.update(plant: plant, plantRepresentation: plantRepresentation)
                        }
                    } else {
                        Plant(plantRepresentation: plantRepresentation, context: context)
                    }
                }
            }

            do {
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error saving context when updating Persistent Store: \(error)")
                context.reset()
            }
        }

        // MARK: Fetch from Persistent Store
        func fetchingSinglePlantFromPersistentStore(id: String, context: NSManagedObjectContext) -> Plant? {
            let predicate = NSPredicate(format: "identifier == %@", id as CVarArg)
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            fetchRequest.predicate = predicate

            var plant: Plant?

            context.performAndWait {
                do {
                    plant = try context.fetch(fetchRequest).first
                } catch {
                    NSLog("Error fetching plant")
                }
            }
            return plant
        }
}

// MARK: Signup
extension PlantController {
    func signUp(username: String, password: String, phoneNumber: Int64, id: String?, completion: @escaping (NetworkError?) -> Void) {
        let number = Int.random(in: 0...1_000_000).description
        let id = number
        let newUser = UserRepresentation(username: username, phoneNumber: phoneNumber, password: password, id: id)
        let signUpURL = baseURL.appendingPathComponent("api/user/register")
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            print(newUser)
            let userData = try JSONEncoder().encode(newUser)
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user when registering: \(error)")
            completion(.noEncode)
            return
        }
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error posting url request when register: \(error)")
                completion(.badRequest)
                return
            }
            if let response = response as? HTTPURLResponse,
            response.statusCode != 201 {
                NSLog("User wasn't completed: \(response.statusCode)")
                completion(.noUser)
            }
            self.createUserLocally(with: username, phoneNumber: phoneNumber, password: password)
            completion(nil)
            }.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (NetworkError?)-> Void) {
           //let loginInfo = ["username": username, "password": password]
           let loginInfo = UserLogin(username: username, password: password)
           let loginURL = baseURL.appendingPathComponent("api/user/login")
           var request = URLRequest(url: loginURL)
        
           request.httpMethod = HTTPMethod.post.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
           
           do {

               let loginData = try JSONEncoder().encode(loginInfo)
               request.httpBody = loginData
           } catch {
               NSLog("Error encoding user when login: \(error)")
               completion(.noEncode)
               return
           }
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   NSLog("Error posting url request when login: \(error)")
                   completion(.badRequest)
                   return
               }
               guard let data = data else {
                   NSLog("no data return on login")
                   completion(.noData)
                   return
               }
               do {
                   let bearer = try JSONDecoder().decode(Bearer.self, from: data)
                   print(bearer)
                   self.bearer = bearer
                   //self.saveLocalUser()
                   completion(nil)
               } catch {
                   NSLog("Error decoding when login: \(error)")
                   completion(.noDecode)
                   return
               }
            
            if let response = response as? HTTPURLResponse,
             response.statusCode != 201 {
                 NSLog("User wasn't completed: \(response.statusCode)")
                completion(.noLogin)
             }
            self.fetchCurrentUserLocally(username: username, password: password)
             completion(nil)
            print("Login successful")
             }.resume()
       }

// MARK: Create User Locally
    func createUserLocally(with username: String?, phoneNumber: Int64?, password: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let username = username,
        let phoneNumber = phoneNumber,
        let password = password
            else { return }
           context.performAndWait {
            let number = Int.random(in: 0...1_000_000).description
            let id = number.description
            let user = User(username: username, phoneNumber: phoneNumber, password: password, id: id)
      
               do {
                   try CoreDataStack.shared.save(context: context)
               } catch {
                   NSLog("Error saving context when creating new user: \(error)")
               }
        }
    }
    // MARK: Fetch Current User Locally
    
    func fetchCurrentUserLocally(username: String, password: String) {
        let predicate = NSPredicate(format: "username == %@ AND password == %@", username, password)
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            fetchRequest.predicate = predicate

        var user: User?

        CoreDataStack.shared.mainContext.performAndWait {
                do {
                    user = try CoreDataStack.shared.mainContext.fetch(fetchRequest).first
                } catch {
                    NSLog("Error fetching user")
                }
            }
        self.currentUser = user
        }
    
 // MARK: Update User Locally
    func updateUserLocally(with phoneNumber: Int64?, password: String?, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        guard let phoneNumber = phoneNumber,
        let password = password,
        let currentUser = currentUser
            else { return }
           context.performAndWait {
            currentUser.phoneNumber = phoneNumber
            currentUser.password = password
               do {
                   try CoreDataStack.shared.save(context: context)
               } catch {
                   NSLog("Error saving context when creating new user: \(error)")
               }
        }
    }
    // MARK: Update User
    func updateUser(password: String, phoneNumber: Int64, completion: @escaping (NetworkError?) -> Void) {
        guard let user = currentUser,
            let id = user.id,
            let bearer = bearer else {
                NSLog("Error getting ID/Bearer")
                return
        }
        
           var currentUserRepresentation = UserRepresentation(phoneNumber: phoneNumber, password: password, id: id)
           // local update
        currentUserRepresentation.id = id
        currentUserRepresentation.phoneNumber = phoneNumber
        currentUserRepresentation.password = password
        let updateJson = ["password": "\(password)", "phoneNumber": "\(phoneNumber)"]
        let updateURL = baseURL.appendingPathComponent("api/user/\(id)")
           var request = URLRequest(url: updateURL)
           request.httpMethod = HTTPMethod.put.rawValue
           request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(bearer.token, forHTTPHeaderField: "Authorization")
           do {
               print(currentUserRepresentation)
               let userData = try JSONEncoder().encode(updateJson)
               request.httpBody = userData
           } catch {
               NSLog("Error encoding user when updating: \(error)")
               completion(.noEncode)
               return
           }
           URLSession.shared.dataTask(with: request) { (data, response, error) in
               if let error = error {
                   NSLog("Error posting url request when update: \(error)")
                   completion(.badRequest)
                   return
               }
               completion(nil)
           }.resume()
       }
    }
