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
    var locationPassed: String = ""
    var websitePassed: String = ""
    var uniqueKey = APIClient.sharedInstance().uniqueID
    
    @IBAction func addStudentLocation() {
        //TODO: Parse POST/PUT Method Goes Here
        // If student ID already exisits in the database of locations call PUT method to update
        // Else call POST method to add a new location for that particular student ID Number
//        let listVC = storyboard?.instantiateViewController(withIdentifier: "ListVC") as! ListVC
//        self.navigationController!.popToViewController(listVC, animated: true)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true);
        
//        LoadingIndicatorView.show(mapView, loadingText: "Loading")
//        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(ViewController.doWork), userInfo: nil, repeats: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityLabel.text = locationPassed
        print(websitePassed)
        
        
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
        
        locationUpdate()
        
        //mapView.addAnnotation(annotation)
        
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
//
//
//
//
//
//
//
//
//
//
//
//
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
        
    }
    
    
    
    
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
            let searchText = cityLabel.text else { return }
        
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
                print("item in map search response is: \(item)")
                //                mapView.setRegion(item.placemark, animated: true)
                //                mapView.
                //                let randomIndex = Int(arc4random_uniform(UInt32(response.mapItems.count)))
                //                let mapItem = response.mapItems[randomIndex]
                print("item in map search lat is: \(item.placemark.coordinate.latitude)")
                print("item in map search long is: \(item.placemark.coordinate.longitude)")
                    APIClient.sharedInstance().latitude = "\(item.placemark.coordinate.latitude)"
                    APIClient.sharedInstance().longitude = "\(item.placemark.coordinate.longitude)"
                print("item in map search lat is: \(APIClient.sharedInstance().latitude!)")
                print("item in map search long is: \(APIClient.sharedInstance().longitude!)")
                
                //mapItem.openInMaps(launchOptions: nil)
                //self.locationText.text = "\(mapItem.placemark)"
                //self.location = CLLocationCoordinate2DMake(item.placemark.coordinate)
                
                self.matchingItems.append(item as MKMapItem)
                print("Matching items = \(self.matchingItems.count)")
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = item.placemark.coordinate
//                annotation.title = item.name
//                annotation.subtitle = "\(String(describing: item.url))"
                
                annotation.title = self.uniqueKey
                annotation.subtitle = self.websitePassed
                self.mapView.addAnnotation(annotation)
                //self.mapView.setRegion(annotation.coordinate, animated: true)
                let initialLocation = annotation.coordinate
                let regionRadius: CLLocationDistance = 1000
                        func centerMapOnLocation(location: CLLocation) {
                            let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                                      regionRadius, regionRadius)
                            mapView.setRegion(coordinateRegion, animated: true)
                        }
                
                //centerMapOnLocation(location: initialLocation)
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

