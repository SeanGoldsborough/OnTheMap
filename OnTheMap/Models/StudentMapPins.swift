//
//  StudentMapPins.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/18/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class StudentMapPins: NSObject, MKAnnotation {
    let title: String?
    let subTitle: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subTitle = subTitle
        self.coordinate = coordinate
        
        super.init()
    }
    
    var subtitle: String? {
        return subTitle
    }
    
    // Annotation right callout accessory opens this mapItem in Maps app
    func mapItem() -> MKMapItem {
        let addressDict = [CNPostalAddressStreetKey: subTitle]
        let placemark = MKPlacemark(coordinate: coordinate, addressDictionary: addressDict)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}
