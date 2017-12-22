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
    
    @IBOutlet weak var findLocationButton: UIButton!
    
    @IBAction func cancelAddLoca(_ sender: Any) {
        ActivityIndicatorOverlay.show(self.view, "")
        let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
            tabVC.modalTransitionStyle = .crossDissolve
            self.present(tabVC, animated: true, completion: nil)
        
    }
    
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    @IBAction func findLocation(_ sender: Any) {
        if newLocationTF.text == "" && websiteTF.text == "" {
            AlertView.alertMessage(view: self, title: "ERROR", message: "Invalid Location or Website", numberOfButtons: 1, leftButtonTitle: "OK", leftButtonStyle: 1, rightButtonTitle: "Cancel", rightButtonStyle: 0)
        } else {
            let myVC = storyboard?.instantiateViewController(withIdentifier: "ConfirmVC") as! ConfirmVC
            myVC.locationPassed = newLocationTF.text!
            myVC.websitePassed = websiteTF.text!
            navigationController?.pushViewController(myVC, animated: true)
        }
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

        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.backItem?.backBarButtonItem?.title = "Cancel"
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }
    
    
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
