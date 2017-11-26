//
//  UdacityPersonalData.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/25/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
// MARK: Swift 4
struct UdacityPersonalData : Decodable {
    
    
    public var firstName : String?
    public var lastName : String?
    public var latitude : Double?
    public var longitude : Double?
    public var mapString : String?
    public var mediaURL : String?
    public var uniqueKey : Int?
    
    
    init?(dictionary: [String:AnyObject]) {
        // How do you get data from json decoding into json response keys?
        //title = dictionary[TMDBClient.JSONResponseKeys.MovieTitle] as! String
        
        
        firstName = dictionary["firstName"] as? String ?? "[No First Name]"
        lastName = dictionary["lastName"] as? String ?? "[No Last Name]"
        latitude = dictionary["latitude"] as? Double ?? 0.00
        longitude = dictionary["longitude"] as? Double ?? 0.00
        mapString = dictionary["mapString"] as? String ?? "No Map String"
        mediaURL = dictionary["mediaURL"] as? String ?? "[No URL]"
        uniqueKey = dictionary["uniqueKey"] as? Int ?? 0
        
    }
    
    static func personalDataFromResults(_ results: [[String:AnyObject]]) -> [UdacityPersonalData] {
        
        var personalData = [UdacityPersonalData]()
        
        // iterate through array of dictionaries, each Movie is a dictionary
        for result in results {
            personalData.append(UdacityPersonalData(dictionary: result)!)
        }
        
        print(personalData)
        return personalData
    }
}

