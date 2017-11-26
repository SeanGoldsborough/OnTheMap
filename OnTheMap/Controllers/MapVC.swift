//
//  MapVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapVC: UIViewController {
    
    var students: [StudentLocations] = [StudentLocations]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
   
    @IBAction func logOut(_ sender: Any) {
        let logOut = UdacityClient()
        logOut.deleteSession()
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        self.present(loginVC, animated: true, completion: nil)
    }
    @IBAction func reloadMapView(_ sender: Any) {
        mapView.reloadInputViews()
        getStudents()
       ActivityIndicatorOverlay.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MapVC.hideIndicator), userInfo: nil, repeats: false)
    }
    
//    @objc func hideIndicator() {
//        ActivityIndicatorOverlay.hide()
//    }
    
    func printPoop() {
        print("pooooooooop!MAPVIEWUPDATED!!!")
    }
    
    
    @IBAction func addLocation(_ sender: Any) {
        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        self.navigationController!.pushViewController(addLocationNavVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ActivityIndicatorOverlay.show("Loading...")
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MapVC.hideIndicator), userInfo: nil, repeats: false)
        
        self.navigationController?.navigationBar.isHidden = false
        getStudents()
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped(sender: )))
//        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), landscapeImagePhone: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshData(sender: )))
//        let addPinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_addpin"), landscapeImagePhone: #imageLiteral(resourceName: "icon_addpin"), style: .plain, target: self, action: #selector(addPin(sender: )))
//        navigationItem.rightBarButtonItems = [addPinButton, refreshButton]
        
//        APIClient.sharedInstance().getStudentLocationsParse { (students, error) in
//
//
//
//            if let studentsResults = students {
//                //                let studentsFiltered = students.filter { $0 != nil }
//                self.students = studentsResults //as in the constant from if/let statement which = movies returned by comp hand
//                //self.students = studentsFiltered //as in the constant from if/let statement which = movies returned by comp hand
//
//                performUIUpdatesOnMain {
//                    //self.mapView.reloadData()
//                    print("printing students resultsMAP:\(self.students)")
//                }
//
//
//
//
//                // The "locations" array is an array of dictionary objects that are similar to the JSON
//                // data that you can download from parse.
//                let studentsArray = students
//                print("printing students array MAP:\(studentsArray)")
//                // We will create an MKPointAnnotation for each dictionary in "locations". The
//                // point annotations will be stored in this array, and then provided to the map view.
//                var annotations = [MKPointAnnotation]()
//
//                // The "locations" array is loaded with the sample data below. We are using the dictionaries
//                // to create map annotations. This would be more stylish if the dictionaries were being
//                // used to create custom structs. Perhaps StudentLocation structs.
//
//                for dictionary in studentsArray! {
//
//                    let studentFirstName = dictionary
//                    //let studentFirstName = student.createdAt!
//
//                    print("printing studentFirstName:\(studentFirstName)")
//
//
//
//                    //cell.textLabel!.text = studentFirstName.firstName
//                    //cell.detailTextLabel!.text = studentFirstName.mediaURL
//
//                    // Notice that the float values are being used to create CLLocationDegree values.
//                    // This is a version of the Double type.
//                    let lat = CLLocationDegrees(dictionary.latitude as! Double)
//                    let long = CLLocationDegrees(dictionary.longitude as! Double)
//                    print("printing lat:\(lat)")
//                    print("printing long:\(long)")
//                    //            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
//                    //            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
//
//                    // The lat and long are used to create a CLLocationCoordinates2D instance.
//                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//
//                    //            let first = dictionary["firstName"] as! String
//                    //            let last = dictionary["lastName"] as! String
//                    //            let mediaURL = dictionary["mediaURL"] as! String
//
//                    let firstName = studentFirstName.firstName!
//                    let lastName = studentFirstName.lastName!
//                    let fullName = firstName + " " + lastName as! String
//                    let mediaURL = studentFirstName.mediaURL as! String
//
//                    // Here we create the annotation and set its coordiate, title, and subtitle properties
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = coordinate
//                    annotation.title = "\(firstName) \(lastName)"
//                    annotation.subtitle = mediaURL
//
//                    // Finally we place the annotation in an array of annotations.
//                    annotations.append(annotation)
//
//                    print("Annotations array = \(annotations)")
//                }
//
//                // When the array is complete, we add the annotations to the map.
//                self.mapView.addAnnotations(annotations)
//            }
            //            } else {
            //                print(error ?? "empty error")
            //            }
        }
    
    func getStudents() {
        APIClient.sharedInstance().getStudentLocationsParse { (students, error) in
            
            
            
            if let studentsResults = students {
                //                let studentsFiltered = students.filter { $0 != nil }
                self.students = studentsResults //as in the constant from if/let statement which = movies returned by comp hand
                //self.students = studentsFiltered //as in the constant from if/let statement which = movies returned by comp hand
                
                performUIUpdatesOnMain {
                    //self.mapView.reloadData()
                    print("printing students resultsMAP:\(self.students)")
                }
                
                
                
                
                // The "locations" array is an array of dictionary objects that are similar to the JSON
                // data that you can download from parse.
                let studentsArray = students
                print("printing students array MAP:\(studentsArray)")
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                // The "locations" array is loaded with the sample data below. We are using the dictionaries
                // to create map annotations. This would be more stylish if the dictionaries were being
                // used to create custom structs. Perhaps StudentLocation structs.
                
                for dictionary in studentsArray! {
                    
                    let studentFirstName = dictionary
                    //let studentFirstName = student.createdAt!
                    
                    print("printing studentFirstName:\(studentFirstName)")
                    
                    
                    
                    //cell.textLabel!.text = studentFirstName.firstName
                    //cell.detailTextLabel!.text = studentFirstName.mediaURL
                    
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(dictionary.latitude as! Double)
                    let long = CLLocationDegrees(dictionary.longitude as! Double)
                    print("printing lat:\(lat)")
                    print("printing long:\(long)")
                    //            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
                    //            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    //            let first = dictionary["firstName"] as! String
                    //            let last = dictionary["lastName"] as! String
                    //            let mediaURL = dictionary["mediaURL"] as! String
                    
                    let firstName = studentFirstName.firstName!
                    let lastName = studentFirstName.lastName!
                    let fullName = firstName + " " + lastName as! String
                    let mediaURL = studentFirstName.mediaURL as! String
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                    
                    print("Annotations array = \(annotations)")
                }
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
            }
        }
        
//        // The "locations" array is an array of dictionary objects that are similar to the JSON
//        // data that you can download from parse.
//        let locations = hardCodedLocationData()
//        
//        // We will create an MKPointAnnotation for each dictionary in "locations". The
//        // point annotations will be stored in this array, and then provided to the map view.
//        var annotations = [MKPointAnnotation]()
//        
//        // The "locations" array is loaded with the sample data below. We are using the dictionaries
//        // to create map annotations. This would be more stylish if the dictionaries were being
//        // used to create custom structs. Perhaps StudentLocation structs.
//        
//        for dictionary in locations {
//            
//            // Notice that the float values are being used to create CLLocationDegree values.
//            // This is a version of the Double type.
//            let lat = CLLocationDegrees(dictionary["latitude"] as! Double)
//            let long = CLLocationDegrees(dictionary["longitude"] as! Double)
//            
//            // The lat and long are used to create a CLLocationCoordinates2D instance.
//            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
//            
//            let first = dictionary["firstName"] as! String
//            let last = dictionary["lastName"] as! String
//            let mediaURL = dictionary["mediaURL"] as! String
//            
//            // Here we create the annotation and set its coordiate, title, and subtitle properties
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = coordinate
//            annotation.title = "\(first) \(last)"
//            annotation.subtitle = mediaURL
//            
//            // Finally we place the annotation in an array of annotations.
//            annotations.append(annotation)
//        }
//        
//        // When the array is complete, we add the annotations to the map.
//        self.mapView.addAnnotations(annotations)
        
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                let url = URL(string: toOpen)
                //app.openURL(URL(string: toOpen)!)
                app.open(url!, options: [:], completionHandler:  {
                    (success) in
                    print("Open")
                })
            }
        }
    }
    
