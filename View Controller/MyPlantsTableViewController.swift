//
//  MyPlantsTableViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit
import CoreData

class MyPlantsTableViewController: UITableViewController {

    let plantController = PlantController()
    
    lazy var fetchedResultsController: NSFetchedResultsController<Plant> = {
        let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
        let plantDescriptor = NSSortDescriptor(key: "species", ascending: false)
        
        let moc = CoreDataStack.shared.mainContext
        fetchRequest.sortDescriptors = [plantDescriptor]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch {
            fatalError("Error performing fetch for frc: \(error)")
        }
        return frc
    }()

    
    @objc func beginRefresh() {
        plantController.fetchPlantsFromServer { 
            DispatchQueue.main.async {
                self.tableView.refreshControl?.endRefreshing()
            }
        }
    }
     override func viewDidLoad() {
           super.viewDidLoad()
           tableView.tableFooterView = UIView()
           tableView.refreshControl = UIRefreshControl()
           tableView.refreshControl?.addTarget(self, action: #selector(beginRefresh), for: .valueChanged)
    }
    
     override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            tableView.reloadData()
        }

        // MARK: - Table view data source

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return fetchedResultsController.sections?[section].numberOfObjects ?? 0
        }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPlantCell", for: indexPath) as? MyPlantTableViewCell else { return UITableViewCell() }

            let plant = fetchedResultsController.object(at: indexPath)
            cell.plant = plant
            cell.plantController = plantController

            return cell
        }

        // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                let plant = fetchedResultsController.object(at: indexPath)
                plantController.deletePlant(plant: plant)
            }
        }
    }

    // MARK: NSFetched Results Controller
    extension MyPlantsTableViewController: NSFetchedResultsControllerDelegate {
        func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.beginUpdates()
        }

        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            tableView.endUpdates()
        }

//        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
//            let sectionIndexSet = IndexSet(integer: sectionIndex)
//
//            switch type {
//            case .insert:
//                tableView.insertSections(sectionIndexSet, with: .fade)
//            case .delete:
//                tableView.deleteSections(sectionIndexSet, with: .fade)
//            default:
//                break
//            }
//        }

        func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .delete:
                guard let indexPath = indexPath else { return }
                tableView.deleteRows(at: [indexPath], with: .fade)
            case .insert:
                guard let newIndexPath = newIndexPath else { return }
                tableView.insertRows(at: [newIndexPath], with: .fade)
            case .move:
                guard let oldIndexPath = indexPath,
                    let newIndexPath = newIndexPath else { return }
                tableView.deleteRows(at: [oldIndexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)

            case .update:
                guard let indexPath = indexPath else { return }
                tableView.reloadRows(at: [indexPath], with: .fade)
            default:
                fatalError()
            }
        }
    }

