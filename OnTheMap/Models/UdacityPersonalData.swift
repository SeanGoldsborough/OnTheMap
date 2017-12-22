//
//  UdacityPersonalData.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/25/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

class UdacityPersonalData : NSObject {
    
    public var createdAt : Date?
    public var firstName : String? = "No Value"
    public var lastName : String? = "No Value"
    public var latitude : Double? = 0.0
    public var longitude : Double? = 0.0
    public var mapString : String? = ""
    public var mediaURL : String? = ""
    public var objectId : String? = ""
    public var uniqueKey : String? = ""
    public var updatedAt : Date?
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityPersonalData {
        struct Singleton {
            static var sharedInstance = UdacityPersonalData()
        }
        return Singleton.sharedInstance
    }
    
}
