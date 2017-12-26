//
//  UdacityAPIConvenience.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/19/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
extension APIClient {

    func authenticateUser( email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
       
        getSessionID(userName: email, userPassword: password) { (success, sessionID, errorString) in
            
            if success == true {
                
                self.sessionID = sessionID! // takes returned value from compHandler and makes shared var = it
                
                self.getUniqueIDUdacity(userName: email, userPassword: password) { (success, uniqueID, errorString) in
                   
                    if success == true {
                        
                        if let uniqueID = uniqueID {
                            
                            self.uniqueID = uniqueID  // takes returned value from compHandler and makes shared var = it
                        }
                        completionHandlerForAuth(success, errorString) // completion handler for getUserID
                    } else {
                        completionHandlerForAuth(success, errorString) // completion handler for SessionID
                    }
                }
                
            } else {
                completionHandlerForAuth(success, errorString)
            }
        }
        
    }   //closes authUser Func
    
    
    // MARK: POST Convenience Methods - Udacity
    private func getSessionID(userName: String?, userPassword: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */

        let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(userPassword!)\"}}" //.data(using: .utf8)// as! String
        /* 2. Make the request */

        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in

            guard let results = results as? AnyObject else {
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }

            guard let session = results["session"] as? [String: Any] else {
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }
           
            guard let sessionID = session["id"] as? String else {
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }
            
            if let sessionID = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String {
                
                completionHandlerForSession(true, sessionID, nil)
            } else {
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            }
        }
    }
    
    // MARK: Get UniqueID - Udacity

    private func getUniqueIDUdacity(userName: String?, userPassword: String?, completionHandlerForUniqueID: @escaping (_ success: Bool, _ uniqueID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(userPassword!)\"}}"
        
        /* 2. Make the request */
       
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in

            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForUniqueID(false, nil, NSError(domain: "getUniqueIDUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (UniqueID)."]))
            } else {
                guard let account = results![APIClient.JSONResponseKeys.Account] as? [String: Any] else {print("error: no account");return}
                guard let uniqueKey = account[APIClient.JSONResponseKeys.UniqueKeyUdacity] as? String else {print("error");return}
                if let uniqueKey = account[APIClient.JSONResponseKeys.UniqueKeyUdacity] as? String {
                    UdacityPersonalData.sharedInstance().uniqueKey = uniqueKey
                    completionHandlerForUniqueID(true, uniqueKey, nil)
                } else {
                    completionHandlerForUniqueID(false, nil, NSError(domain: "getUniqueIDUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (UniqueID)."]))
                }
            }
        }
    }

    
    //MARK: DELETE Convenience Methods - Udacity  var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
    func deleteSessionUdacity(sessionID: String?, completionHandlerForDeleteSession: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
        
        let parameters = [String:AnyObject]()
        
        let jsonBody = ""
        
        /* 2. Make the request */
        let request = taskForDELETEMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters, jsonBody: jsonBody) { (results, error) in            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForDeleteSession(false, error)
            } else {
                guard let session = results![APIClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    return
                }
                guard let sessionIdResults = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String else {
                    return
                }
                APIClient.sharedInstance().sessionID = sessionIdResults
                completionHandlerForDeleteSession(true, nil)
            }
        }
    }
    
    // MARK: GET Convenience Methods - UDACITY
    //
    // MARK: GETing Public User Data - Udacity

   func getPublicUserDataUdacity(_ completionHandlerForUdacityGet: @escaping (_ result: UdacityPersonalData?, _ error: NSError?) -> Void) {
        
        //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [String:AnyObject]()

        let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
       
        /* 2. Make the request */
        
        let _ = taskForGETMethodUdacity(variant: variant, parameters: parameters) { (results, error) in
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUdacityGet(nil, error)
            } else {
                
                if let result = results {
                    
                    guard let getResults = results![APIClient.JSONResponseKeys.UdacityPersonalDataUser] as? [String:AnyObject] else {
                        return
                    }
                    guard let firstNameResults = getResults["nickname"] as? String else {
                        return
                    }
                    UdacityPersonalData.sharedInstance().firstName = firstNameResults
                    
                    guard let lastNameResults = getResults["last_name"] as? String else {
                        return
                    }
                    UdacityPersonalData.sharedInstance().lastName = lastNameResults
                    
                    
                    guard let keyResults = getResults["key"] as? String else {
                        return
                    }
                    UdacityPersonalData.sharedInstance().uniqueKey = keyResults
                    completionHandlerForUdacityGet(UdacityPersonalData.sharedInstance(), nil)
                } else {
                    completionHandlerForUdacityGet(nil, NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPublicUserDataUdacity"]))
                }
            }
        }
    }
}
