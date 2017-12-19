//
//  UdacityAPIConvenience.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/19/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

extension UdacityAPIClient {
    
    //value of requestToken is used/trickles down to be value of first parameter of loginWithToken, same for hostVC
    func authenticateUser( email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
        print("from auth User email is:\(email)")
        print("from auth User password is:\(password)")
        
        getSessionID(userName: email, userPassword: password) { (success, sessionID, errorString) in
            //getSessionID(userName: self.userNameVar, userPassword: self.userPasswordVar) { (success, sessionID, errorString) in
            //             print("from getSessionID email is:\(userName)")
            //             print("from getSessionID email is:\(password)")
            
            if success == true {
                
                // success! we have the sessionID!
                self.sessionID = sessionID! // takes returned value from compHandler and makes shared var = it
                
                self.getUniqueIDUdacity(userName: email, userPassword: password) { (success, uniqueID, errorString) in
                    //self.getUniqueIDUdacity(userName: self.userNameVar, userPassword: self.userPasswordVar) { (success, uniqueID, errorString) in
                    
                    if success == true {
                        
                        if let uniqueID = uniqueID {
                            
                            // and the userID 😄!
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
        //let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        let parameters = [String:AnyObject]()
        
        //let jsonBody = "{\"udacity\": {\"username\": \"smgoldsborough@gmail.com\", \"password\": \"We051423!!!\"}}"//.data(using: .utf8)
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(userPassword!)\"}}" //.data(using: .utf8)// as! String
        
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in
            print(jsonBody)
            print("The getSessionID JSON Data is: \(results)")
            print("we got this far")
            /* GUARD: Is the "request_token" key in parsedResult? */
            //                guard let account = results![APIClient.JSONResponseKeys.Account] as? String else {
            //                    print("Cannot find key '\(APIClient.JSONResponseKeys.Account)' in \(results!)")
            //                    return
            //                }
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
                //if let sessionID = results?[APIClient.JSONResponseKeys.Account] as? String {
                completionHandlerForSession(true, sessionID, nil)
            } else {
                print("Could not find \(APIClient.JSONResponseKeys.SessionIDUdacity) in \(results)")
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            }
            
            
            /* 3. Send the desired value(s) to completion handler */
            //            if let results = results {
            //                guard let session = results["session"] as? [String: Any] else {print("error: no account");return}
            //                print("the session results are: \(session)")
            //                guard let sessionID = session["id"] as? String else {print("error");return}
            //                print("the sessionID is: \(sessionID)")
            //                if let sessionID = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String {
            //                    //if let sessionID = results?[APIClient.JSONResponseKeys.Account] as? String {
            //                    completionHandlerForSession(true, sessionID, nil)
            //                } else {
            //                    print("Could not find \(APIClient.JSONResponseKeys.SessionIDUdacity) in \(results!)")
            //                    completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            //                }
            
            //            } else {
            //                print("the error on get session id is: \(error)")
            //                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            //
            //            }
            
            //            /* 3. Send the desired value(s) to completion handler */
            //            if let error = error {
            //                print("the error on get session id is: \(error)")
            //                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            //            } else {
            //                guard let session = results!["session"] as? [String: Any] else {print("error: no account");return}
            //                print("the session results are: \(session)")
            //                guard let sessionID = session["id"] as? String else {print("error");return}
            //                print("the sessionID is: \(sessionID)")
            //                if let sessionID = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String {
            //                    //if let sessionID = results?[APIClient.JSONResponseKeys.Account] as? String {
            //                    completionHandlerForSession(true, sessionID, nil)
            //                } else {
            //                    print("Could not find \(APIClient.JSONResponseKeys.SessionIDUdacity) in \(results!)")
            //                    completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            //                }
            //            }
        }
        
        //print("the new post request is \(request)")
    }
    
    // MARK: Get UniqueID - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    private func getUniqueIDUdacity(userName: String?, userPassword: String?, completionHandlerForUniqueID: @escaping (_ success: Bool, _ uniqueID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        let parameters = [String:AnyObject]()
        // TODO: Make the userNameVar and userPasswordVar take input from UITextFields
        let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(userPassword!)\"}}"//.data(using: .utf8)// as! String
        //let jsonBody = "{\"udacity\": {\"username\": \"smgoldsborough@gmail.com\", \"password\": \"We051423!!!\"}}" //.data(using: .utf8)
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in
            
            //print("The getUniqueID JSON Data is: \(results!)")
            
            /* GUARD: Is the "request_token" key in parsedResult? */
            //                guard let account = results![APIClient.JSONResponseKeys.Account] as? String else {
            //                    print("Cannot find key '\(APIClient.JSONResponseKeys.Account)' in \(results!)")
            //                    return
            //                }
            
            //MARK: 12/15 - COMMENTED OUT - POSSIBLY UNNEEDED?
            //            guard let account = results!["account"] as? [String: Any] else {print("error: no account");return}
            //            print("the results are: \(account)")
            //            guard let uniqueKey = account["key"] as? String else {print("error");return}
            //            print("the uniqueKey is: \(uniqueKey)")
            
            
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
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: DELETE Convenience Methods - Udacity
    //    private func deleteSessionUdacity(userNameVar: String?, userPasswordVar: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
    //
    //        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
    //        let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
    //        //let parameters = [String:AnyObject]()
    //
    //        let jsonBody = "{\"udacity\": {\"username\": \"\(userNameVar)\", \"password\": \"\(userPasswordVar)\"}}".data(using: .utf8) as? String
    //
    //        /* 2. Make the request */
    //        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody!) { (results, error) in
    //            print("The getSessionID JSON Data is: \(results)")
    //            /* 3. Send the desired value(s) to completion handler */
    //            if let error = error {
    //                print(error)
    //                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
    //            } else {
    //                if let sessionID = results?[APIClient.JSONResponseKeys.SessionID] as? String {
    //                    completionHandlerForSession(true, sessionID, nil)
    //                } else {
    //                    print("Could not find \(APIClient.JSONResponseKeys.SessionID) in \(results!)")
    //                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
    //                }
    //            }
    //        }
    //    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: GET Convenience Methods - UDACITY
    //
    // MARK: GETing Public User Data - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func getPublicUserDataUdacity(_ completionHandlerForUdacityGet: @escaping (_ result: UdacityPersonalData?, _ error: NSError?) -> Void) {
        
        //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        //let parameters = [APIClient.URLQueryKeys.SessionID: APIClient.sharedInstance().sessionID!] as? [String: AnyObject]
        let parameters = [String:AnyObject]()
        //let variant = ""
        
        //var parametersWithApiKey = parameters
        let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
        //var variant: String = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
        //variant = substituteKeyInMethod(variant, key: APIClient.URLKeys.UdacityUniqueID, value: APIClient.sharedInstance().uniqueID!)!
        //1b. Substitute in a value for the URLKey "id" in /account/{id}/favorite
        //                    variant = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
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
                    
                    //    public var createdAt : String?
                    //    public var firstName : String?
                    //    public var lastName : String?
                    //    public var latitude : Double?
                    //    public var longitude : Double?
                    //    public var mapString : String?
                    //    public var mediaURL : String?
                    //    public var objectId : String?
                    //    public var uniqueKey : Int?
                    //    public var updatedAt : String?
                    
                    // TODO: THIS NEEDS TO COME FROM PARSE GET ONE STUDENT
                    
                    //                    guard let createdAtResults = getResults["createdAt"] as? Date else {
                    //                        print("Cannot find createdAt in \(getResults)")
                    //                        return
                    //                    }
                    //                    print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(createdAtResults)")
                    //                    UdacityPersonalData.sharedInstance().createdAt = createdAtResults
                    
                    
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
                    
                    
                    // TODO: THIS NEEDS TO COME FROM PARSE GET ONE STUDENT
                    
                    //                    guard let updatedAtResults = getResults["updatedAt"] as? Date else {
                    //                        print("Cannot find createdAt in \(getResults)")
                    //                        return
                    //                    }
                    //                    print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(updatedAtResults)")
                    //                    UdacityPersonalData.sharedInstance().updatedAt = updatedAtResults
                    
                    completionHandlerForUdacityGet(UdacityPersonalData.sharedInstance(), nil)
                } else {
                    completionHandlerForUdacityGet(nil, NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPublicUserDataUdacity"]))
                }
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
}
