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
    
}
