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
    
    var students = StudentArray.sharedInstance.listOfStudents
    
    var annotations = [MKPointAnnotation]()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
   

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Locating...")
        
        
        self.navigationController?.navigationBar.isHidden = false
        
        getStudents()
        populateMap()
        //getOneStudent()
        

        }
    
    
    func getStudents() {
        
        APIClient.sharedInstance().getStudentLocationsParse { (studentsResults, error) in
            
            if let students = studentsResults {
                
                self.students = students //as in the constant from if/let statement which = movies returned by comp hand
                StudentArray.sharedInstance.listOfStudents = students
                
                if students.count < 1 {
                    
                    performUIUpdatesOnMain {
                        AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
                        ActivityIndicatorOverlay.hide()
                        print("c:\(self.students)")
                    }
                    
                } else {
                    self.populateMap()
                    self.getPublicUserData()
                    self.getOneStudent()
                    performUIUpdatesOnMain {
                        print("c:\(self.students)")
                    }
                }
            } else {

                print("There was an error with your request: getStudents: \(error)")
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
                }
            }
        }
    }
    
    func getPublicUserData() {
        
        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
            
            print("printing results from getPublicDataUdacity:\(result)")
            
            if let results = result {
                print("printing results from getPublicDataUdacity:\(results)")
                
            } else {
                
                print("There was an error with your request: getStudents: \(error)")
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
                }
            }
        }
    }
    
    func populateMap() {
        let studentsArray = students
        print("printing students array MAP:\(studentsArray)")
        
        self.annotations = [MKPointAnnotation]()
        
        for dictionary in studentsArray {
            
            let studentData = dictionary
            
            print("printing studentFirstName:\(studentData)")
            
            let coordinate = CLLocationCoordinate2D(latitude: dictionary.latitude!, longitude: dictionary.longitude!)
            
            let firstName = studentData.firstName!
            let lastName = studentData.lastName!
            let fullName = firstName + " " + lastName as! String
            let mediaURL = studentData.mediaURL as! String
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            
            self.annotations.append(annotation)
        }
        print("Annotations array from PopulateMapFunc = \(self.annotations)")
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.hide()
            self.mapView.addAnnotations(self.annotations)
            self.getOneStudent()
        }
    }
    
//    func getStudents() {
//
//        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
//
//             print("printing results from getPublicDataUdacity:\(result)")
//
//            if let results = result {
//                print("printing results from getPublicDataUdacity:\(results)")
//
//            } else {
//
//                print("There was an error with your request: getStudents: \(error)")
//
//                performUIUpdatesOnMain {
//                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
//                }
//            }
//        }
//
//        APIClient.sharedInstance().getStudentLocationsParse { (studentsResults, error) in
//
//            if let students = studentsResults {
//
//                self.students = students //as in the constant from if/let statement which = movies returned by comp hand
//                StudentArray.sharedInstance.listOfStudents = students
//
//                if students.count < 1 {
//
//                    performUIUpdatesOnMain {
//                        AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
//                        print("c:\(self.students)")
//                    }
//
//                } else {
//
//                performUIUpdatesOnMain {
//                    //self.mapView.reloadData()
//                    print("c:\(self.students)")
//                }
//
//                // The "locations" array is an array of dictionary objects that are similar to the JSON
//                // data that you can download from parse.
//                let studentsArray = students
//                print("printing students array MAP:\(studentsArray)")
//                // We will create an MKPointAnnotation for each dictionary in "locations". The
//                // point annotations will be stored in this array, and then provided to the map view.
//                self.annotations = [MKPointAnnotation]()
//
//                // The "locations" array is loaded with the sample data below. We are using the dictionaries
//                // to create map annotations. This would be more stylish if the dictionaries were being
//                // used to create custom structs. Perhaps StudentLocation structs.
//
//                for dictionary in studentsArray {
//
//                    let studentData = dictionary
//                    //let studentFirstName = student.createdAt!
//
//                    print("printing studentFirstName:\(studentData)")
//
//
////                    let lat = CLLocationDegrees(dictionary.latitude as! Double)
////                    let long = CLLocationDegrees(dictionary.longitude as! Double)
////                    print("printing lat:\(lat)")
////                    print("printing long:\(long)")
//
//
//                    // The lat and long are used to create a CLLocationCoordinates2D instance.
//                    let coordinate = CLLocationCoordinate2D(latitude: dictionary.latitude!, longitude: dictionary.longitude!)
//
//                    let firstName = studentData.firstName!
//                    let lastName = studentData.lastName!
//                    let fullName = firstName + " " + lastName as! String
//                    let mediaURL = studentData.mediaURL as! String
//
//                    // Here we create the annotation and set its coordiate, title, and subtitle properties
//                    let annotation = MKPointAnnotation()
//                    annotation.coordinate = coordinate
//                    annotation.title = "\(firstName) \(lastName)"
//                    annotation.subtitle = mediaURL
//
//                    // Finally we place the annotation in an array of annotations.
//                    self.annotations.append(annotation)
//                }
//                }
//
//                // When the array is complete, we add the annotations to the map.
//
//                print("Annotations array = \(self.annotations)")
//                performUIUpdatesOnMain {
//                    ActivityIndicatorOverlay.hide()
//                    self.mapView.addAnnotations(self.annotations)
//                    self.getOneStudent()
//                }
//            } else {
//
//                print("There was an error with your request: getStudents: \(error)")
//
//                performUIUpdatesOnMain {
//                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
//                }
//            }
//
//
//        }
//
//    }
    
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
        
