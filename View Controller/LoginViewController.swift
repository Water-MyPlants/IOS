//
//  LoginViewController.swift
//  Water da Plants
//
//  Created by William Chen on 10/19/19.
//  Copyright © 2019 Jonalynn Masters. All rights reserved.
//

import UIKit
import UserNotifications

class LoginViewController: UIViewController {
    
    let plantController = PlantController()
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationHelper.requestLocalNotificationPermissions()
    }
    
    
    
    
    private func login() {
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        
        plantController.login(username: username, password: password, completion: { (error) in
            if let error = error {
                NSLog("Error login: \(error)")
                DispatchQueue.main.async {
                    self.loginButton.isEnabled = true
                }
                return
            }
            
            self.plantController.fetchPlantsFromServer {
                print("Plants fetched")
            }
            
            DispatchQueue.main.async {
                if (self.plantController.bearer != nil) {
                    self.dismiss(animated: true, completion: nil)
                    print("Login successful")
                } else {
                    print("Can't login")
                    self.loginButton.isEnabled = true
                }
            }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func loginButtonTapped(_ sender: Any) {
        loginButton.isEnabled = false
        login()
    }
}


extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text,
            !text.isEmpty {
            switch textField {
            case usernameTextField:
                passwordTextField.becomeFirstResponder()
            default:
                textField.resignFirstResponder()
            }
        }
        return false
    }
}
