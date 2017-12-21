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

    var annotations = [MKAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBAction func logoutButton(_ sender: Any) {
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Logging out...")
        APIClient.sharedInstance().deleteSessionUdacity(sessionID: APIClient.sharedInstance().sessionID) { (success, error) in
            if success == true {
                let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
                
                performUIUpdatesOnMain {
                    ActivityIndicatorOverlay.hide()
                    self.present(loginVC, animated: true, completion: nil)
                }
                
                print("logged out")
                
            } else {
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Error Logging Out")
                    ActivityIndicatorOverlay.hide()
                }
                
                print("error logging out")
            }
        }
    }
    
    @IBAction func addPinButton(_ sender: Any) {
        print("addPin has been pressed")
        
        let uniqueKey = UdacityPersonalData.sharedInstance().uniqueKey
        var studentsArray = ["10081758676"]
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        print("more students: \(moreStudents)")
        
        for key in moreStudents {
            print(key.uniqueKey)
            studentsArray.append(key.uniqueKey!)
        }
        
        if studentsArray.contains(uniqueKey!) {
            print("students array contains value for current user")
            AlertView.addLocationAlert(view: self, alertTitle: "Update Location", alertMessage: "Would you like update a location?")
            
        } else {
            print("current user has not yet created a location")
            AlertView.addLocationAlert(view: self, alertTitle: "New Location", alertMessage: "Would you like to add a new location?")
        }
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        ActivityIndicatorOverlay.show(self.view, loadingText: "Locating...")
        getStudents()
        
        }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Locating...")
        
        mapView.delegate = self

        getStudents()

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
                        
                    }
                    
                } else {
                    self.populateMap()
                    self.getPublicUserData()
                    self.getOneStudent()
                    performUIUpdatesOnMain {
                       
                    }
                }
            } else {

                print("There was an error with your request: getStudents: \(error)")
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: "Networking Error on GET All Students")
                    ActivityIndicatorOverlay.hide()
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
        self.annotations.removeAll()
        print("populateMap has been called:\(populateMap)")
        let studentsArray = students
        print("printing students array MAP:\(studentsArray)")
        
        for dictionary in studentsArray {
            
            let studentData = dictionary
            
            print("printing studentFirstName:\(studentData)")
            
            let coordinate = CLLocationCoordinate2D(latitude: dictionary.latitude!, longitude: dictionary.longitude!)
            
            let firstName = studentData.firstName!
            let lastName = studentData.lastName!
            let fullName = firstName + " " + lastName as! String
            let mediaURL = studentData.mediaURL as! String
            
            let annotation = StudentMapPins(title: fullName, subTitle: mediaURL, coordinate: coordinate)
            
//            self.annotations.removeAll()
            self.annotations.append(annotation)
        }
        print("Annotations array from PopulateMapFunc = \(self.annotations)")
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.hide()
            self.mapView.addAnnotations(self.annotations)
            self.getOneStudent()
        }
    }
  
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
    
    func printFunc() {
        print("printFunc has been called and should reload mapView")
        self.populateMap()
    }
    
}



extension MapVC: MKMapViewDelegate {
    // 1
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? StudentMapPins else { print("errorAnno"); return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        let location = view.annotation as! StudentMapPins
        
        let url  = URL(string: "\(location.subTitle!)")
        print(url)
        print(location.subTitle)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}


