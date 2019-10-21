//
//  MyPlantTableViewCell.swift
//  Water da Plants
//
//  Created by Jonalynn Masters on 10/21/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class MyPlantTableViewCell: UITableViewCell {

    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    
    var plantController: PlantController?
    var plant: Plant? {
        didSet {
            updateViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateViews() {
        guard let plant = plant else { return }
        guard let nickname = plant.nickname else { return }
        nickNameLabel.text = plant.nickname 
    }

}
