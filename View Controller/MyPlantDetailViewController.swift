//
//  MyPlantDetailViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class MyPlantDetailViewController: UIViewController {
    @IBOutlet weak var speciesTitle: UINavigationItem!
    
    @IBOutlet weak var nickName: UILabel!
    var plant: Plant? {
        didSet {
           
        }
    }
    

    
    @IBOutlet weak var plantPictureImageView: UIImageView!
    
    @IBOutlet weak var timeUntilNextWateringLabel: UILabel!
    
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var plantNickNameLabelTest: UILabel!
    
    var countdown = Countdown()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
//        countdown.timeRemaining = plant.
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    //MARK: Update Views
    
    func updateViews() {
        guard let plant = self.plant else { return }
        speciesLabel.text
            = plant.species
        nickName.text = plant.nickName
        NotificationHelper.getTimeRemainingForPlant(for: plant) { (timeRemaining) in
            guard let timeRemaining = timeRemaining else { return }
            self.countdown.delegate = self
            self.countdown.duration = timeRemaining
            self.countdown.start()
        }
    }
     
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }

    private var dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "HH:mm:ss"
         formatter.timeZone = TimeZone(secondsFromGMT: 0)
         return formatter
     }()

}

extension MyPlantDetailViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        timeUntilNextWateringLabel.text = string(from: timeRemaining)
    }
    
    func countdownDidFinish() {
        updateViews()
    }
    
    private func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
}
