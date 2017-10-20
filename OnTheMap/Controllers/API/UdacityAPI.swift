//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/17/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//
//DOES KEYS VALUES AND BUILDS URL
import Foundation

// MARK: - UdacityAPI

struct UdacityAPI {
    
    // MARK: Constants
    struct Constants {
        static let UdacityBaseURL = "https://www.udacity.com/api/"
        static let SessionURL = "https://www.udacity.com/api/session"
    }
    
    // MARK: HTTPMethods
    struct HTTPMethods {
        static let Session = "session"
        static let users = "users/"
        
    }
    
//    // MARK: Values
//    struct Values {
//        static let searchMethod = "flickr.photos.search"
//        static let apiKey = "API_KEY_HERE"
//        static let responseFormat = "json"
//        static let noJSONCallback = "1" /* 1 means "disable callback" */
//        static let urls = "url_o,url_m"
//        static let safeSearch = "1" /* 1 mean "use safe search" */
//    }
    
     // MARK: JSONKeys
    struct JSONKeys {
        
        static let UdacityDict = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: ResponseKeys
    struct ResponseKeys {
        static let Session = "session"
        static let SessionID = "id"
        static let Account = "account"
        static let AccountKey = "key"
    }
    
    // MARK: URL Builder
    
//    func urlWithQueryItems(_ items: [String:Any]) -> URL? {
//        var components = URLComponents()
//        //components.UdacityBaseURL = UdacityAPI.Constants.UdacityBaseURL
////        components.host = UdacityAPI.host
////        components.path = UdacityAPI.path
//        components.queryItems = [URLQueryItem]()
//        
//        for (key, value) in items {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            components.queryItems?.append(queryItem)
//        }
//        
//        return components.url
//    }
}

