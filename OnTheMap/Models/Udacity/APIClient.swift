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
    var personalData: [UdacityPersonalData] = [UdacityPersonalData]()
    
    // shared session
    var session = URLSession.shared
    
    // configuration object
    //var config = TMDBConfig()
    
    // authentication state
    var requestToken: String? = nil
    var sessionID: String? = nil
    var uniqueID: String? = nil
    
    // Udacity Personal Data
    //    var requestToken: String? = nil
    //    var sessionID: String? = nil
    //    var uniqueID: String? = nil
    // TODO: WRITE THIS STUFF BELOW AS VARS IN THE APPROPRIATE SPACES
//    "{\"uniqueKey\": \"FROM APICLIENT.UNIQUEID\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"FROM CARRIED OVER DATA FROM ADD LOCATION VC\", \"mediaURL\": \"FROM CARRIED OVER DATA FROM ADD LOCATION VC\",\"latitude\"FROM SELF.VARIABLE-FOR-LAT...AFTER THE FUNCTION TO GET COORDINATES FROM MAPSTRING RUNS, \"longitude\"SAME AS BEFORE}
    
    
    //email: emailTextField.text!, password: passwordTextField.text!)
    var userNameVar: String? =  "smgoldsborough@gmail.com"//""//LoginVC().emailTextField.text! //"smgoldsborough@gmail.com"
    var userPasswordVar: String? = "We051423" //"" //LoginVC().passwordTextField.text!//"We051423"
    
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
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
        
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
    
    // create a URL from parameters
    private func ParseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = APIClient.Constants.APISchemeParse
        components.host = APIClient.Constants.APIHostParse
        components.path = APIClient.Constants.APIPathParse + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print(components.url!)
        return components.url!
    }
    
    private func UdacityURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = APIClient.Constants.APISchemeUdacity
        components.host = APIClient.Constants.APIHostUdacity
        components.path = APIClient.Constants.APIPathUdacity + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        print("UdacityURLFromParameters \(components.url!)")
        return components.url!
    }
    
    // MARK: For UniqueKey and ObjectID - substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> APIClient {
        struct Singleton {
            static var sharedInstance = APIClient()
        }
        return Singleton.sharedInstance
    }
    
    // MARK: Authentication (GET) Methods
    /*
     Steps for Authentication...
     https://www.themoviedb.org/documentation/api/sessions
     
     Step 1: Create a new request token
     Step 2a: Ask the user for permission via the website
     Step 3: Create a session ID
     Bonus Step: Go ahead and get the user id 😄!
     */
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS - Optional: _ email: String?, _ password: String?, self.userNameVar,self.userPasswordVar,
    func authenticateWithViewController(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
        self.userNameVar = email
        self.userPasswordVar = password
        print(email)
        print(password)
        
        // chain completion handlers for each request so that they run one after the other
        //getRequestToken() { (success, requestToken, errorString) in userName: self.userNameVar, userPassword: self.userPasswordVar
        getSessionID() { (success, sessionID, errorString) in
//            print(email)
//            print(password)
            if success {
                
                // success! we have the SessionID!
                self.sessionID = sessionID
                
                //self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
                
                //if success {
                //self.getPublicUserDataUdacity() { (result, errorString) in
                //self.getStudentLocationsParse() { (result, errorString) in
                
                if success {
                    //print("getPublicUserDataUdacity result is: \(result)")
                    // success! we have the StudentLocations!
                    //self.studentLocations = result!
                    //print("GetStudentLocationsParse result is: \(self.studentLocations)")
                    
                    self.getUniqueIDUdacity() { (success, uniqueID, errorString) in
                        
                        if success {
                            
                            if let uniqueID = uniqueID {
                                
                                // and the userID 😄!
                                self.uniqueID = uniqueID
                                self.getPublicUserDataUdacity() { (result, errorString) in
                                    if success {
                                        self.personalData = result!
                                        print("getPublicUserDataUdacity result is: \(result!)")
                                        // TODO: parse the PUBLIC USER DATA TO GET ESSENTALS NEEDED FOR CONFIRMVC
//                                        for results in result! {
//                                            let firstName = results["firstName"] as! String
//                                        }
                                        //print(self.personalData.firstName)
                                        //LoginVC().completeLogIn()
                                        //print("getPublicUserDataUdacity result also is: \(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName) + \(APIClient.JSONResponseKeys.UdacityPersonalDataLastName)")
                                        
                                    }   else {
                                        completionHandlerForAuth(success, errorString)
                                    }
                                    
                                    completionHandlerForAuth(success, errorString)
                                }
                            }
                        }
                        
                        completionHandlerForAuth(success, errorString)
                    }
                    //} else {
                    //    completionHandlerForAuth(success, errorString)
                    //}
                }
                //                    } else {
                //                        completionHandlerForAuth(success, errorString)
                //                    }
                
            } else {
                completionHandlerForAuth(success, errorString)
                print("The request.httpBody is: \(completionHandlerForAuth(success, errorString))")
            }
        }
    }
    
