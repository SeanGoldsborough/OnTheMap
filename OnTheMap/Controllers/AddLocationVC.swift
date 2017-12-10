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
        ActivityIndicatorOverlay.show(self.view, "")
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(AddLocationVC.hideIndicator), userInfo: nil, repeats: false)
        self.navigationController!.popViewController(animated: true)
        
    }
    
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    @IBAction func findLocation(_ sender: Any) {
        if newLocationTF.text == "" && websiteTF.text == "" {
            alertMessage(title: "ERROR", message: "Invalid Location or Website", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
        } else {
            
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
            myVC.locationPassed = newLocationTF.text!
            myVC.websitePassed = websiteTF.text!
            navigationController?.pushViewController(myVC, animated: true)
            
//            func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//                if (segue.identifier == "confirmVC") {
//                    let destination = segue.destination as? ConfirmVC
//                    destination?.updateTheLabel = newLocationTF.text!
//
//                    destination?.cityLabel.text = newLocationTF.text
//                    print(newLocationTF.text)
//                }
//            }
            
            print("Valid Location and/or Website Entered")
            //let confirmVC = self.storyboard!.instantiateViewController(withIdentifier: "ConfirmVC")
            //navigationController!.pushViewController(confirmVC, animated: true)
            
            //performSegue(withIdentifier: "confirmVC", sender: self)
            
        }
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if (segue.identifier == "confirmVC") {
//            let destination = segue.destination as? ConfirmVC
//            destination!.cityLabel.text = newLocationTF.text
//        }
//    }
    
    
//        let udacityMethods = UdacityMethods()
//        udacityMethods.postSession(email: emailTextField.text!, password: passwordTextField.text!)
        //TODO: DATA RETURNED IS: {"account": {"registered": true, "key": "8266875466"}, "session": {"id": "1540066524S789e7cbc844b82f38fea1ad0a2edc503", "expiration": "2017-12-19T20:15:24.707830Z"}}
        //TODO: NEED TO PARSE THIS DATA TO ALLOW ACCESS TO NEXT PAGE IN APP BASED ON 'account': "regisered": true
        //if someAspectOfJSON.JSONData = true { performSegue(withIdentifier: "MapVC", sender: self) } else { alert access denied }
    
    
//    @IBAction func signUpButton(_ sender: Any) {
//        let url = URL(string:"https://www.udacity.com/account/auth#!/signup")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//    }
    
    var keyboardIsShown = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(APIClient.sharedInstance().uniqueID!)
        
    
        newLocationTF.delegate = self
        websiteTF.delegate = self
        
        subscribeToNotification(.UIKeyboardWillShow, selector: #selector(keyboardWillShow))
        subscribeToNotification(.UIKeyboardWillHide, selector: #selector(keyboardWillHide))
        subscribeToNotification(.UIKeyboardDidShow, selector: #selector(keyboardDidShow))
        subscribeToNotification(.UIKeyboardDidHide, selector: #selector(keyboardDidHide))
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Cancel"
        //navigationController?.navigationBar.t
        
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
