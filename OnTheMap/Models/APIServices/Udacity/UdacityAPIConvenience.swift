//
//  UdacityAPIConvenience.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/19/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
extension APIClient {
//extension UdacityAPIClient {
    
    //value of requestToken is used/trickles down to be value of first parameter of loginWithToken, same for hostVC
    func authenticateUser( email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
        print("from auth User email is:\(email)")
        print("from auth User password is:\(password)")
        
        getSessionID(userName: email, userPassword: password) { (success, sessionID, errorString) in
            
            if success == true {
                
                self.sessionID = sessionID! // takes returned value from compHandler and makes shared var = it
                
                self.getUniqueIDUdacity(userName: email, userPassword: password) { (success, uniqueID, errorString) in
                   
                    if success == true {
                        
                        if let uniqueID = uniqueID {
                            
                            self.uniqueID = uniqueID  // takes returned value from compHandler and makes shared var = it
                            print("uniqueID value is:\(self.uniqueID)")
                        }
                        //} else {
                        
                        completionHandlerForAuth(success, errorString) // completion handler for getUserID
                        print("from success uniqueID is:\(success)")
                        print("from errorString is:\(errorString)")
                        //}
                        //}
                    } else {
                        completionHandlerForAuth(success, errorString) // completion handler for SessionID
                        print("from success uniqueID is:\(success)")
                        print("from errorString is:\(errorString)")
                    }
                }
                
            } else {
                completionHandlerForAuth(success, errorString) // completion handler for SessionID
                print("from success uniqueID is:\(success)")
                print("from errorString is:\(errorString)")
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
            print(jsonBody)
            print("The getSessionID JSON Data is: \(results)")
            print("we got this far")

            guard let results = results as? AnyObject else {
                print("error: no account on session = results?")
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }

            guard let session = results["session"] as? [String: Any] else {
                print("error: no account on session = results?")
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }
            print("the results are: \(session)")
            
            guard let sessionID = session["id"] as? String else {
                print("error: no account on session = results?")
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                return
            }
            print("the sessionID is: \(sessionID)")
            
            if let sessionID = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String {
                
                completionHandlerForSession(true, sessionID, nil)
            } else {
                print("Could not find \(APIClient.JSONResponseKeys.SessionIDUdacity) in \(results)")
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            }
        }
        
        //print("the new post request is \(request)")
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
                print("the results are: \(account)")
                guard let uniqueKey = account[APIClient.JSONResponseKeys.UniqueKeyUdacity] as? String else {print("error");return}
                print("the uniqueKey is: \(uniqueKey)")
                if let uniqueKey = account[APIClient.JSONResponseKeys.UniqueKeyUdacity] as? String {
                    UdacityPersonalData.sharedInstance().uniqueKey = uniqueKey
                    completionHandlerForUniqueID(true, uniqueKey, nil)
                } else {
                    print("Could not find \(APIClient.JSONResponseKeys.Account) in \(results!)")
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
        let request = taskForDELETEMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters, jsonBody: jsonBody) { (results, error) in
            print("The deleteSessionUdacity JSON Data is: \(results)")
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForDeleteSession(false, error)
            } else {
                guard let session = results![APIClient.JSONResponseKeys.Session] as? [String:AnyObject] else {
                    print("Cannot find session '\(APIClient.JSONResponseKeys.Session)' in \(results!)")
                    return
                }
                print("The DELETE session Udacity results are: \(results)")
                
                guard let sessionIdResults = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String else {
                    print("Cannot find sessionIdResults '\(APIClient.JSONResponseKeys.SessionIDUdacity)' in \(session)")
                    return
                }
                print("The DELETE session Udacity sessionIdResults are: \(sessionIdResults)")
                APIClient.sharedInstance().sessionID = sessionIdResults
                completionHandlerForDeleteSession(true, nil)
            }
        }
        print("The deleteSessionUdacity request is: \(request)")
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
            print("The getPublicUserDataUdacity JSON Data is: \(results)")
            
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUdacityGet(nil, error)
                print("The getPublicUserDataUdacity JSON Data ERROR is: \(error)")
            } else {
                
                if let result = results {
                    
                    guard let getResults = results![APIClient.JSONResponseKeys.UdacityPersonalDataUser] as? [String:AnyObject] else {
                        print("Cannot find key '\(APIClient.JSONResponseKeys.UdacityPersonalDataUser)' in \(results!)")
                        return
                    }
                    print("The getPublicUserDataUdacity Guard/Let Get Results are: \(getResults)")

                    guard let firstNameResults = getResults["nickname"] as? String else {
                        print("Cannot find firstName '\(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName)' in \(getResults)")
                        return
                    }
                    print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(firstNameResults)")
                    UdacityPersonalData.sharedInstance().firstName = firstNameResults
                    
                    guard let lastNameResults = getResults["last_name"] as? String else {
                        print("Cannot find lastName '\(APIClient.JSONResponseKeys.UdacityPersonalDataLastName)' in \(getResults)")
                        return
                    }
                    print("The getPublicUserDataUdacity Guard/Let lastName Results are: \(lastNameResults)")
                    UdacityPersonalData.sharedInstance().lastName = lastNameResults
                    
                    
                    guard let keyResults = getResults["key"] as? String else {
                        print("Cannot find keyResults '\(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName)' in \(getResults)")
                        return
                    }
                    print("The getPublicUserDataUdacity Guard/Let uniqueKey Results are: \(keyResults)")
                    UdacityPersonalData.sharedInstance().uniqueKey = keyResults
                    
                    print("The UdacityPersonalData shared instance key Results are: \(UdacityPersonalData.sharedInstance().uniqueKey)")

                    completionHandlerForUdacityGet(UdacityPersonalData.sharedInstance(), nil)
                } else {
                    completionHandlerForUdacityGet(nil, NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPublicUserDataUdacity"]))
                }
            }
        }
    }
}
