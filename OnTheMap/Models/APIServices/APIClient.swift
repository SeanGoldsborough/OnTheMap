//
//  APIClient.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
// MARK: NEED: UDACITY(XPOST METHOD, XPOST CONVENIENCES, XDELETE METHOD, XDELETE CONVENIENCES, XGET METHOD, XGET CONVENIENCES)
// MARK: NEED: PARSE(XGET METHOD, XGET CONVENIENCES, POST METHOD, POST CONVENIENCES, PUT METHOD, PUT CONVENIENCES)

import Foundation

class APIClient : NSObject {
    
    // MARK: Properties
    
    // StudentLocation Array
    var studentLocations: [StudentLocations] = [StudentLocations]()
    var udacityDataArray = [UdacityPersonalData]()
    
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

    var userNameVar: String = "smgoldsborough@gmail.com"
    var userPasswordVar: String = "We051423!!!"

    
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
            //parsedResult = try JSONDecoder().decode([StudentLocations].self, from: data) as AnyObject
            
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


