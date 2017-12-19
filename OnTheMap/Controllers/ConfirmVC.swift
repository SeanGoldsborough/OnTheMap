//
//  ConfirmVC.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/6/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class ConfirmVC: UIViewController, MKMapViewDelegate {
    
    var matchingItems: [MKMapItem] = [MKMapItem]()
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var finishButton: UIButton!
    
    var locationPassed: String = ""
    var websitePassed: String = ""
    var uniqueKey = APIClient.sharedInstance().uniqueID
    
    @IBAction func addStudentLocation() {
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.show(self.mapView, loadingText: "Updating...")
            self.finishButton.isEnabled = false
        }
        
        
        let uniqueKey = UdacityPersonalData.sharedInstance().uniqueKey
        var studentsArray = ["10081758676"]
        let moreStudents = StudentArray.sharedInstance.listOfStudents
        print("more students: \(moreStudents)")
        
        for key in moreStudents {
            print(key.uniqueKey)
            studentsArray.append(key.uniqueKey!)
        }
        
        if studentsArray.contains(uniqueKey!) {
            print("calling ParsePUTFunction")
            
            APIClient.sharedInstance().putUserPARSE(mapString: self.locationPassed, studentURL: self.websitePassed) { (success, error) in
                print("pressed PUT student!")
                print("PUT student success is...\(success)")
                print("PUT student error is...\(error)")
                
                if success == true {
                    performUIUpdatesOnMain {
                        AlertView.overwriteLocation(view: self, tabBarView: TabBarControllerViewController())
                        ActivityIndicatorOverlay.hide()
                        print("will log in now...\(success)")
                        self.finishButton.isEnabled = true
                    }
                } else {
                    performUIUpdatesOnMain {
                        ActivityIndicatorOverlay.hide()
                        AlertView.alertPopUp(view: self, alertMessage: "Submission Unsuccessful")
                        self.finishButton.isEnabled = true
                    }
                }
            }
        } else {
            print("calling ParsePOSTFunction")
            
            APIClient.sharedInstance().postUserPARSE(mapString: self.locationPassed, studentURL: self.websitePassed) { (success, error) in
                print("pressed post student!")
                print("post student success is...\(success)")
                print("post student error is...\(error)")
                
                if success == true {
                    performUIUpdatesOnMain {
                        AlertView.overwriteLocation(view: self, tabBarView: TabBarControllerViewController())
                        ActivityIndicatorOverlay.hide()
                        print("will log in now...\(success)")
                        self.finishButton.isEnabled = true
                    }
                } else {
                    performUIUpdatesOnMain {
                        ActivityIndicatorOverlay.hide()
                        AlertView.alertPopUp(view: self, alertMessage: "Submission Unsuccessful")
                        self.finishButton.isEnabled = true
                    }
                }
            }
          }
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cityLabel.text = locationPassed.capitalized
        
        print(websitePassed)
        
        print("printing the objectID from udacity personal data\(UdacityPersonalData.sharedInstance().objectId)")
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.show(self.mapView, loadingText: "Locating...")
            self.finishButton.isEnabled = false
        }
      
        locationUpdate( { (results, error) in

            if let error = error {
                print("locationUpdate Error is: \(error)")
                performUIUpdatesOnMain {
                    AlertView.popToAddLocationVC(view: self)
                    ActivityIndicatorOverlay.hide()
                }
            } else if results == true {
                //completionHandlerForGeocoding(true, nil)
                print("locationUpdate results is: \(results)")
            }
        })
    }
    
    // Called when the annotation was added
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
            pinView?.canShowCallout = true
            pinView?.isDraggable = true
            pinView?.pinTintColor = .purple
            
            let rightButton: AnyObject! = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = rightButton as? UIView
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        print(#function)
        let url = URL(string:websitePassed)
        if control == view.rightCalloutAccessoryView {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }

    
    // TODO: Add completion handler to this func so when done it stops the activity view from animated if success and if error present ALERTsd
    //THIS IS WHERE WE CONVERT STRING TO COORDS!
    func locationUpdate(_ completionHandlerForGeocoding: @escaping (_ success: Bool, _ errorString: Error?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        print("THIS IS WHERE WE CONVERT STRING TO COORDS!")
        
        guard let mapView = mapView,
            let searchText = cityLabel.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                completionHandlerForGeocoding(false, error)
                print("There was an error searching for: error: ")

                return
            }
            
            for item in response.mapItems {
                print(searchText)
                print("item in map search response is: \(item)")
                print("item in map search lat is: \(item.placemark.coordinate.latitude)")
                print("item in map search long is: \(item.placemark.coordinate.longitude)")
                
                
                UdacityPersonalData.sharedInstance().mapString = searchText
                UdacityPersonalData.sharedInstance().latitude = item.placemark.coordinate.latitude
                UdacityPersonalData.sharedInstance().longitude = item.placemark.coordinate.longitude
                UdacityPersonalData.sharedInstance().mediaURL = self.websitePassed
                
                print("The value of UdacityPersonalData lat is now: \(UdacityPersonalData.sharedInstance().mapString!)")
                print("The value of UdacityPersonalData lat is now: \(UdacityPersonalData.sharedInstance().latitude!)")
                print("The value of UdacityPersonalData long is now: \(UdacityPersonalData.sharedInstance().longitude!)")
                print("The value of UdacityPersonalData mediaURL is now: \(UdacityPersonalData.sharedInstance().mediaURL!)")
                print("The value of UdacityPersonalData objectID is now: \(UdacityPersonalData.sharedInstance().objectId!)")
                
                self.matchingItems.append(item as MKMapItem)
                print("Matching items = \(self.matchingItems.count)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = UdacityPersonalData.sharedInstance().firstName! + " " + UdacityPersonalData.sharedInstance().lastName!
                annotation.subtitle = UdacityPersonalData.sharedInstance().mediaURL
                self.mapView.addAnnotation(annotation)
                //self.mapView.setRegion(annotation.coordinate, animated: true)
                let initialLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                let regionRadius: CLLocationDistance = 1000
                        func centerMapOnLocation(location: CLLocation) {
                            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                                      regionRadius, regionRadius)
                            mapView.setRegion(coordinateRegion, animated: true)
                          }
                
                centerMapOnLocation(location: initialLocation)
                performUIUpdatesOnMain {
                    ActivityIndicatorOverlay.hide()
                    self.finishButton.isEnabled = true
                }
            }
        }
        completionHandlerForGeocoding(true, nil)
    }
}
