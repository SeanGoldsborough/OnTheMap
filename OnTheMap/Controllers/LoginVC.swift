//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBAction func loginButton(_ sender: Any) {
        if emailTextField.text == "" && passwordTextField.text == "" {
            alertMessage()
        } else {
            print("OKAY")
            self.performSegue(withIdentifier: "MapVC", sender: self)
        }
        let udacityMethods = UdacityMethods()
        udacityMethods.postSession(email: emailTextField.text!, password: passwordTextField.text!)
        //TODO: DATA RETURNED IS: {"account": {"registered": true, "key": "8266875466"}, "session": {"id": "1540066524S789e7cbc844b82f38fea1ad0a2edc503", "expiration": "2017-12-19T20:15:24.707830Z"}}
        //TODO: NEED TO PARSE THIS DATA TO ALLOW ACCESS TO NEXT PAGE IN APP BASED ON 'account': "regisered": true
        //if someAspectOfJSON.JSONData = true { performSegue(withIdentifier: "MapVC", sender: self) } else { alert access denied }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let url = URL(string:"https://www.udacity.com/account/auth#!/signup")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func alertMessage() {
        let alertController = UIAlertController(title: "ERROR", message: "No User Name or Password.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
}