//    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
//    func authenticateWithViewController(email: String, password: String, completionHandlerForAuth: @escaping (_ email: String?, _ password: String?, _ success: Bool, _ errorString: NSError?) -> Void) {
//
//        // chain completion handlers for each request so that they run one after the other
//        //getRequestToken() { (success, requestToken, errorString) in
//        getSessionID(userNameVar: email, userPasswordVar: password ) { (success, sessionID, errorString) in
//
//            if success {
//
//                // success! we have the SessionID!
//                self.sessionID = sessionID
//
//                //self.loginWithToken(requestToken, hostViewController: hostViewController) { (success, errorString) in
//
//                //if success {
//                //self.getPublicUserDataUdacity() { (result, errorString) in
//                //self.getStudentLocationsParse() { (result, errorString) in
//
//                if success {
//                    //print("getPublicUserDataUdacity result is: \(result)")
//                    // success! we have the StudentLocations!
//                    //self.studentLocations = result!
//                    //print("GetStudentLocationsParse result is: \(self.studentLocations)")
//
//                    self.getUniqueIDUdacity() { (success, uniqueID, errorString) in
//
//                        if success {
//
//                            if let uniqueID = uniqueID {
//
//                                // and the userID 😄!
//                                self.uniqueID = uniqueID
//                                self.getPublicUserDataUdacity() { (result, errorString) in
//                                    if success {
//                                        self.personalData = result!
//                                        print("getPublicUserDataUdacity result is: \(self.personalData)")
//                                        //LoginVC().completeLogIn()
//                                        //print("getPublicUserDataUdacity result also is: \(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName) + \(APIClient.JSONResponseKeys.UdacityPersonalDataLastName)")
//
//                                    }   else {
//                                        completionHandlerForAuth(self.userNameVar,self.userPasswordVar, success, errorString)
//                                    }
//
//                                    completionHandlerForAuth(self.userNameVar,self.userPasswordVar, success, errorString)
//                                }
//                            }
//                        }
//
//                        completionHandlerForAuth(self.userNameVar, self.userPasswordVar, success, errorString)
//                    }
//                    //} else {
//                    //    completionHandlerForAuth(success, errorString)
//                    //}
//                }
//                //                    } else {
//                //                        completionHandlerForAuth(success, errorString)
//                //                    }
//
//            } else {
//                completionHandlerForAuth(self.userNameVar, self.userPasswordVar, success, errorString)
//                print("The request.httpBody is: \(completionHandlerForAuth(self.userNameVar, self.userPasswordVar, success, errorString))")
//            }
//        }
//    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: POST Method - Udacity
    // TODO:  FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    //func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        //parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacityNil as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        //request.httpBody = "{\"udacity\": {\"username\": \"\(userNameVar!)\", \"password\": \"\(userPasswordVar!)\"}}".data(using: .utf8)
        print("The request.httpBody is: \(request.httpBody)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethodUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            print("The POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST Convenience Methods - Udacity Optional: userName: String?, userPassword: String?,
    private func getSessionID(completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        let parameters = [String:AnyObject]()
        
        //let jsonBody = "{\"udacity\": {\"username\": \"smgoldsborough@gmail.com\", \"password\": \"We051423\"}}" as! String
        //let jsonBody = "{\"udacity\": {\"username\": \"\(userName!)\", \"password\": \"\(userPassword!)\"}}"
        let jsonBody = "{\"udacity\": {\"username\": \"\(self.userNameVar!)\", \"password\": \"\(self.userPasswordVar!)\"}}"
        print(jsonBody)
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in
            //print("The getSessionID JSON Data is: \(results!)")
            
            /* GUARD: Is the "request_token" key in parsedResult? */
            //                guard let account = results![APIClient.JSONResponseKeys.Account] as? String else {
            //                    print("Cannot find key '\(APIClient.JSONResponseKeys.Account)' in \(results!)")
            //                    return
            //                }
            guard let session = results!["session"] as? [String: Any] else {print("error: no account");return}
            print("the results are: \(session)")
            guard let id = session["id"] as? String else {print("error");return}
            print("the sessionID is: \(id)")
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForSession(false, nil, NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
            } else {
                guard let session = results!["session"] as? [String: Any] else {print("error: no account");return}
                print("the session results are: \(session)")
                guard let sessionID = session["id"] as? String else {print("error");return}
                print("the sessionID is: \(sessionID)")
                if let sessionID = session[APIClient.JSONResponseKeys.SessionIDUdacity] as? String {
                    //if let sessionID = results?[APIClient.JSONResponseKeys.Account] as? String {
                    completionHandlerForSession(true, sessionID, nil)
                } else {
                    print("Could not find \(APIClient.JSONResponseKeys.SessionIDUdacity) in \(results!)")
                    completionHandlerForSession(false, nil, NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
                }
            }
        }
    }
    
    // MARK: Get UniqueID - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    private func getUniqueIDUdacity(completionHandlerForUniqueID: @escaping (_ success: Bool, _ uniqueID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        let parameters = [String:AnyObject]()
        // TODO: Make the userNameVar and userPasswordVar take input from UITextFields
        //let jsonBody = "{\"udacity\": {\"username\": \"smgoldsborough@gmail.com\", \"password\": \"We051423\"}}" as! String
        let jsonBody = "{\"udacity\": {\"username\": \"\(self.userNameVar!)\", \"password\": \"\(self.userPasswordVar!)\"}}"
        
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject], jsonBody: jsonBody) { (results, error) in
            print("The getUniqueID JSON Data is: \(results)")
            
            /* GUARD: Is the "request_token" key in parsedResult? */
            //                guard let account = results![APIClient.JSONResponseKeys.Account] as? String else {
            //                    print("Cannot find key '\(APIClient.JSONResponseKeys.Account)' in \(results!)")
            //                    return
            //                }
            guard let account = results!["account"] as? [String: Any] else {print("error: no account");return}
            print("the results are: \(account)")
            guard let uniqueKey = account["key"] as? String else {print("error");return}
            print("the uniqueKey is: \(uniqueKey)")
            
            
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
                    //if let sessionID = results?[APIClient.JSONResponseKeys.Account] as? String {
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
    
    // MARK: DELETE Method - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForDELETEMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        print("The request.httpBody is: \(request.httpBody)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethodUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
            //             print("The POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
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
    
    // MARK: GET Methods - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForGETMethodUdacity(variant: String, parameters: [String:AnyObject], completionHandlerForUdacityGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
        //var variant: String = URLPathVariants.UdacityUserID //"\(APIClient.sharedInstance().uniqueID!)"////
        //variant = substituteKeyInMethod(variant, key: APIClient.URLKeys.UdacityUniqueID, value: String(APIClient.sharedInstance().uniqueID!))!
        //parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        print("The Udacity GET parameter keys are: \(APIClient.sharedInstance().uniqueID!)")
        print("The Udacity GET variant is: \(variant)")
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: variant))
        //        request.addValue(Constants.ApplicationIDParse, forHTTPHeaderField: "X-Parse-Application-Id")
        //        request.addValue(Constants.APIKeyParse, forHTTPHeaderField: "X-Parse-REST-API-Key")
        print("The Udacity GET URL Request is: \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUdacityGET(nil, NSError(domain: "taskForGETMethodUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Udacity GET: There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Udacity GET: Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                sendError("Udacity GET: No data was returned by the request!")
                return
            }
            
            print("The Udacity GET URL Data Task Response is: \(response)")
            
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForUdacityGET)
            print("Data from Udacity GET data task\(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: GET Convenience Methods - UDACITY
    //
    // MARK: GETing Public User Data - Udacity
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS - still fahktup
    func getPublicUserDataUdacity(_ completionHandlerForUdacityGet: @escaping (_ result: [UdacityPersonalData]?, _ error: NSError?) -> Void) {
        
        //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        //let parameters = [APIClient.URLQueryKeys.SessionID: APIClient.sharedInstance().sessionID!] as? [String: AnyObject]
        let parameters = [String:AnyObject]()
        let variant = ""
        //var variant: String = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
        //variant = substituteKeyInMethod(variant, key: APIClient.URLKeys.UdacityUniqueID, value: APIClient.sharedInstance().uniqueID!)!
        //1b. Substitute in a value for the URLKey "id" in /account/{id}/favorite
        //                    variant = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        
        let _ = taskForGETMethodUdacity(variant: variant, parameters: parameters) { (results, error) in
            print("The getPublicUserDataUdacity JSON Data is: \(results)")
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForUdacityGet([], error)
            } else {
                
                if let results = results?[APIClient.JSONResponseKeys.ParseResults] as? [[String:AnyObject]] {
                    
                    let personalData = UdacityPersonalData.personalDataFromResults(results)
                    completionHandlerForUdacityGet(personalData, nil)
                } else {
                    completionHandlerForUdacityGet([], NSError(domain: "getPublicUserDataUdacity parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getPublicUserDataUdacity"]))
                }
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: GET Methods - Parse
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForGETMethodParse(variant: String, parameters: [String:AnyObject], completionHandlerForParseGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        //parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyParse as AnyObject?
        //print("The GET parameter keys are: \( parametersWithApiKey[URLQueryKeys.APIKey])")
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parametersWithApiKey, withPathExtension: variant))
        request.addValue(Constants.ApplicationIDParse, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKeyParse, forHTTPHeaderField: "X-Parse-REST-API-Key")
        print("The Parse GET URL Request is: \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForParseGET(nil, NSError(domain: "taskForGETMethodParse", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("Parse GET: There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Parse GET: Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("Parse GET: No data was returned by the request!")
                return
            }
            
            print("Parse GET: The URL Data Task Response is: \(response)")
            
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForParseGET)
            print("data from PARSE get data task is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: GET Convenience Methods - PARSE
    //
    // MARK: GETing All Student Locations- PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func getStudentLocationsParse(_ completionHandlerForParseGet: @escaping (_ result: [StudentLocations]?, _ error: NSError?) -> Void) {
        
        //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        let parameters = [String:AnyObject]()
        //let parameters = [APIClient.URLQueryKeys.SessionID: APIClient.sharedInstance().sessionID!] as? [String: AnyObject]
        var variant: String = URLPathVariants.StudentLocationPath
        //1b. Substitute in a value for the URLKey "id" in /account/{id}/favorite
        //                    variant = substituteKeyInMethod(mutableMethod, key: TMDBClient.URLKeys.UserID, value: String(TMDBClient.sharedInstance().userID!))!
        
        /* 2. Make the request */
        
        let _ = taskForGETMethodParse(variant: variant, parameters: parameters) { (results, error) in
            print("The getStudentLocationsParse JSON Data is: \(results!)")
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForParseGet([], error)
            } else {
                
                if let results = results?[APIClient.JSONResponseKeys.ParseResults] as? [[String:AnyObject]] {
                    
                    let students = StudentLocations.studentsFromResults(results)
                    print("Students from getStudentLocationsParse are: \(students)")
                    completionHandlerForParseGet(students, nil)
                } else {
                    completionHandlerForParseGet([], NSError(domain: "getStudentLocationsParse parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudentLocationsParse"]))
                }
            }
        }
    }
    
    // MARK: GETing One Student Location - PARSE - https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func getOneStudentLocationParse(_ completionHandlerForParseGet: @escaping (_ result: [StudentLocations]?, _ error: NSError?) -> Void) {
        
        //1. Specify parameters, method (if has {key}), and HTTP body (if POST)
        var parameters = [APIClient.URLQueryKeys.Where: APIClient.sharedInstance().uniqueID!] as? [String: AnyObject]
        //var parametersWithQueryKeys: [String: AnyObject]
        //var variant: String = URLPathVariants.StudentLocationPath + URLQueryKeys.Where + JSONResponseKeys.UniqueKey
        var variant: String = URLPathVariants.StudentLocationPath
        
        //parametersWithQueryKeys[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        //1b. Substitute in a value for the URLKey "id" in /account/{id}/favorite
        //        var mutableMethod: String = Methods.AccountIDFavoriteMovies
        //        variant = substituteKeyInMethod(mutableMethod, key: APIClient.URLKeys.UniqueID, value: String(APIClient.sharedInstance().uniqueID!))!
        
        /* 2. Make the request */
        
        let _ = taskForGETMethodParse(variant: variant, parameters: parameters!) { (results, error) in
            print("The getOneStudentLocationParse JSON Data is: \(results)")
            
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandlerForParseGet([], error)
            } else {
                
                if let results = results?[APIClient.JSONResponseKeys.ParseResults] as? [[String:AnyObject]] {
                    
                    let students = StudentLocations.studentsFromResults(results)
                    completionHandlerForParseGet(students, nil)
                } else {
                    completionHandlerForParseGet([], NSError(domain: "getOneStudentLocationParse parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getOneStudentLocationParse"]))
                }
            }
        }
    }
    
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: POST Method - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForPOSTMethodParse(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print("The request.httpBody is: \(request.httpBody)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethodParse", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            //             print("The POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST Convenience Methods - PARSE
    //
    // MARK: POSTing One Student Location - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    private func postUserPARSE(mapString: String?, studentURL: String?, completionHandlerForPOSTUser: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        //let parameters = [String:AnyObject]()
        // TODO: When Calling this function the parameters will be UITextField.text for each of the said parameters
        //
        //USE THIS ONE BELOW
        //
        //let jsonBody = "{\"uniqueKey\": \"\(APIClient.JSONResponseKeys.UdacityPersonalDataID)\", \"firstName\": \"\(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName)\", \"lastName\": \"\(APIClient.JSONResponseKeys.UdacityPersonalDataLastName)\",\"mapString\": \"\(FROMUITEXTFIELDFORMAPSTRING)\", \"mediaURL\": \"FROMUITEXTFIELDFORMEDIALURL\",\"latitude\": FROMVarForLat, \"longitude\": FROMVarForLong}".data(using: .utf8)
       
        let jsonBody = "{\"udacity\": {\"username\": \"\(self.userNameVar!)\", \"password\": \"\(self.userPasswordVar!)\"}}"
        
        //request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
        
        /* 2. Make the request */
        let _ = taskForPOSTMethodParse(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
            print("The postUserPARSE JSON Data is: \(results)")
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForPOSTUser(false, nil, "postUserPARSE Failed (postUserPARSE).")
            } else {
                if let sessionID = results?[APIClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForPOSTUser(true, sessionID, nil)
                } else {
                    print("Could not find \(APIClient.JSONResponseKeys.SessionID) in \(results!)")
                    completionHandlerForPOSTUser(false, nil, "postUserPARSE Failed (postUserPARSE).")
                }
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: PUT Method - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForPUTMethodPARSE(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print("The request.httpBody is: \(request.httpBody)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethodPARSE", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
            //             print("The POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: PUT Convenience Methods - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    private func putUserPARSE(userNameVar: String?, userPasswordVar: String?, completionHandlerForPUTUser: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        //let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userNameVar)\", \"password\": \"\(userPasswordVar)\"}}".data(using: .utf8) as? String
        
        /* 2. Make the request */
        let _ = taskForPUTMethodPARSE(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody!) { (results, error) in
            print("The getSessionID JSON Data is: \(results)")
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForPUTUser(false, nil, "Login Failed (Session ID).")
            } else {
                if let sessionID = results?[APIClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForPUTUser(true, sessionID, nil)
                } else {
                    print("Could not find \(APIClient.JSONResponseKeys.SessionID) in \(results!)")
                    completionHandlerForPUTUser(false, nil, "Login Failed (Session ID).")
                }
            }
        }
    }
    
}



