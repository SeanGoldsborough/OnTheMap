//
//  StudentLocations.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
// MARK: Swift 3
//struct StudentLocations {
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
//    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocations] {
//
//        var students = [StudentLocations]()
//
//        // iterate through array of dictionaries, each Movie is a dictionary
//        for result in results {
//            students.append(StudentLocations(dictionary: result)!)
//        }
//
//        return students
//    }
//}

// MARK: Swift 4
struct StudentLocations : Decodable {
    
    public var createdAt : String?
    public var firstName : String?
    public var lastName : String?
    public var latitude : Double?
    public var longitude : Double?
    public var mapString : String?
    public var mediaURL : String?
    public var objectId : String?
    public var uniqueKey : Int?
    public var updatedAt : String?
    
    init?(dictionary: [String:AnyObject]) {
        // How do you get data from json decoding into json response keys?
        //title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        
        createdAt = dictionary["createdAt"] as? String ?? "no value"
        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
        latitude = dictionary["latitude"] as? Double ?? 0.00
        longitude = dictionary["longitude"] as? Double ?? 0.00
        mapString = dictionary["mapString"] as? String ?? "No Map String"
        mediaURL = dictionary["mediaURL"] as? String ?? "[No URL]"
        objectId = dictionary["objectId"] as? String ?? "no value"
        uniqueKey = dictionary["uniqueKey"] as? Int ?? 0
        updatedAt = dictionary["updatedAt"] as? String ?? "no value"
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocations] {
        
        var students = [StudentLocations]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(StudentLocations(dictionary: result)!)
        }
        
        print(students)
        return students
    }
}



