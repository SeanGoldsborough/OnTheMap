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
    
//    var client = APIClient.sharedInstance()
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButton(_ sender: Any) {
        
//        APIClient.sharedInstance().userNameVar = self.emailTextField.text!
//        APIClient.sharedInstance().userPasswordVar = self.passwordTextField.text!
//        print("user and password from textfield are...")
//        print(APIClient.sharedInstance().userNameVar)
//        print(APIClient.sharedInstance().userPasswordVar)

        let isEmailAddressValid = isValidEmailAddress(emailAddressString: self.emailTextField.text!)
        
        if isEmailAddressValid {
            //email: emailTextField.text!, password: passwordTextField.text!
//                var userNameVar: String = "smgoldsborough@gmail.com"
//                var userPasswordVar: String = "We051423!!!"
            let client = APIClient.sharedInstance()
            //APIClient.sharedInstance().authenticateUser() { (success, errorString) in
            
            client.authenticateUser(email: self.emailTextField.text!, password: self.passwordTextField.text!) { (success, errorString) in
                
                performUIUpdatesOnMain {
                    if success {
                        self.completeLogIn()
                        //self.students = StudentLocations.studentsFromResults(results)
                        print("will log in now...")
                        //self.completeLogIn()
                        
//                        let controller = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
//                        self.present(controller, animated: true, completion: nil)
                        
                        //                    self.movies = Movie.moviesFromResults(results)
                        //                    performUIUpdatesOnMain {
                        //                        self.tableView.reloadData()
                        //                    }
                        
                    } else {
                        //self.displayError(errorString)
                        print(errorString!)
                        AlertView.alertPopUp(view: self, alertMessage: "Log In Unsuccessful")
                    }
                }
            }
            
//            let post = UdacityClient()
//            post.simplePostSession(email: emailTextField.text!, password: passwordTextField.text!)
            print("OKAY")
            //if post.postSession.email
            //completeLogIn()
            //UdacityClient().postSession(email: !, password: passwordTextField.text!)
            //self.performSegue(withIdentifier: "MapVC", sender: self)
            print("Email address is valid")
            
        } else if !isEmailAddressValid {
            
            print("Email address is not valid")
            alertMessage(title: "ERROR", message: "Email address is not valid.", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
            
        } else if emailTextField.text == "" {
            alertMessage(title: "ERROR", message: "No User Name or Password.", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
        }
    }

//        let udacityMethods = UdacityClient()
//        udacityMethods.postSession(email: emailTextField.text!, password: passwordTextField.text!)
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = false
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count > 0
            {
                returnValue = true
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let url = URL(string:"https://www.udacity.com/account/auth#!/signup")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    var keyboardIsShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        var registeredInt: Int
        
//        emailTextField.delegate = self
//        passwordTextField.delegate = self
        
//        emailTextField.text = ""
//        passwordTextField.text = ""
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    func alertMessage(title: String, message: String, numberOfButtons: Int, leftButtonTitle: String, leftButtonStyle: Int, rightButtonTitle: String, rightButtonStyle: Int) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: leftButtonTitle, style: UIAlertActionStyle(rawValue: leftButtonStyle)!, handler: nil))
        if numberOfButtons < 1 {
        alertController.addAction(UIAlertAction(title: rightButtonTitle, style: UIAlertActionStyle(rawValue: rightButtonStyle)!, handler: nil))
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func completeLogIn() {
        let nextStoryboard = storyboard?.instantiateViewController(withIdentifier: "NavBarController")
        self.present(nextStoryboard!, animated: true, completion: nil)
        
    }

}
 // MARK: - LoginVC: UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }
    
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShown {
            view.frame.origin.y == keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShown {
            view.frame.origin.y == keyboardHeight(notification)
        }
    }
    
    @objc func keyboardDidShow(_ notification: Notification) {
        keyboardIsShown = true
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        keyboardIsShown = false
    }
    
    func keyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = (notification as NSNotification).userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
//    func resignIfFirstResponder(_ textField: UITextField) {
//        if textField.isFirstResponder {
//            textField.resignFirstResponder()
//        }
//    }
//
//    @IBAction func userDidTapView(_ sender: AnyObject) {
//        resignIfFirstResponder(self.emailTextField)
//        resignIfFirstResponder(self.passwordTextField)
//
//    }
}
    // MARK: - LoginVC (Notifications)
    
    private extension LoginVC {
        
        func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
            NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
        }
        
        func unsubscribeFromAllNotifications() {
            NotificationCenter.default.removeObserver(self)
        }
    }