//    func hardCodedLocationData() -> [[String : Any]] {
//        return  [
//            [
//                "createdAt" : "2015-02-24T22:27:14.456Z",
//                "firstName" : "Jessica",
//                "lastName" : "Uelmen",
//                "latitude" : 28.1461248,
//                "longitude" : -82.75676799999999,
//                "mapString" : "Tarpon Springs, FL",
//                "mediaURL" : "www.linkedin.com/in/jessicauelmen/en",
//                "objectId" : "kj18GEaWD8",
//                "uniqueKey" : 872458750,
//                "updatedAt" : "2015-03-09T22:07:09.593Z"
//            ], [
//                "createdAt" : "2015-02-24T22:35:30.639Z",
//                "firstName" : "Gabrielle",
//                "lastName" : "Miller-Messner",
//                "latitude" : 35.1740471,
//                "longitude" : -79.3922539,
//                "mapString" : "Southern Pines, NC",
//                "mediaURL" : "http://www.linkedin.com/pub/gabrielle-miller-messner/11/557/60/en",
//                "objectId" : "8ZEuHF5uX8",
//                "uniqueKey" : 2256298598,
//                "updatedAt" : "2015-03-11T03:23:49.582Z"
//            ], [
//                "createdAt" : "2015-02-24T22:30:54.442Z",
//                "firstName" : "Jason",
//                "lastName" : "Schatz",
//                "latitude" : 37.7617,
//                "longitude" : -122.4216,
//                "mapString" : "18th and Valencia, San Francisco, CA",
//                "mediaURL" : "http://en.wikipedia.org/wiki/Swift_%28programming_language%29",
//                "objectId" : "hiz0vOTmrL",
//                "uniqueKey" : 2362758535,
//                "updatedAt" : "2015-03-10T17:20:31.828Z"
//            ], [
//                "createdAt" : "2015-03-11T02:48:18.321Z",
//                "firstName" : "Jarrod",
//                "lastName" : "Parkes",
//                "latitude" : 34.73037,
//                "longitude" : -86.58611000000001,
//                "mapString" : "Huntsville, Alabama",
//                "mediaURL" : "https://linkedin.com/in/jarrodparkes",
//                "objectId" : "CDHfAy8sdp",
//                "uniqueKey" : 996618664,
//                "updatedAt" : "2015-03-13T03:37:58.389Z"
//            ]
//        ]
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
    
    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
        
        let logOutSession = UdacityClient()
        
        logOutSession.deleteSession()
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        //self.performSegue(withIdentifier: "AddLocation", sender: self)
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
    @objc func addPin(sender: UIBarButtonItem) {
        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
        navigationController!.pushViewController(addLocationNavVC, animated: true)
    }
    
    @objc func refreshData(sender: UIBarButtonItem) {
        //self.activityIndicatorView.startAnimating()
        //refreshData(self)
        ActivityIndicatorOverlay.show("Loading...")
        
        // simulate time consuming work
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideIndicator), userInfo: nil, repeats: false)
        
        //self.reloadData()
    }
    @objc func hideIndicator() {
        ActivityIndicatorOverlay.hide()
    }
    
    
}
