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

//import Foundation
// MARK: Swift 3
//struct UdacityPersonalData {
//
//    public var createdAt : String?
//    public var firstName : String?
//    public var lastName : String?
//    public var latitude : Double?
//    public var longitude : Double?
//    public var mapString : String?
//    public var mediaURL : String?
//    public var objectId : String?
//    public var uniqueKey : Int?
//    public var updatedAt : String?
//
//    init?(dictionary: [String:AnyObject]) {
//
//        //title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
//
//        createdAt = dictionary["createdAt"] as? String
//        firstName = dictionary["firstName"] as? String
//        lastName = dictionary["lastName"] as? String
//        latitude = dictionary["latitude"] as? Double
//        longitude = dictionary["longitude"] as? Double
//        mapString = dictionary["mapString"] as? String
//        mediaURL = dictionary["mediaURL"] as? String
//        objectId = dictionary["objectId"] as? String
//        uniqueKey = dictionary["uniqueKey"] as? Int
//        updatedAt = dictionary["updatedAt"] as? String
//    }
//
//    static func userFromResults(_ results: [[String:AnyObject]]) -> [UdacityPersonalData] {
//
//        var user = [UdacityPersonalData]()
//
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            user(UdacityPersonalData(dictionary: result)!)
//        }
//
//        return user
//    }
//}

// MARK: Swift 4
//struct UdacityPersonalData : Decodable {
//
//    public var createdAt : String?
//    public var firstName : String?
//    public var lastName : String?
//    public var latitude : Double?
//    public var longitude : Double?
//    public var mapString : String?
//    public var mediaURL : String?
//    public var objectId : String?
//    public var uniqueKey : Int?
//    public var updatedAt : String?
//
//    init?(dictionary: [String:AnyObject]) {
//        // How do you get data from json decoding into json response keys?
//        //title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
//
//        createdAt = dictionary["createdAt"] as? String ?? "no value"
//        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
//        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
//        latitude = dictionary["latitude"] as? Double ?? 0.00
//        longitude = dictionary["longitude"] as? Double ?? 0.00
//        mapString = dictionary["mapString"] as? String ?? "No Map String"
//        mediaURL = dictionary["mediaURL"] as? String ?? "[No URL]"
//        objectId = dictionary["objectId"] as? String ?? "no value"
//        uniqueKey = dictionary["uniqueKey"] as? Int ?? 0
//        updatedAt = dictionary["updatedAt"] as? String ?? "no value"
//    }
//
//    static func userFromResults(_ results: [[String:AnyObject]]) -> [UdacityPersonalData] {
//
//        var user = [UdacityPersonalData]()
//
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            user.append(UdacityPersonalData(dictionary: result)!)
//        }
//
//        print("user from results is: \(user)")
//        return user
//    }
//}


//import Foundation
//// MARK: Swift 4
//struct UdacityPersonalData : Decodable {
//    
//    
//    public var firstName : String?
//    public var lastName : String?
//    public var latitude : Double?
//    public var longitude : Double?
//    public var mapString : String?
//    public var mediaURL : String?
//    public var uniqueKey : Int?
//    
//    
//    init?(dictionary: [String:AnyObject]) {
//        // How do you get data from json decoding into json response keys?
//        //title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
//        
//        
//        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
//        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
//        latitude = dictionary["latitude"] as? Double ?? 0.00
//        longitude = dictionary["longitude"] as? Double ?? 0.00
//        mapString = dictionary["mapString"] as? String ?? "No Map String"
//        mediaURL = dictionary["mediaURL"] as? String ?? "[No URL]"
//        uniqueKey = dictionary["uniqueKey"] as? Int ?? 0
//        
//    }
//    
//    static func personalDataFromResults(_ results: [[String:AnyObject]]) -> [UdacityPersonalData] {
//        
//        var personalData = [UdacityPersonalData]()
//        
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            personalData.append(UdacityPersonalData(dictionary: result)!)
//        }
//        
//        print(personalData)
//        return personalData
//    }
//}

