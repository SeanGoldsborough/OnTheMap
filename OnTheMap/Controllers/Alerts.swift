//
//  Alerts.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/4/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class AlertView {
    
    class func alertPopUp(view: UIViewController, alertMessage: String) {
        let alert = UIAlertController(title: "ERROR", message: alertMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func addLocationAlert(view: UIViewController, alertTitle: String, alertMessage: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        
        
        let addLocation = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            print("AKAJASDKJHFKAJSHDF;LKASJF;LKSAJHF;AJSFJ")
            
            let addLocationNavVC = view.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
            view.navigationController!.pushViewController(addLocationNavVC, animated: true)
   
        })
        alert.addAction(addLocation)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        performUIUpdatesOnMain {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    class func alertMessage(view: UIViewController, title: String, message: String, numberOfButtons: Int, leftButtonTitle: String, leftButtonStyle: Int, rightButtonTitle: String, rightButtonStyle: Int) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: leftButtonTitle, style: UIAlertActionStyle(rawValue: leftButtonStyle)!, handler: nil))
        if numberOfButtons < 1 {
            alertController.addAction(UIAlertAction(title: rightButtonTitle, style: UIAlertActionStyle(rawValue: rightButtonStyle)!, handler: nil))
        }
        
        view.present(alertController, animated: true, completion: nil)
    }
    
}
