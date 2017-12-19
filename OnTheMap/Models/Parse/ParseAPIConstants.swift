//
//  APIConstants.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Keys

        static let APIKeyUdacity = "cec14169bb6921f04d7278bbc2277288"
        static let APIKeyUdacityNil = ""
        static let APIKeyParse = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDParse = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        
        static let APISchemeParse = "https"
        static let APIHostParse = "parse.udacity.com"
        static let APIPathParse = "/parse/classes"
        static let baseURLParse = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        static let APISchemeUdacity = "https"
        static let APIHostUdacity = "www.udacity.com"
        static let APIPathUdacity = "/api"
        static let baseURLUdacity = "https://www.udacity.com/api/session"
        
        
    }
    
    // MARK: URL Path Variants
    struct URLPathVariants {
        
        // MARK: PUT - Parse
        static let StudentLocationPath = "/StudentLocation"
        static let ObjectID = "/<objectId>"
        static let ParseUniqueID = "id"
        
        // MARK: Udacity UsersID
        //static let UdacityUserID = "/users/{user_id}"
        static let UdacityUserID = "/users/"
        
        // MARK: Udacity POST Session
        static let UdacitySession = "/session"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
        // Udacity URL Keys
        static let UdacityUniqueID = "id"
    }
    
    // MARK: URL Query Parameter Keys
    struct URLQueryKeys {
        static let APIKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
        // Parse URL Query Parameter Keys
        static let Where = "where"
        static let Limit = "limit"
        static let Skip = "skip"
        static let Order = "order"
        static let UniqueKey = "uniqueKey"
        
    }
    
    // MARK: Udacity URL Query Parameter Keys
    struct UdacityParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        // TODO: To shush compiler for now...delete this when you build your funcs in APIClient
        static let SessionID = "sessionId"
        
        
        // MARK: Udacity Authorization JSON Response
        static let Account = "account"
        static let Registered = "registered"
        static let UniqueKeyUdacity = "key"
        
        static let Session = "session"
        static let SessionIDUdacity = "id"
        static let Expiration = "expiration"
        
        
        // MARK: Udacity Personal Data JSON Response
        static let UdacityPersonalDataUser = "user"
        static let UdacityPersonalDataID = "key"
        static let UdacityPersonalDataFirstName = "nickname"
        static let UdacityPersonalDataLastName = "lastname"
        static let UdacityPersonalDataMediaURL = "website_url"
        static let UdacityPersonalDataMapString = "location"
        
        
        // MARK: Parse JSON Response
        static let ParseResults = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
    }
    
}

