//
//  UdacityPersonalData.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/25/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
// TODO: Swift 4 CODABLE
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
    
//        init?(udacityPersonalDataDict: [String:AnyObject]) {
//    
//            createdAt = udacityPersonalDataDict["createdAt"] as? Date
//            firstName = udacityPersonalDataDict["firstName"] as? String
//            lastName = udacityPersonalDataDict["lastName"] as? String
//            latitude = udacityPersonalDataDict["latitude"] as? Double
//            longitude = udacityPersonalDataDict["longitude"] as? Double
//            mapString = udacityPersonalDataDict["mapString"] as? String
//            mediaURL = udacityPersonalDataDict["mediaURL"] as? String
//            objectId = udacityPersonalDataDict["objectId"] as? String ?? ""
//            uniqueKey = udacityPersonalDataDict["uniqueKey"] as? String
//            updatedAt = udacityPersonalDataDict["updatedAt"] as? Date
//        }

    
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityPersonalData {
        struct Singleton {
            static var sharedInstance = UdacityPersonalData()
        }
        return Singleton.sharedInstance
    }
    
}
