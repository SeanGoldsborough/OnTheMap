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
    
    var locationPassed: String = ""
    var websitePassed: String = ""
    var uniqueKey = APIClient.sharedInstance().uniqueID
    
    @IBAction func addStudentLocation() {
        overwriteLocation()
        APIClient.sharedInstance().postUserPARSE(mapString: self.locationPassed, studentURL: self.websitePassed) { (success, error) in
            print("pressed post student!")
            print(UdacityPersonalData.sharedInstance().createdAt)
            print(UdacityPersonalData.sharedInstance().firstName)
            print(UdacityPersonalData.sharedInstance().lastName)
            print(UdacityPersonalData.sharedInstance().latitude)
            print(UdacityPersonalData.sharedInstance().longitude)
            print(UdacityPersonalData.sharedInstance().mapString)
            print(UdacityPersonalData.sharedInstance().mediaURL)
            print(UdacityPersonalData.sharedInstance().objectId)
            print(UdacityPersonalData.sharedInstance().uniqueKey)
            print(UdacityPersonalData.sharedInstance().updatedAt)
        }
        
        //TODO: Parse POST/PUT Method Goes Here
        // If student ID already exisits in the database of locations call PUT method to update
        // Else call POST method to add a new location for that particular student ID Number
        //let mapVC = storyboard?.instantiateViewController(withIdentifier: "MapVC") as! MapVC
//        self.navigationController!.popToViewController(listVC, animated: true)
        
//        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
//        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        //mapVC.activityView.startAnimating()
//        mapVC.LoadingIndicatorView.show(mapView, loadingText: "Loading")
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.doWork), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        cityLabel.text = locationPassed.capitalized
        
        print(websitePassed)
        
        performUIUpdatesOnMain {
            self.activityIndicator.startAnimating()
            ActivityIndicatorOverlay.show("Locating...")
        }
        
        
        
//        // set initial location in Honolulu
//        let initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
//
//        let regionRadius: CLLocationDistance = 1000
//        func centerMapOnLocation(location: CLLocation) {
//            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
//                                                                      regionRadius, regionRadius)
//            mapView.setRegion(coordinateRegion, animated: true)
//        }
//
//        centerMapOnLocation(location: initialLocation)
        
        
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
        annotation.title = "UserName"
        annotation.subtitle = websitePassed
        
        
        
        
        locationUpdate( { (results, error) in
            

            
            if let error = error {
                print("locationUpdate Error is: \(error)")
                AlertView.alertPopUp(view: self, alertMessage: "Could not load location")
                
            } else if results == true {
                //completionHandlerForGeocoding(true, nil)
                performUIUpdatesOnMain {
                    self.activityIndicator.stopAnimating()
                    ActivityIndicatorOverlay.hide()
                }
                
                print("locationUpdate results is: \(results)")
                
            }
            
        })
    }
    
//        func getCoordinate( addressString: String,
//                            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
//            var addressString = cityLabel.text
//            let geocoder = CLGeocoder()
//            geocoder.geocodeAddressString(addressString!) { (placemarks, error) in
//                if error == nil {
//                    if let placemark = placemarks?[0] {
//                        let location = placemark.location!
//
//                        completionHandler(location.coordinate, nil)
//                        print(addressString)
//                        print(placemark.location)
//                        return
//                    }
//                }
//
//                completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
//
//            }
//
//        }
        

    
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
        }
        else {
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
    
    
    func overwriteLocation(){
        let pushedVC = self.storyboard!.instantiateViewController(withIdentifier: "PushedVC")
        
        let alertVC = UIAlertController(
            title: "Confirm Overwrite Your Current Location?".capitalized,
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
                //self.navigationController!.pushViewController(pushedVC, animated: true)
                let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        })
        
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print("got location \(locations)")
//        print("my location \(myPosition)")
//        print(String(describing: myPosition))
//        myPosition = (locationManager.location?.coordinate)!
//        //locationManager.stopUpdatingLocation()
//        self.label.text = "\(myPosition)"
//
//        let span = MKCoordinateSpanMake(0.05, 0.05)
//        let region = MKCoordinateRegion(center: myPosition, span: span)
//        mapView.setRegion(region, animated: true)
//    }

//    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print(#function)
//        let url = URL(string:websitePassed)
//        print(url)
//
//        if control == view {
//            //performSegue(withIdentifier: "toTheMoon", sender: self)
//            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        }
//    }
//
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
            }
        }
        completionHandlerForGeocoding(true, nil)
    }

}

