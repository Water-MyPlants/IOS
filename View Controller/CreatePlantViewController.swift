//
//  MyPlantsWaterScheduleViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class CreatePlantViewController: UIViewController {

    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantNickNameTextField: UITextField!
    @IBOutlet weak var plantPicImageView: UIImageView!
    @IBOutlet weak var waterIntervalDatePicker: UIDatePicker!
    @IBOutlet weak var savePlantButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var plantController: PlantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        
        
    }
    
    func createPlant() {
        guard let species = plantSpeciesTextField.text,
            let nickname = plantNickNameTextField.text
//            let image = plantPicImageView.image
            else { return
            
        
        
         
        DispatchQueue.main.async {
            self.savePlantButton.isEnabled = true
        }
        return
    }
        plantController?.addPlant(species: species, nickName: nickname)
}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
