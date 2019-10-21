//
//  PlantSearchTableViewCell.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class PlantSearchTableViewCell: UITableViewCell {
    
    var plantController : PlantController?
    var plantRepresentation: PlantRepresentation?
    @IBOutlet weak var plantName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func addPlantTapped(_ sender: UIButton) {
        
        guard let plantController = plantController,
            let plantRep = plantRepresentation else { return }
        plantController.addPlant(plantRepresentation: plantRep)
    }
    
    
    
}
