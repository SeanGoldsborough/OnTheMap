//
//  APIClient.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.

import Foundation

extension APIClient {
 
    // MARK: Helpers
        
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
        return components.url!
    }
    
    // MARK: POST Method - Udacity

    func taskForPOSTMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOST: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters

        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: method), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            
            
            func sendError(_ error: Error?) {
                print(error)
                
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOST(nil, error)
                //completionHandlerForPOST(nil, NSError(domain: "taskForPOSTMethodUdacity", code: 1, userInfo: userInfo))
            }

            guard (error == nil) else {
                print("8 error is: \(error)")
                //sendError((error?.localizedDescription)!)
                sendError(error)
                
                return
            }

            guard data != nil else {
                print(8)
                 //sendError((error?.localizedDescription)!)
                sendError(error)
               
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                print(9)
                 sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("\(error!) 2ERROR ON RANGE/DATA!")
                return
            }
          
            let newData = data?.subdata(in: range)
            
            print("Udacity Data is: \(String(data: newData!, encoding: .utf8)!)")
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                print(10)
                 sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("\(error!) 4No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOST)
            
        }
        
        /* 7. Start the request */
        task.resume()

        return task
    }
    
    // MARK: DELETE Method - Udacity

    func taskForDELETEMethodUdacity(_ method: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForDELETE: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
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
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: Error?) {
                print(error)
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForDELETE(nil, error)
                //completionHandlerForDELETE(nil, NSError(domain: "taskForDELETEMethodUdacity", code: 1, userInfo: userInfo))
            }
            

            /* GUARD: Was there an error? */
            guard data != nil else {
                sendError(error)
                //sendError("No data was returned by the request")
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                sendError(error)
                //sendError("ERROR ON RANGE/DATA!")
                return
            }
            
            let newData = data?.subdata(in: range) /* subset response data! */
            

            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error)
                //sendError("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                sendError(error)
                //sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForDELETE)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: GET Methods - Udacity

    func taskForGETMethodUdacity(variant: String, parameters: [String:AnyObject], completionHandlerForUdacityGET: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
       
        let variant = URLPathVariants.UdacityUserID + APIClient.sharedInstance().uniqueID!
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: UdacityURLFromParameters(parametersWithApiKey, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)

        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: Error?) {
                print(error)
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForUdacityGET(nil, error)
                //completionHandlerForUdacityGET(nil, NSError(domain: "taskForGETMethodUdacity", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard data != nil else {
                sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("No data was returned by the request")
                return
            }
            
            guard let range = Range?(5..<data!.count) else {
                sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("ERROR ON RANGE/DATA!")
                return
            }
            
            let newData = data?.subdata(in: range) /* subset response data! */
            //var encodedData = String(data: newData!, encoding: .utf8)!
        
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("There was an error with your request")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = newData else {
                sendError(error)
                //sendError((error?.localizedDescription)!)
                //sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForUdacityGET)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
}
