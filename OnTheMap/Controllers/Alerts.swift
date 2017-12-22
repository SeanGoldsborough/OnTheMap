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
    
    class func popToAddLocationVC(view: UIViewController){

        let alertVC = UIAlertController(title: "Could not load location".capitalized, message: "Please try again.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style:.default, handler: {(action) -> Void in
            let viewControllers: [UIViewController] = view.navigationController!.viewControllers as [UIViewController];
            view.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: true);
        })
        
        alertVC.addAction(okAction)

        view.present(alertVC, animated: true, completion: nil)
    }
    
    
    class func overwriteLocation(view: UIViewController, tabBarView: UITabBarController){
       
        let tabVC = view.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
        
        let alertVC = UIAlertController(title: "Confirm Overwrite Your Current Location?".capitalized, message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style:.default, handler: nil)
        let okAction = UIAlertAction(title: "OK", style:.default, handler: {(action) -> Void in
//            let viewControllers: [UIViewController] = view.navigationController!.viewControllers as [UIViewController];
//            print("vc count is:\(viewControllers.count)");
//            view.navigationController!.popToViewController(viewControllers[viewControllers.count - 1], animated: true);
            tabVC.modalTransitionStyle = .crossDissolve
            view.present(tabVC, animated: true, completion: nil)
        })
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        view.present(alertVC, animated: true, completion: nil)
    }
}
