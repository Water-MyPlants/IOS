//
//  UserSettingsViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit
import CoreData

class UserSettingsViewController: UIViewController {
    
    var plantController: PlantController?
    
    @IBOutlet weak var updatePhoneNumberTextField: UITextField!
    @IBOutlet weak var updatePasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func updateButtonTapped(_ sender: Any) {
        
}
       func updateUser() {
            guard let phoneNumber = updatePhoneNumberTextField.text,
                let password = updatePasswordTextField.text,
                let confirmPassword = confirmPasswordTextField.text,
                !phoneNumber.isEmpty,
                !password.isEmpty,
                !confirmPassword.isEmpty else {
                    updateButton.isEnabled = true
                    return
            }
            
            plantController?.updateUser(password: password, phoneNumber: Int(phoneNumber) ?? 0, id: nil) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        NSLog("Error signing up: \(error)")
                        self.updateButton.isEnabled = false
                        return
                    }
                    print("sign up complete")
                    self.dismiss(animated: true, completion: nil)
                }

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



