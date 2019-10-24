//
//  HomeScreenTabBarController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class HomeScreenTabBarController: UITabBarController {
    
    var plantController: PlantController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
passPlantControllerToChildren()
        // Do any additional setup after loading the view.
    }
    
    func passPlantControllerToChildren() {
        for childVC in children {
            if let childVC = childVC as? PlantControllerPresenting {
                childVC.plantController = plantController
            } else if let navController = childVC as? UINavigationController {
                guard let grandChildVC = navController.children.first as? PlantControllerPresenting else { continue }
                grandChildVC.plantController = plantController
                
            }
        }
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
