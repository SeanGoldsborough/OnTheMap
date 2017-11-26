//
//  TestVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class TestVC: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, MKMapViewDelegate {
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func submitLocation() {
        //overwriteLocation()
        locationUpdate()
        //AlertMessage(overwriteLocation())
        let firstPushVC = storyboard?.instantiateViewController(withIdentifier: "PushedVC") as! PushedVC
        self.navigationController?.pushViewController(firstPushVC, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields(textField: locationText, withText: "Enter Location", withTag: 0, withKeyboard: .done)
        
        var location = CLLocationCoordinate2DMake(40.722324, -73.988429)
        var lat = CLLocationDegrees(exactly: 40.722324)
        var long = CLLocationDegrees(exactly: -73.988429)
        
        let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        var span = MKCoordinateSpanMake(2, 2)
        var region = MKCoordinateRegionMake(center, span)
        mapView.setRegion(region, animated: true)
        
        var annotation = MKPointAnnotation()
        annotation.coordinate.latitude = lat!
        annotation.coordinate.longitude = long!
        annotation.title = "PIZZAAAAAA"
        annotation.subtitle = "yummy"
        
        mapView.addAnnotation(annotation)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
       // unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: - FUNCTION FOR CONFIGURING TEXT FIELD
    func configureTextFields(textField: UITextField, withText: String, withTag: Int, withKeyboard: UIReturnKeyType) {
        textField.delegate = TestTextDelegate()
        //textField.defaultTextAttributes = memeTextAttributes
        textField.attributedPlaceholder = NSAttributedString(string: withText)
        //textField.textColor = UIColor.white
        //textField.autocapitalizationType = .allCharacters
        //textField.textAlignment = .center
        textField.returnKeyType = withKeyboard
        textField.tag = withTag
        self.view.endEditing(true)
    }
    
    //FUNCTIONS FOR NOTIFICATION/OBSERVERS
    
//    @objc func keyboardWillShow(_ notification: NSNotification) {
//        if case locationText.isEditing = true {
//            view.frame.origin.y = 0//(notification as Notification)
//            //topTextField.frame.origin.y = 0 - getKeyboardHeight(notification as Notification)
//
//        } else {
//            view.frame.origin.y = 0
//        }
//    }
//
//    @objc func keyboardWillHide(_ notification:Notification) {
//
//        view.frame.origin.y += getKeyboardHeight(notification as Notification)
//    }
//
//    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
//        let userInfo = notification.userInfo
//        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
//        return keyboardSize.cgRectValue.height
//    }
//
//    func subscribeToKeyboardNotifications() {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
//
//
//    }
//
//    func unsubscribeFromKeyboardNotifications() {
//        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
//
//
//    }
    
    func overwriteLocation(){
        let pushedVC = self.storyboard!.instantiateViewController(withIdentifier: "PushedVC")

        let alertVC = UIAlertController(
            title: "You Have Already posted A Student Location. Would You Like To Overwrite Your Current Location?".capitalized,
            message: "",
            preferredStyle: .alert)
        let cancelAction = UIAlertAction(
            title: "Cancel",
            style:.default,
            handler: nil)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: {(action) -> Void in
                //The (withIdentifier: "VC2") is the Storyboard Segue identifier.
                //self.performSegue(withIdentifier: "VC2", sender: self)
                self.navigationController!.pushViewController(pushedVC, animated: true)
                 })


        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)


        self.present(alertVC, animated: true, completion: nil)
    }
    
    func locationUpdate() {
        
        
        guard let mapView = mapView,
            let searchText = locationText.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                print("There was an error searching for: error: ")
                return
            }
            
            for item in response.mapItems {
                print(searchText)
                print("\(item)")
//                mapView.setRegion(item.placemark, animated: true)
//                mapView.
//                let randomIndex = Int(arc4random_uniform(UInt32(response.mapItems.count)))
//                let mapItem = response.mapItems[randomIndex]
                
                //mapItem.openInMaps(launchOptions: nil)
                //self.locationText.text = "\(mapItem.placemark)"
                //self.location = CLLocationCoordinate2DMake(item.placemark.coordinate)
                
                self.matchingItems.append(item as MKMapItem)
                print("Matching items = \(self.matchingItems.count)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = item.name
                annotation.subtitle = "\(String(describing: item.url))"
                self.mapView.addAnnotation(annotation)
                //self.mapView.setRegion(annotation.coordinate, animated: true)
            }
        }
//        let search = MKLocalSearch(request: request)
//
//        search.start { response, _ in
//            guard let response = response else {
//                return
//            }
//            self.matchingItems = response.mapItems
//            //self.mapView.reloadData()
//        }
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//         self.locationText.resignFirstResponder()
//        return true
//    }
}

