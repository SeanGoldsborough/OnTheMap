////
////  UdacityAuthConveniences.swift
////  OnTheMap
////
////  Created by Sean Goldsborough on 11/7/17.
////  Copyright © 2017 Sean Goldsborough. All rights reserved.
////
//
//import Foundation
//extension UdacityClient {
//    // MARK: Authentication (GET) Methods
//    /*
//     Steps for Authentication...
//     https://www.themoviedb.org/documentation/api/sessions
//     
//     Step 1: Create a new request token
//     Step 2a: Ask the user for permission via the website
//     Step 3: Create a session ID
//     Bonus Step: Go ahead and get the user id 😄!
//     */
//    func authenticateWithViewController(_ hostViewController: UIViewController, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
//        
//        // chain completion handlers for each request so that they run one after the other
//        getRequestToken() { (success, requestToken, errorString) in
//            
//            if success {
//                
//                // success! we have the requestToken!
//                self.requestToken = requestToken
//                
//                self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
//                    
//                    if success {
//                        self.getSessionID(requestToken) { (success, sessionID, errorString) in
//                            
//                            if success {
//                                
//                                // success! we have the sessionID!
//                                self.sessionID = sessionID
//                                
//                                self.getUserID() { (success, userID, errorString) in
//                                    
//                                    if success {
//                                        
//                                        if let userID = userID {
//                                            
//                                            // and the userID 😄!
//                                            self.userID = userID
//                                        }
//                                    }
//                                    
//                                    completionHandlerForAuth(success, errorString)
//                                }
//                            } else {
//                                completionHandlerForAuth(success, errorString)
//                            }
//                        }
//                    } else {
//                        completionHandlerForAuth(success, errorString)
//                    }
//                }
//            } else {
//                completionHandlerForAuth(success, errorString)
//            }
//        }
//    }
//    
//    private func getRequestToken(_ completionHandlerForToken: @escaping (_ success: Bool, _ requestToken: String?, _ errorString: String?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [String:AnyObject]()
//        
//        /* 2. Make the request */
//        let _ = taskForGETMethod(Methods.AuthenticationTokenNew, parameters: parameters) { (results, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandlerForToken(false, nil, "Login Failed (Request Token).")
//            } else {
//                if let requestToken = results?[TMDBClient.JSONResponseKeys.RequestToken] as? String {
//                    completionHandlerForToken(true, requestToken, nil)
//                } else {
//                    print("Could not find \(TMDBClient.JSONResponseKeys.RequestToken) in \(results!)")
//                    completionHandlerForToken(false, nil, "Login Failed (Request Token).")
//                }
//            }
//        }
//    }
//    
//    /* This function opens a TMDBAuthViewController to handle Step 2a of the auth flow */
//    private func loginWithToken(_ requestToken: String?, hostViewController: UIViewController, completionHandlerForLogin: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
//        
//        let authorizationURL = URL(string: "\(TMDBClient.Constants.AuthorizationURL)\(requestToken!)")
//        let request = URLRequest(url: authorizationURL!)
//        let webAuthViewController = hostViewController.storyboard!.instantiateViewController(withIdentifier: "TMDBAuthViewController") as! TMDBAuthViewController
//        webAuthViewController.urlRequest = request
//        webAuthViewController.requestToken = requestToken
//        webAuthViewController.completionHandlerForView = completionHandlerForLogin
//        
//        let webAuthNavigationController = UINavigationController()
//        webAuthNavigationController.pushViewController(webAuthViewController, animated: false)
//        
//        performUIUpdatesOnMain {
//            hostViewController.present(webAuthNavigationController, animated: true, completion: nil)
//        }
//    }
//    
//    private func getSessionID(_ requestToken: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
//        
//        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
//        let parameters = [TMDBClient.ParameterKeys.RequestToken: requestToken!]
//        
//        /* 2. Make the request */
//        let _ = taskForGETMethod(Methods.AuthenticationSessionNew, parameters: parameters as [String:AnyObject]) { (results, error) in
//            
//            /* 3. Send the desired value(s) to completion handler */
//            if let error = error {
//                print(error)
//                completionHandlerForSession(false, nil, "Login Failed (Session ID).")
//            } else {
//                if let sessionID = results?[TMDBClient.JSONResponseKeys.SessionID] as? String {
//                    completionHandlerForSession(true, sessionID, nil)
//                } else {
//                    print("Could not find \(TMDBClient.JSONResponseKeys.SessionID) in \(results!)")
//                    completionHandlerForSession(false, nil, "Login Failed (Session ID).")
//                }
//            }
//        }
//    }
//}

