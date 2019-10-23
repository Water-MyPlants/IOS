//
//  RegisterViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    let plantController = PlantController()
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
                    
        var errorMsg = "Passwords do not match "
        var password = passwordTextField.text
        var confirmPassword = confirmPasswordTextField.text
        
        if passwordTextField.text == confirmPasswordTextField.text {
                self.createButton.isEnabled = true
        } else {
            var isPasswordValid: Bool {
                    if password != confirmPassword {
                        let alertController = UIAlertController(title: "Password Error", message: errorMsg, preferredStyle: .alert)
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    } else {
                }
                    return true
            }
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
        
        plantController.signUp(username: userName, password: password, phoneNumber: Int(phoneNumber) ?? 0, id: nil) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Error signing up: \(error)")
                    self.createButton.isEnabled = false
                    return
                }
                print("sign up complete")
                self.dismiss(animated: true, completion: nil)
            }

        }
    }
}


