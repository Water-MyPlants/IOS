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
    
    
    func createUser() {
        guard let userName = usernameTextField.text,
            let password = passwordTextField.text,
            let phoneNumber = phoneNumberTextField.text,
            !phoneNumber.isEmpty,
            !userName.isEmpty,
            !password.isEmpty  else {
                createButton.isEnabled = true
                return
        }
        plantController.signUp(username: userName, password: password, phoneNumber: Int(phoneNumber) ?? 0, id: nil) { (error) in
            DispatchQueue.main.async {
                if let error = error {
                    NSLog("Error signing up: \(error)")
                    self.createButton.isEnabled = true
                    return
                }
                print("sign up complete")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}


