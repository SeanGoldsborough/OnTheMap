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
        
        for key in moreStudents {
            print(key.uniqueKey)
            studentsArray.append(key.uniqueKey!)
        }
        
        if studentsArray.contains(uniqueKey!) {
            
            APIClient.sharedInstance().putUserPARSE(mapString: locationPassed, studentURL: websitePassed) { (success, error) in
                
                if success == true {
                    performUIUpdatesOnMain {
                        AlertView.overwriteLocation(view: self, tabBarView: TabBarControllerViewController())
                        ActivityIndicatorOverlay.hide()
                        print("will go back to tab now...\(success)")
                        self.finishButton.isEnabled = true
                    }
                } else {
                    performUIUpdatesOnMain {
                        ActivityIndicatorOverlay.hide()
                        AlertView.alertPopUp(view: self, alertMessage: error! ?? "Submission Unsuccessful")
                        self.finishButton.isEnabled = true
                    }
                }
            }
        } else {
            
            APIClient.sharedInstance().postUserPARSE(mapString: locationPassed, studentURL: websitePassed) { (success, error) in
                
                if success == true {
                    performUIUpdatesOnMain {
                        AlertView.overwriteLocation(view: self, tabBarView: TabBarControllerViewController())
                        ActivityIndicatorOverlay.hide()
                        self.finishButton.isEnabled = true
                    }
                } else {
                    performUIUpdatesOnMain {
                        ActivityIndicatorOverlay.hide()
                        AlertView.alertPopUp(view: self, alertMessage: error! ?? "Submission Unsuccessful")
                        self.finishButton.isEnabled = true
                    }
                }
            }
          }
        }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cityLabel.text = locationPassed.capitalized
        
        performUIUpdatesOnMain {
            ActivityIndicatorOverlay.show(self.mapView, loadingText: "Locating...")
            self.finishButton.isEnabled = false
        }
      
        locationUpdate( { (results, error) in

            if let error = error {
                
                performUIUpdatesOnMain {
                    AlertView.popToAddLocationVC(view: self)
                    ActivityIndicatorOverlay.hide()
                }
            } else if results == true {
               
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
        
        let url = URL(string:websitePassed)
        if control == view.rightCalloutAccessoryView {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }

   
    //THIS IS WHERE WE CONVERT STRING TO COORDS
    func locationUpdate(_ completionHandlerForGeocoding: @escaping (_ success: Bool, _ errorString: Error?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        
        guard let mapView = mapView,
            let searchText = cityLabel.text else { return }
        
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let response = response else {
                completionHandlerForGeocoding(false, error)
                
                return
            }
            
            for item in response.mapItems {

                UdacityPersonalData.sharedInstance().mapString = searchText
                UdacityPersonalData.sharedInstance().latitude = item.placemark.coordinate.latitude
                UdacityPersonalData.sharedInstance().longitude = item.placemark.coordinate.longitude
                UdacityPersonalData.sharedInstance().mediaURL = self.websitePassed
                
                self.matchingItems.append(item as MKMapItem)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
                annotation.title = UdacityPersonalData.sharedInstance().firstName! + " " + UdacityPersonalData.sharedInstance().lastName!
                annotation.subtitle = UdacityPersonalData.sharedInstance().mediaURL
                self.mapView.addAnnotation(annotation)
                
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
