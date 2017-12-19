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

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ActivityIndicatorOverlay.show(self.view, loadingText: "Locating...")
        
        mapView.delegate = self
        self.navigationController?.navigationBar.isHidden = false
        
        let refreshButton = UIBarButtonItem(image: #imageLiteral(resourceName: "icon_refresh"), landscapeImagePhone: #imageLiteral(resourceName: "icon_refresh"), style: .plain, target: self, action: #selector(refreshData(sender: )))
        navigationItem.rightBarButtonItems = [refreshButton]
        
        
        getStudents()
//        populateMap()
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
        //mapView.removeAnnotations(annotations)
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
//            annotation.coordinate = coordinate
//            annotation.name = "\(firstName) \(lastName)"
//            annotation.mediaURL = mediaURL
            
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
    
    @objc func refreshData(sender: UIBarButtonItem) {
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.show(self.view, "Loading...")
            self.populateMap()
        }
        print("mapView has been reloaded")
    }
    
    func printFunc() {
        print("printFunc has been called and should reload mapView")
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
    
    
    
//    @objc func logoutButtonTapped(sender: UIBarButtonItem) {
//
//        print("old logout button tapped!")
//
//        let logOutSession = UdacityClient()
//
//        logOutSession.deleteSession()
//        let loginVC = self.storyboard!.instantiateViewController(withIdentifier: "LoginVC")
//        //self.performSegue(withIdentifier: "AddLocation", sender: self)
//        self.present(loginVC, animated: true, completion: nil)
//
//    }
    
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


