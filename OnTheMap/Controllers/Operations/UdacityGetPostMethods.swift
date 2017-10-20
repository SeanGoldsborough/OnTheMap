//
//  UdacityGetPostMethods.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/20/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
import UIKit

class UdacityMethods: NSObject {
    
    var session = URLSession.shared
    var accountKey: String? = ""
    var sessionID: String? = ""
    
    
    
    func postSession(email: String, password: String) -> Void {
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR!")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            parseJSON(newData!)
            //TODO: Parse JSON Further to return a Boolean value on account/registered to allow further login access
        }
        task.resume()
        
    }
    
    //TODO: Replace the User Number with a Variable?
    func getUserData() {
        let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR!\(error)")
                return
            }
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
   
    }
    
    func deleteSession() {
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR!\(error)")
                return
            }
        
            
        let range = Range(5..<data!.count)
        let newData = data?.subdata(in: range) /* subset response data! */
        print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }

}


func parseJSON(_ data: Data) -> Void {
    
    var parsedResult: AnyObject!
    do {
        parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
    } catch {
        print(error)
        let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
        
    }
    
}

//      WORK THESE GUARD STATEMENTS INTO YOUR FUNCTIONS TO CHECK FOR ERRORS!!!
//    /* GUARD: Did we get a successful 2XX response? */
//    guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//    if let response = response as? HTTPURLResponse {
//    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Status code: \(response.statusCode)!"]
//    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 0, userInfo: userInfo))
//    } else if let response = response {
//    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response! Response: \(response)!"]
//    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 1, userInfo: userInfo))
//    } else {
//    let userInfo = [NSLocalizedDescriptionKey: "Your request returned an invalid response!"]
//    completionHandlerForPostSession(nil, NSError(domain: "taskForPostSession", code: 2, userInfo: userInfo))
//    }
//    return
//    }
//
//    /* GUARD: Was there any data returned? */
//    guard let data = data else {
//    let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
//    completionHandlerForPostSession(nil, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
//    return
//    }



