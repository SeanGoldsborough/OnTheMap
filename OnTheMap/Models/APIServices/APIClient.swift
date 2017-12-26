//
//  APIClient.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.

import Foundation

class APIClient : NSObject {
    
    // MARK: Properties
        
    // shared session
    var session = URLSession.shared

    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var uniqueID: String? = nil
    
    var firstName: String? = nil
    var lastName: String? = nil
    
    var latitude: String? = nil
    var longitude: String? = nil


    
    // MARK: Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
    //private
    func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
        var parsedResult: AnyObject! = nil
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject    
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
        
    }
        
    // MARK: Shared Instance
    
    class func sharedInstance() -> APIClient {
        struct Singleton {
            static var sharedInstance = APIClient()
        }
        return Singleton.sharedInstance
    }
    

}


