//
//  MyPlantsWaterScheduleViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class CreatePlantViewController: UIViewController {
    
    var plantController: PlantController?
    var plants: [PlantRepresentation] = []
    var plant : Plant? {
        didSet {
            // updateViews()
        }
    }
    @IBOutlet weak var plantSpeciesTextField: UITextField!
    @IBOutlet weak var plantNickNameTextField: UITextField!
    @IBOutlet weak var plantPicImageView: UIImageView!
    @IBOutlet weak var waterIntervalDatePicker: UIDatePicker!
    @IBOutlet weak var savePlantButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    var countDownDuration: TimeInterval {
        let h2oFrequency = waterIntervalDatePicker.countDownDuration
        return h2oFrequency
    }
    let startDate = Date()
    let endDate = Date(timeInterval: h2oFrequency, since: startDate)
    let outputString = formatter.string(from: startDate, to: endDate)


    
//    let formatterStyle = DateIntervalFormatter() {
//        .dateStyle = .short
//        formatterStyle.timeStyle = .none
//let startDate = Date()
//        let endDate = Date(timeInterval: 86400, since: startDate)
//
//
/
//
//        // Use the configured formatter to generate the string.

//        }
        
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        let h2oFrequency = waterIntervalDatePicker.countDownDuration
        
        if let plantSpecies = plantSpeciesTextField.text,
            let plantNickname = plantNickNameTextField.text
            //let plantImage = plantPicImageView.image
        {
            
            if let plant = plant {
                // update plant here
            
            } else {
                plantController?.createPlant(with: nil, species: plantSpecies, nickName: plantNickname, h2oFrequency: h2oFrequency, image: nil, userID: nil, context: CoreDataStack.shared.mainContext)
            }
            
        }
        
        //navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        print("Hey we're in here")
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
        
    }
    
    func createPlant() {
        guard let species = plantSpeciesTextField.text,
            let nickName = plantNickNameTextField.text,
           
            let h2oFrequency = waterIntervalDatePicker?.countDownDuration
            else { return
        DispatchQueue.main.async {
            self.savePlantButton.isEnabled = true
        }
        return
    }

        plantController?.createPlant(with: nil, species: species, nickName: nickName, h2oFrequency: h2oFrequency, image: nil, userID: nil)
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
