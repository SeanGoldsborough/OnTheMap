//////
//////  StudentLocation.swift
//////  OnTheMap
//////
//////  Created by Sean Goldsborough on 10/20/17.
//////  Copyright © 2017 Sean Goldsborough. All rights reserved.
//////
//
//import Foundation
//import UIKit
//
//struct StudentLocation {
//
//         let createdAt: Date
//         let firstName: String
//         let lastName: String
//         let latitude: Double
//         let longitude: Double
//         let mapString: String
//         let mediaURL: String
//         let objectID: String
//         let uniqueKey: String
//         let updatedAt: Date
//    
//    
////    init {
////         let createdAt: Date
////         let firstName: String
////         let lastName: String
////         let latitude: Float
////         let longitude: Float
////         let mapString: String
////         let mediaURL: String
////         let objectID: String
////         let uniqueKey: String
////         let updatedAt: Date
////    }
//    
//    
//    var fullName: String {
//        return "\(firstName) \(lastName)"
//    }
//    
//    /*
//     * Construct a student from a dictionary
//     */
//    init(dictionary: [String : AnyObject]) {
//        createdAt = dictionary["createdAt"] as! Date!
//        firstName = dictionary["firstName"] as! String!
//        lastName = dictionary["lastName"] as! String!
//        latitude = dictionary["latitude"] as! Double
//        longitude = dictionary["longitude"] as! Double
//        mapString = dictionary["mapString"] as! String!
//        mediaURL = dictionary["mediaURL"] as! String!
//        objectID = dictionary["objectId"] as! String!
//        uniqueKey = dictionary["uniqueKey"] as! String!
//        updatedAt = dictionary["updatedAt"] as! Date!
//    }
//    
//}
////struct StudentLocation: Codable {
////    //MARK: Properties
////
////    private let objectID: String
////    private let uniqueKey: String
////    private let firstName: String
////    private let lastName: String
////    private let mediaURL: String
////    private let latitude: Float
////    private let longitude: Float
////    private let createdAt: Date
////    private let updatedAt: Date
////    //private let ACL: String
////
////    enum CodingKeys : String, CodingKey {
////        case objectID
////        case uniqueKey
////        case firstName
////        case lastName
////        case mediaURL
////        case latitude
////        case longitude
////        case createdAt
////        case updatedAt
////    }
////
////}
//
