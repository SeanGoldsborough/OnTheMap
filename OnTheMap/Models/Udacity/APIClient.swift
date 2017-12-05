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
    
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func authenticateUser(completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
//    func authenticateWithViewController(email: String, password: String, completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: NSError?) -> Void) {
//        self.userNameVar = email
//        self.userPasswordVar = password
//        print(email)
//        print(password)
    
        // chain completion handlers for each request so that they run one after the other
        //getRequestToken() { (success, requestToken, errorString) in
        getSessionID(userNameVar: userNameVar, userPasswordVar: userPasswordVar ) { (success, sessionID, errorString) in
            
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
                                        //self.personalData = result!
                                        //print("getPublicUserDataUdacity result is: \(self.personalData)")
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
            }
        }
    }
    
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: POST Method - Udacity
    // TODO:  FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    //func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
    
    func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        //parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacityNil as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method))
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        request.httpBody = "{\"udacity\": {\"username\": \"smgoldsborough@gmail.com\", \"password\": \"We051423!!!\"}}".data(using: .utf8)
        print("The request.httpBody is: \(request.httpBody)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            func sendError(_ error: String) {
                print(error)
                AlertView.alertPopUp(view: LoginVC() as LoginVC, alertMessage: "Networking Error")
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
            print("The Udacity POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    // MARK: POST Convenience Methods - Udacity
    private func getSessionID(userNameVar: String?, userPasswordVar: String?, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ errorString: NSError?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [APIClient.UdacityParameterKeys.Udacity] as! [String: AnyObject]
        let parameters = [String:AnyObject]()
        
        let jsonBody = "{\"udacity\": {\"username\": \"\(userNameVar))\", \"password\": \"\(userPasswordVar))\"}}" as! String
        
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject]) { (results, error) in
            print("The getSessionID JSON Data is: \(results!)")
            
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
                completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
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
                    completionHandlerForSession(false, nil, NSError(domain: "getSessionID parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Login Failed (Session ID)."]))
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
        let jsonBody = "{\"udacity\": {\"username\": \"\(userNameVar))\", \"password\": \"\(userPasswordVar))\"}}" as! String
        
        /* 2. Make the request */
        //let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody) { (results, error) in
        let _ = taskForPOSTMethodUdacity(URLPathVariants.UdacitySession, parameters: parameters as [String: AnyObject]) { (results, error) in
            print("The getUniqueID JSON Data is: \(results!)")
            
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
        //let variant = ""
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
            
            
            var encodedData = String(data: newData!, encoding: .utf8)!
            print("pooooooop - endcoded data is: \(encodedData) and encoding the udacity get JSON data here:")
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
                    
                    //                guard let mapStringResults = getResults["location"] as? String else {
                    //                    print("Cannot find mapStringResults '\(APIClient.JSONResponseKeys.UdacityPersonalDataMapString)' in \(getResults)")
                    //                    return
                    //                }
                    //                print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(mapStringResults)")
                    //
                    //                guard let mediaURLResults = getResults["website_url"] as? String else {
                    //                    print("Cannot find mediaURLResults '\(APIClient.JSONResponseKeys.UdacityPersonalDataMediaURL)' in \(getResults)")
                    //                    return
                    //                }
                    //                print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(mediaURLResults)")
                    
                    guard let keyResults = getResults["key"] as? String else {
                        print("Cannot find keyResults '\(APIClient.JSONResponseKeys.UdacityPersonalDataFirstName)' in \(getResults)")
                        return
                    }
                    print("The getPublicUserDataUdacity Guard/Let firstName Results are: \(keyResults)")
                    UdacityPersonalData.sharedInstance().uniqueKey = keyResults
                    
                    print("The UdacityPersonalData shared instance key Results are: \(UdacityPersonalData.sharedInstance().uniqueKey)")
                    
                    //if let personalData = UdacityPersonalData.init(firstName: firstNameResults, lastName: lastNameResults, latitude: 0.0, longitude: 0.0, mapString: "", mediaURL: "", objectId: "", uniqueKey: keyResults) {
                    
                    
                    //                    print("The getPublicUserDataUdacity Results personalData are: \(personalData)")
                    //                    self.udacityDataArray = [personalData]
                    //                    completionHandlerForUdacityGet(personalData, nil)
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
        let jsonBody = "{\"udacity\": {\"username\": \"\(mapString)\", \"password\": \"\(studentURL)\"}}".data(using: .utf8) as? String
        
        /* 2. Make the request */
        let _ = taskForPOSTMethodParse(URLPathVariants.UdacitySession, parameters: parameters as [String:AnyObject], jsonBody: jsonBody!) { (results, error) in
            print("The getSessionID JSON Data is: \(results)")
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                print(error)
                completionHandlerForPOSTUser(false, nil, "Login Failed (Session ID).")
            } else {
                if let sessionID = results?[APIClient.JSONResponseKeys.SessionID] as? String {
                    completionHandlerForPOSTUser(true, sessionID, nil)
                } else {
                    print("Could not find \(APIClient.JSONResponseKeys.SessionID) in \(results!)")
                    completionHandlerForPOSTUser(false, nil, "Login Failed (Session ID).")
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


