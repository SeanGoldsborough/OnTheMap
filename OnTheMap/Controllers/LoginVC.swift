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
    
    @IBOutlet weak var emailTextField: UITextField?
    @IBOutlet weak var passwordTextField: UITextField?
    
    @IBOutlet weak var activityOverlay: UIView?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    @IBAction func loginButton(_ sender: Any) {
        
        performUIUpdatesOnMain {
            self.activityOverlay?.isHidden = false
            self.activityIndicator?.startAnimating()
        }

        let isEmailAddressValid = isValidEmailAddress(emailAddressString: (self.emailTextField?.text!)!)
        
        if isEmailAddressValid == true {
            
            let client = APIClient.sharedInstance()
       
            client.authenticateUser(email: (self.emailTextField?.text!)!, password: (self.passwordTextField?.text!)!) { (success, errorString) in

                if success {
                    performUIUpdatesOnMain {
                        self.completeLogIn()
                        self.activityOverlay?.isHidden = true
                        self.activityIndicator?.stopAnimating()
                    }
                    
                } else {
                    performUIUpdatesOnMain {
                    self.activityOverlay?.isHidden = true
                    self.activityIndicator?.stopAnimating()
                    AlertView.alertPopUp(view: self, alertMessage: (errorString?.localizedDescription)!)//"Log In Unsuccessful")
                    }
                }
            }
            
        } else if emailTextField?.text == "" || passwordTextField?.text == "" {
            AlertView.alertMessage(view: self, title: "No Username or Password", message: "Please try again.", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
            performUIUpdatesOnMain {
                self.activityOverlay?.isHidden = true
                self.activityIndicator?.stopAnimating()
            }
            
        } else if isEmailAddressValid == false {
            
            AlertView.alertMessage(view: self, title: "Email/Password Not Valid", message: "Please try again.", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
            performUIUpdatesOnMain {
                self.activityOverlay?.isHidden = true
                self.activityIndicator?.stopAnimating()
            }
        }
    }
    
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
        
        performUIUpdatesOnMain {
            
            self.activityOverlay?.isHidden = true
            self.activityIndicator?.stopAnimating()
            
        }
        
        var registeredInt: Int
        
        emailTextField?.delegate = self
        passwordTextField?.delegate = self
        
        emailTextField?.text = ""
        passwordTextField?.text = ""
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("loginVC did disappear")
    }
    
    func completeLogIn() {
        let nextStoryboard = storyboard?.instantiateViewController(withIdentifier: "TabBarController")
        self.present(nextStoryboard!, animated: true, completion: nil)
        
    }

}
 // MARK: - LoginVC: UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {

    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.emailTextField?.resignFirstResponder()
        self.passwordTextField?.resignFirstResponder()
        return true
    }
    
    
//    // MARK: Show/Hide Keyboard
//
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShown {
            view.frame.origin.y = -keyboardHeight(notification) / 2.6
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShown {
            view.frame.origin.y = 0
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
