//
//  ParseAPIConvenience.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/19/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//
import Foundation
extension APIClient {
        
    // MARK: GET Convenience Methods - PARSE
    
    func getStudentLocationsParse(_ completionHandlerForParseGet: @escaping (_ result: [StudentLocations]?, _ error: String?) -> Void) {
            
            //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
          
            let parameters = [APIClient.URLQueryKeys.Limit: "100", APIClient.URLQueryKeys.Order: "-updatedAt"] as? [String: AnyObject]
            var variant: String = URLPathVariants.StudentLocationPath
            
            /* 2. Make the request */
            
            let request = taskForGETMethodParse(variant: variant, parameters: parameters!) { (results, error) in
                print("Parse get Students Locations error is: \(error)")
                /* 3. Send the desired value(s) to completion handler */
                if error != nil {
                    
                     print("Parse error string any object is: \(error?.localizedDescription)")
                    
                    completionHandlerForParseGet([], error?.localizedDescription)
                } else {

                    
                    if let results = results?[APIClient.JSONResponseKeys.ParseResults] as? [[String:AnyObject]] {
                        print("Parse error on get all students is: \(results)")
                        let students = StudentLocations.studentsFromResults(results)
                        print("Parse students is: \(students)")
                        completionHandlerForParseGet(students, nil)

                    } else if let results = results?["error"] as? String {
                        print("2Parse error on get all students is: \(results)")
                        completionHandlerForParseGet(nil, results)
                }else {
                        completionHandlerForParseGet([], error?.localizedDescription)
                    }
                }
            }
        }
        
    // MARK: GETing One Student Location - PARSE
    func getOneStudentLocationParse(_ completionHandlerForParseGet: @escaping (_ result: AnyObject?, _ error: String?) -> Void) {
        
            //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
            let variant: String = URLPathVariants.StudentLocationPath
            
            var queryVariation = "{\"\(APIClient.URLQueryKeys.UniqueKey)\":\"\(UdacityPersonalData.sharedInstance().uniqueKey!)\"}"
           
            
            var parameters = [APIClient.URLQueryKeys.Where: queryVariation] as? [String: AnyObject]
            
            /* 2. Make the request */
            let request = taskForGETMethodParse(variant: variant, parameters: parameters!) { (results, error) in
                print(" get one JSON data returned was \(results)")
                /* 3. Send the desired value(s) to completion handler */
                if error != nil {
                    completionHandlerForParseGet(nil, error?.localizedDescription)
                } else {
                    
                    if let parseError = results!["error"] as? String {
                        print("Parse error GET one student is: \(parseError)")
                        completionHandlerForParseGet(results, parseError)
                    } else {
                        print("No Parse error!")
                    }
                    
                    guard let getResults = results!["results"] as? [[String:AnyObject]] else {
                        return
                    }
                    for result in getResults {
                        let objectID = result["objectId"] as? String
                        UdacityPersonalData.sharedInstance().objectId = objectID
                    }
                }
            }
        }
    
    
    // MARK: POST Convenience Methods - PARSE
    //
    // MARK: POSTing One Student Location - PARSE

    func postUserPARSE(mapString: String?, studentURL: String?, completionHandlerForPOSTUser: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
            
            /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
            let parameters = [String: AnyObject]()

            let jsonBody = "{\"uniqueKey\": \"\(UdacityPersonalData.sharedInstance().uniqueKey!)\", \"firstName\": \"\(UdacityPersonalData.sharedInstance().firstName!)\", \"lastName\": \"\(UdacityPersonalData.sharedInstance().lastName!)\",\"mapString\": \"\(UdacityPersonalData.sharedInstance().mapString!)\", \"mediaURL\": \"\(UdacityPersonalData.sharedInstance().mediaURL!)\",\"latitude\": \(UdacityPersonalData.sharedInstance().latitude!), \"longitude\": \(UdacityPersonalData.sharedInstance().longitude!)}"
            
            
            /* 2. Make the request */
            let _  = taskForPOSTMethodParse(URLPathVariants.StudentLocationPath, parameters: parameters, jsonBody: jsonBody) { (results, error) in
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    print(error)
                    completionHandlerForPOSTUser(false, error.localizedDescription)
                } else {
                     print(" post new student JSON data returned was \(results)")
                    if let parseError = results!["error"] as? String {
                        print("Parse error is: \(parseError)")
                        print("Parse error!")
                        completionHandlerForPOSTUser(false, parseError)
                    } else {
                        print("No Parse error!")
                        if let objectID = results?[APIClient.JSONResponseKeys.ObjectId] as? String {
                            UdacityPersonalData.sharedInstance().objectId = objectID
                            completionHandlerForPOSTUser(true, nil)
                        } else {
                            completionHandlerForPOSTUser(false, error?.localizedDescription)
                        }
                    }
                }
            }
        }
    
        
    // MARK: PUT Convenience Methods - PARSE

    func putUserPARSE(mapString: String?, studentURL: String?, completionHandlerForPUTUser: @escaping (_ success: Bool, _ errorString: String?) -> Void) {

            let jsonBody = "{\"uniqueKey\": \"\(UdacityPersonalData.sharedInstance().uniqueKey!)\", \"firstName\": \"\(UdacityPersonalData.sharedInstance().firstName!)\", \"lastName\": \"\(UdacityPersonalData.sharedInstance().lastName!)\",\"mapString\": \"\(UdacityPersonalData.sharedInstance().mapString!)\", \"mediaURL\": \"\(UdacityPersonalData.sharedInstance().mediaURL!)\",\"latitude\": \(UdacityPersonalData.sharedInstance().latitude!), \"longitude\": \(UdacityPersonalData.sharedInstance().longitude!)}"
            
            /* 2. Make the request */
            let urlString = "/StudentLocation/\(UdacityPersonalData.sharedInstance().objectId!)"
            let request = taskForPUTMethodPARSE(URLPathVariants.StudentLocationPath + "/" + UdacityPersonalData.sharedInstance().objectId!, parameters: [String : AnyObject](), jsonBody: jsonBody) { (results, error) in
                /* 3. Send the desired value(s) to completion handler */
                if let error = error {
                    completionHandlerForPUTUser(false, error.localizedDescription)
                } else {
                    
                    if let parseError = results!["error"] as? String {
                        print("Parse error is: \(parseError)")
                        print("Parse error!")
                        completionHandlerForPUTUser(false, parseError)
                    } else {
                        print("No Parse error!")
                        if let objectID = UdacityPersonalData.sharedInstance().objectId {
                            completionHandlerForPUTUser(true, nil)
                        } else {
                            completionHandlerForPUTUser(false, error?.localizedDescription)
                        }
                    }
                    completionHandlerForPUTUser(true, nil)
                }
            }
        }
}
