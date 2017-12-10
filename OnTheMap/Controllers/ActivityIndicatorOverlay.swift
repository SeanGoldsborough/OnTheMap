//
//  ActivityIndicatorOverlay.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/6/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ActivityIndicatorOverlay {
    
    static var currentOverlay : UIView?
    static var currentOverlayTarget : UIView?
    static var currentLoadingText: String?
    
    static func show() {
        guard let currentMainWindow = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
            
        }
        show(currentMainWindow)
    }
    
    static func show(_ currentMainWindow: UIView, _ loadingText: String) {
//        guard let currentMainWindow = UIApplication.shared.keyWindow else {
//            print("No main window.")
//            return
//        }
       // let currentMainWindow = UIView
        
        show(currentMainWindow, loadingText: loadingText)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?) {
        // Clear it first in case it was already shown
        hide()
        
        // register device orientation notification
        NotificationCenter.default.addObserver(
            self, selector:
            #selector(ActivityIndicatorOverlay.rotated),
            name: NSNotification.Name.UIDeviceOrientationDidChange,
            object: nil)
        
        // Create the overlay
        
        let overlay = UIView(frame: overlayTarget.frame)
        overlay.center = overlayTarget.center
        print("overlay center is: \(overlay.center)")
        overlay.alpha = 0
        overlay.backgroundColor = UIColor.black
        overlayTarget.addSubview(overlay)
        //overlayTarget.bringSubview(toFront: overlay)
        
        // Create and animate the activity indicator
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        indicator.center = overlay.center
        indicator.startAnimating()
        overlay.addSubview(indicator)
        
        // Create label
        if let textString = loadingText {
            let label = UILabel()
            label.text = textString
            label.textColor = UIColor.white
            label.sizeToFit()
            label.center = CGPoint(x: indicator.center.x, y: indicator.center.y + 30)
            overlay.addSubview(label)
        }
        
        // Animate the overlay to show
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.5)
        overlay.alpha = overlay.alpha > 0 ? 0 : 0.5
        UIView.commitAnimations()
        
        currentOverlay = overlay
        currentOverlayTarget = overlayTarget
        currentLoadingText = loadingText
    }
    
    static func hide() {
        if currentOverlay != nil {
            
            // unregister device orientation notification
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange,                                                      object: nil)
            
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
            currentLoadingText = nil
            currentOverlayTarget = nil
        }
    }
    
    @objc private static func rotated() {
        // handle device orientation change by reactivating the loading indicator
        if currentOverlay != nil {
            show(currentOverlayTarget!, loadingText: currentLoadingText)
        }
    }
}
