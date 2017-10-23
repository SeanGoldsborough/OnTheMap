//
//  AddLocationVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/23/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//
import Foundation
import UIKit

class AddLocationVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var newLocationTF: UITextField!
    @IBOutlet weak var websiteTF: UITextField!
    @IBAction func cancelAddLoca(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController!.popViewController
        
    }
    @IBAction func findLocation(_ sender: Any) {
        if newLocationTF.text == "" && websiteTF.text == "" {
            alertMessage()
        } else {
            print("OKAY")
            //self.performSegue(withIdentifier: "MapVC", sender: self)
        }
//        let udacityMethods = UdacityMethods()
//        udacityMethods.postSession(email: emailTextField.text!, password: passwordTextField.text!)
        //TODO: DATA RETURNED IS: {"account": {"registered": true, "key": "8266875466"}, "session": {"id": "1540066524S789e7cbc844b82f38fea1ad0a2edc503", "expiration": "2017-12-19T20:15:24.707830Z"}}
        //TODO: NEED TO PARSE THIS DATA TO ALLOW ACCESS TO NEXT PAGE IN APP BASED ON 'account': "regisered": true
        //if someAspectOfJSON.JSONData = true { performSegue(withIdentifier: "MapVC", sender: self) } else { alert access denied }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        let url = URL(string:"https://www.udacity.com/account/auth#!/signup")
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
    var keyboardIsShown = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newLocationTF.delegate = self
        websiteTF.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    func alertMessage() {
        let alertController = UIAlertController(title: "ERROR", message: "No User Name or Password.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    // MARK: - LoginVC: UITextFieldDelegate
    
    //extension LoginVC: UITextFieldDelegate {
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: Show/Hide Keyboard
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !keyboardIsShown {
            view.frame.origin.y -= keyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if keyboardIsShown {
            view.frame.origin.y += keyboardHeight(notification)
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
    
    func resignIfFirstResponder(_ textField: UITextField) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        }
    }
    
    @IBAction func userDidTapView(_ sender: AnyObject) {
        resignIfFirstResponder(newLocationTF)
        resignIfFirstResponder(websiteTF)
        
    }
}

// MARK: - LoginVC (Notifications)

private extension AddLocationVC {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}
