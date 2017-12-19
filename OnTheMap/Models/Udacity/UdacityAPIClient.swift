//
//  APIClient.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
// MARK: NEED: UDACITY(XPOST METHOD, XPOST CONVENIENCES, XDELETE METHOD, XDELETE CONVENIENCES, XGET METHOD, XGET CONVENIENCES)
// MARK: NEED: PARSE(XGET METHOD, XGET CONVENIENCES, POST METHOD, POST CONVENIENCES, PUT METHOD, PUT CONVENIENCES)

import Foundation

class UdacityAPIClient : NSObject {
    
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
        
        components.percentEncodedQuery = components.percentEncodedQuery?
            .replacingOccurrences(of: ":", with: "%3A")
        
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

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    // MARK: POST Method - Udacity
   
    
    func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters

        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)

        print("The POST Udacity request.httpBody is: ")
        print(String(data: request.httpBody!, encoding: .utf8)!)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: String) {
                print(error)
                
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethodUdacity", code: 1, userInfo: userInfo))
            }

            guard data != nil else {
                sendError("1There was an error with your request - UdacityPOST: \(error!)")
               
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                sendError("ERROR ON RANGE/DATA!")
                return
            }
          
            let newData = data?.subdata(in: range)
            
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("2There was an error with your request: \(error!)")
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
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
            
            /* GUARD: Was there an error? */
            guard data != nil else {
                print("1There was an error with your request - UdacityDELETE: \(error!)")
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                print("ERROR ON RANGE/DATA!")
                return
            }
            //let range = Range(5..<data!.count)
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
        
        print("The Udacity GET parameter keys are: \(APIClient.sharedInstance().uniqueID!)")
        print("The Udacity GET variant is: \(variant)")
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
       
        print("The Udacity GET URL Request is: \(request)")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            /* GUARD: Was there an error? */
            guard data != nil else {
                print("1There was an error with your request - UdacityGET: \(error!)")
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                print("ERROR ON RANGE/DATA!")
                return
            }
            //let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            
            
            var encodedData = String(data: newData!, encoding: .utf8)!
            print("endcoded data is: \(encodedData) and encoding the udacity get JSON data here:")
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
}



