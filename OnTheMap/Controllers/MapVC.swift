//
//  MapVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//  Audrey Tam - https://www.raywenderlich.com/160517/mapkit-tutorial-getting-started

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
                let tabVC = self.storyboard!.instantiateViewController(withIdentifier: "TabBarController")
                var mapNavCont = UINavigationController() //self.storyboard!.instantiateViewController(withIdentifier: "MapNavCont")
                
                performUIUpdatesOnMain {
                    ActivityIndicatorOverlay.hide()
                    tabVC.navigationController?.dismiss(animated: true, completion: nil)
//                    tabVC.navigationController?.popViewController(animated: true)
                    self.navigationController?.popViewController(animated: true)
                    mapNavCont.dismiss(animated: true, completion: nil)
                    self.navigationController?.dismiss(animated: true, completion: {
                        mapNavCont.dismiss(animated: true, completion: nil)
                    })
                    
                    
                    tabVC.dismiss(animated: true, completion: nil)
                    self.dismiss(animated: true, completion: nil)
                    
                }
                
                print("logged out")
                
            } else {
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)//"Error Logging Out")
                    ActivityIndicatorOverlay.hide()
                }
                
                print("error logging out")
            }
        }
    }
    
    @IBAction func addPinButton(_ sender: Any) {
       
        
        let uniqueKey = UdacityPersonalData.sharedInstance().uniqueKey
        var studentsArray = ["10081758676"]
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        
        
        for key in moreStudents {
            studentsArray.append(key.uniqueKey!)
        }
        
        if studentsArray.contains(uniqueKey!) {
            AlertView.addLocationAlert(view: self, alertTitle: "Update Location", alertMessage: "Would you like update a location?")
            
        } else {
            AlertView.addLocationAlert(view: self, alertTitle: "New Location", alertMessage: "Would you like to add a new location?")
        }
        
    }
    
    @IBAction func refreshButton(_ sender: Any) {
        ActivityIndicatorOverlay.show(view, loadingText: "Locating...")
        getStudents()
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        print("student array shared instance count is: \(moreStudents.count)")
       
        
        }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ActivityIndicatorOverlay.show(view, loadingText: "Locating...")
        
        mapView.delegate = self

        getStudents()

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        print("map view did disappear")
    }
    
    
    func getStudents() {
        
        APIClient.sharedInstance().getStudentLocationsParse { (studentsResults, error) in
            print("The StudentArray.sharedInstance.listOfStudents array  count is: \(StudentArray.sharedInstance.listOfStudents.count)")
            
            if let students = studentsResults {
                
                self.students = students
                StudentArray.sharedInstance.listOfStudents = students
                
                if students.count < 1 {
                    
                    performUIUpdatesOnMain {
                        AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)//"Networking Error on GET All Students")
                        ActivityIndicatorOverlay.hide()
                    }
                    
                } else {
                    self.populateMap()
                    self.getPublicUserData()
                    self.getOneStudent()
                    performUIUpdatesOnMain {
                     print("The StudentArray.sharedInstance.listOfStudents array  count is now: \(StudentArray.sharedInstance.listOfStudents.count)")
                    }
                }
            } else {
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)//"Networking Error on GET All Students")
                    ActivityIndicatorOverlay.hide()
                }
            }
        }
    }
    
    func getPublicUserData() {
        
        APIClient.sharedInstance().getPublicUserDataUdacity { (result, error) in
            
            if let results = result {
                print("printing results from getPublicDataUdacity:\(results)")
                
            } else {
                
                print("There was an error with your request: getStudents: \(error)")
                
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!)//"Networking Error on GET All Students")
                }
            }
        }
    }
    
    func populateMap() {
       
        performUIUpdatesOnMain {
            self.mapView.removeAnnotations(self.annotations)
        }
        annotations.removeAll()
        
        print("annotations array  count is: \(annotations.count)")
        let studentsArray = students
       
        for dictionary in studentsArray {
            
            let studentData = dictionary
            let coordinate = CLLocationCoordinate2D(latitude: dictionary.latitude!, longitude: dictionary.longitude!)
            let firstName = studentData.firstName!
            let lastName = studentData.lastName!
            let fullName = firstName + " " + lastName as! String
            let mediaURL = studentData.mediaURL as! String
            
            let annotation = StudentMapPins(title: fullName, subTitle: mediaURL, coordinate: coordinate)
            
            annotations.append(annotation)
            print("annotations array  count is now: \(annotations.count)")
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
                performUIUpdatesOnMain {
                    AlertView.alertPopUp(view: self, alertMessage: (error?.localizedDescription)!) //"Networking Error on GET One Student")
                }
                
            } else {
                print("getOneStudentThere was NO error with your request: \(result)")
    
            }
        })
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
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}


