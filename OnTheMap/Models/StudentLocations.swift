//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/4/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class StudentArray : NSObject {
    public var listOfStudents : [StudentLocations] = []
 
    static let sharedInstance = StudentArray()
}

// MARK: Shared Instance


struct StudentLocations {
    
    public var createdAt : String?
    public var firstName : String?
    public var lastName : String?
    public var latitude : Double?
    public var longitude : Double?
    public var mapString : String?
    public var mediaURL : String?
    public var objectId : String?
    public var uniqueKey : String?
    public var updatedAt : String?
    
    init?(dictionary: [String:AnyObject]) {
        
        createdAt = dictionary["createdAt"] as? String ?? "no value"
        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
        latitude = dictionary["latitude"] as? Double ?? 0.00
        longitude = dictionary["longitude"] as? Double ?? 0.00
        mapString = dictionary["mapString"] as? String ?? "No Map String"
        mediaURL = dictionary["mediaURL"] as? String ?? "[No URL]"
        objectId = dictionary["objectId"] as? String ?? "no value"
        uniqueKey = dictionary["uniqueKey"] as? String ?? "[No Unique Key Value]"
        updatedAt = dictionary["updatedAt"] as? String ?? "[No Updated At Value]"// Date ?? 2000-01-01T10:42:39.989Z
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentLocations] {
        
        var students = [StudentLocations]()
        var studentList = StudentArray.sharedInstance.listOfStudents
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            students.append(StudentLocations(dictionary: result)!)
            studentList.append(StudentLocations(dictionary: result)!)
            
        }
        return students
    }
     
}
