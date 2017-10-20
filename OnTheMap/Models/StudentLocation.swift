//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/20/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

struct StudentLocation: Codable {
    //MARK: Properties
    
    private let objectID: String
    private let uniqueKey: String
    private let firstName: String
    private let lastName: String
    private let mediaURL: String
    private let latitude: Float
    private let longitude: Float
    private let createdAt: Date
    private let updatedAt: Date
    //private let ACL: String
    
    enum CodingKeys : String, CodingKey {
        case objectID
        case uniqueKey
        case firstName
        case lastName
        case mediaURL
        case latitude
        case longitude
        case createdAt
        case updatedAt
    }
    
}