//    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//        let reuseId = "pin"
//
//        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
//
//        if pinView == nil {
//            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
//            pinView!.canShowCallout = true
//            pinView!.pinTintColor = .green
//            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        else {
//            pinView!.annotation = annotation
//        }
//
//        return pinView
//    }
//
//    func mapViewToUrl(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        let url  = URL(string: "http://www.apple.com/")
//        if UIApplication.shared.canOpenURL(url!) == true {
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        }
//    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        if control == view.rightCalloutAccessoryView {
//            let app = UIApplication.shared
//            if let toOpen = view.annotation?.subtitle! {
//                let url = URL(string: toOpen)
//                //app.openURL(URL(string: toOpen)!)
//                app.open(url!, options: [:], completionHandler:  {
//                    (success) in
//                    print("Open")
//                })
//            }
//        }
//    }
    
    func getOneStudent() {
        APIClient.sharedInstance().getOneStudentLocationParse({ (result, error) in
            
            if error != nil{
                print("1getOneStudentThe results of your request: \(error)")
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET One Student")
                }
                
            } else {
                print("1getOneStudentThere was an NO error with your request: \(result)")
    
            }
        })
    }
    
//    func overwriteLocation(){
//        let pushedVC = self.storyboard!.instantiateViewController(withIdentifier: "PushedVC")
//
//        let alertVC = UIAlertController(
//            title: "You Have Already posted A Student Location. Would You Like To Overwrite Your Current Location?".capitalized,
//            message: "",
//            preferredStyle: .alert)
//        let cancelAction = UIAlertAction(
//            title: "Cancel",
//            style:.default,
//            handler: nil)
//        let okAction = UIAlertAction(
//            title: "OK",
//            style:.default,
//            handler: {(action) -> Void in
//                //The (withIdentifier: "VC2") is the Storyboard Segue identifier.
//                //self.performSegue(withIdentifier: "VC2", sender: self)
//                self.navigationController!.pushViewController(pushedVC, animated: true)
//        })
//
//
//        alertVC.addAction(okAction)
//        alertVC.addAction(cancelAction)
//
//
//        self.present(alertVC, animated: true, completion: nil)
//    }
    
    
    
    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
        
        print("old logout button tapped!")
        
        let logOutSession = UdacityClient()
        
        logOutSession.deleteSession()
        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
        //self.performSegue(withIdentifier: "AddLocation", sender: self)
        self.present(loginVC, animated: true, completion: nil)
        
    }
    
//    @objc func addPin(sender: UIBarButtonItem) {
//        let addLocationNavVC = self.storyboard!.instantiateViewController(withIdentifier: "AddLocationVC") as! AddLocationVC
//        navigationController!.pushViewController(addLocationNavVC, animated: true)
//    }
    
//    @objc func refreshData(sender: UIBarButtonItem) {
//        //self.activityIndicatorView.startAnimating()
//        //refreshData(self)
//        ActivityIndicatorOverlay.show(self.view, "Loading...")
//        print("poooooooodpdpdpdpakjdha;fkjhasdf")
//        // simulate time consuming work
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(self.hideIndicator), userInfo: nil, repeats: false)
//
//        //self.reloadData()
//    }
//    @objc func hideIndicator() {
//        ActivityIndicatorOverlay.hide()
//    }
    
    
}

//extension MapVC: MKMapViewDelegate {
//    // 1
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKPointAnnotation) -> MKAnnotationView? {
//        // 2
//        
//        guard let annotation = self.annotations as? annotation else { return nil }
//        // 3
//        let identifier = "marker"
//        var view: MKMarkerAnnotationView
//        // 4
//        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
//            as? MKMarkerAnnotationView {
//            dequeuedView.annotation = annotation
//            view = dequeuedView
//        } else {
//            // 5
//            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
//        }
//        return view
//    }
//
//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
//                 calloutAccessoryControlTapped control: UIControl) {
//        let annotation = self.annotations
//        let location = view.annotation as! annotation!
//
//        //let url = view.annotation?.subtitle
//
//        let url  = URL(string: "\(location.mediaURL!)")
//        print(url)
//        print(location.mediaURL!)
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        //        if UIApplication.shared.canOpenURL(url!) == true {
//        //
//        //        }
//
//        //        let launchOptions = [MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving]
//        //        location.mapItem().openInMaps(launchOptions: launchOptions)
//    }
//}


