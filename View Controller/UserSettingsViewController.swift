//
//  UserSettingsViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit
import CoreData

class UserSettingsViewController: UIViewController, UITextFieldDelegate {
    
    var plantController: PlantController?
    
    @IBOutlet weak var updatePhoneNumberTextField: UITextField!
    @IBOutlet weak var updatePasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        updatePhoneNumberTextField.delegate = self
        updatePasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == confirmPasswordTextField {
            validatePassword()
        }
    }
    @IBAction func updateButtonTapped(_ sender: Any) {
       print("update button tapped")
        updateButton.isEnabled = true
        updateUser()
        
}
       func validatePassword() {
             // To Do: textField.isEmpty logic
           let errorMsg = "Passwords do not match "
           
           
           if updatePasswordTextField.text == confirmPasswordTextField.text {
                   self.updateButton.isEnabled = true
           } else {
               
                      
                           let alertController = UIAlertController(title: "Password Error", message: errorMsg, preferredStyle: .alert)
                           let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                           alertController.addAction(defaultAction)
                           self.present(alertController, animated: true, completion: nil)
                    
               
           }
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
            updateButton.isEnabled = false
            if !confirmPassword.isEmpty {
                updateButton.isEnabled = true
                validatePassword()
            
            }
            plantController?.updateUser(password: password, phoneNumber: Int(phoneNumber) ?? 0, id: nil) { (error) in
                DispatchQueue.main.async {
                    if let error = error {
                        NSLog("Error signing up: \(error)")
                        self.updateButton.isEnabled = false
                        return
                    }
                    print("Update Complete")
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



