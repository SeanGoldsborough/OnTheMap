//
//  TestTextDelegate.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class TestTextDelegate: NSObject, UITextFieldDelegate {
    
    //Limit Number of Characters In Each Text Field to 25
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        
//        let text = textField.text
//        var memeTextLength = text?.characters.count
//        
//        return memeTextLength! <= 140
//    }  
    
    //Jump To Bottom TextField After Pressing Next. Dismiss Keyboard When Pressing Go
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
//        // Try to find next responder
//        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
//            nextField.becomeFirstResponder()
//        } else {
//            // Not found, so remove keyboard.
            textField.resignFirstResponder()
         //self.view.endEditing(true)
        
            
      //  }
        // Do not add a line break
        return false
    }
    
    //Clear Placeholder Text When Tapping In TextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
}
