//
//  RegisterViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let plantController = PlantController()
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        phoneNumberTextField.delegate = self
        passwordTextField.delegate = self
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func createButtonTapped(_ sender: Any) {
       
        createButton.isEnabled = false
        createUser()

    }
func validatePassword() {
          // To Do: textField.isEmpty logic
        let errorMsg = "Passwords do not match "
        
        
        if passwordTextField.text == confirmPasswordTextField.text {
                self.createButton.isEnabled = true
        } else {
            
                   
                        let alertController = UIAlertController(title: "Password Error", message: errorMsg, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                 
            
        }
    }
    

    
    func createUser() {
        guard let userName = usernameTextField.text,
            let password = passwordTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            !phoneNumber.isEmpty,
            !userName.isEmpty,
            !password.isEmpty,
            !confirmPassword.isEmpty else {
                return
        }
        createButton.isEnabled = false
        if !confirmPassword.isEmpty {
            createButton.isEnabled = true
            validatePassword()
        
        }
        
        plantController.signUp(username: userName, password: password, phoneNumber: Int64(phoneNumber) ?? 0, id: nil) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Error signing up: \(error)")
                    self.createButton.isEnabled = false
                    return
                }
                print("sign up complete")
                self.navigationController?.popViewController(animated: true)
            }

        }
    }
}


