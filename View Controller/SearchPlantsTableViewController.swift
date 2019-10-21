//
//  SearchPlantsTableViewController.swift
//  Water da Plants
//
//  Created by Andrew Ruiz on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class SearchPlantsTableViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
          guard let searchTerm = searchBar.text else { return }
        
          plantController.searchForPlants(with: searchTerm) { (error) in
              guard error == nil else { return }
              DispatchQueue.main.async {
                  self.tableView.reloadData()
              }
          }
          searchBar.endEditing(true)
      }
      override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantController.searchedPlants.count
      }
      override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlantCell", for: indexPath) as? PlantSearchTableViewCell else { return UITableViewCell() }
        let plantRepresentation = plantController.searchedPlants[indexPath.row]
        cell.plantName.text = plantRepresentation.nickName
        cell.plantController = plantController
        cell.plantRepresentation = plantRepresentation
    
        return cell
      }
    
    @IBOutlet weak var searchBar: UISearchBar!
    var plantController = PlantController()
}
