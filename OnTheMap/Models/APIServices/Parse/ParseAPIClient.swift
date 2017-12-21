//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 12/19/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
extension APIClient {

    // MARK: Helpers
    
    // given raw JSON, return a usable Foundation object
//    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void) {
//        
//        var parsedResult: AnyObject! = nil
//        do {
//            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
//            //parsedResult = try JSONDecoder().decode([StudentLocations].self, from: data) as AnyObject
//            
//        } catch {
//            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
//            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
//        }
//        
//        completionHandlerForConvertData(parsedResult, nil)
//        
//    }
    
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

    
    // MARK: GET Methods - Parse
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForGETMethodParse(variant: String, parameters: [String:AnyObject], completionHandlerForParseGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parametersWithApiKey, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
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
    
    
    // MARK: POST Method - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForPOSTMethodParse(_ variant: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOSTParse: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parameters = [String: AnyObject]()
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parameters, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "POST"
        //        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(Constants.ApplicationIDParse, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKeyParse, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: String.Encoding.utf8)
        print("The request.httpBody is: \(request.httpBody!)")
        
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            print("Parse POST: The URL Data Task Response is: \(request)")
            print("Parse POST: The URL Data Task Response is: \(response)")
            //print("Parse POST: The URL Data Task Response is: \(task)")
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPOSTParse(nil, NSError(domain: "taskForPOSTMethodParse", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx\(error)!")
                return
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error)")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOSTParse)
            print("The POST JSON Data is: \(data)")
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: PUT Method - PARSE
    // TODO: FIX THIS SO IT WORKS WITH PROPER PARAMETERS
    func taskForPUTMethodPARSE(_ variant: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parameters = [String:AnyObject]()
        //parametersWithApiKey[URLQueryKeys.APIKey] = Constants.APIKeyUdacity as AnyObject?
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parameters, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "PUT"
        request.addValue(Constants.ApplicationIDParse, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKeyParse, forHTTPHeaderField: "X-Parse-REST-API-Key")
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
                sendError("Your PUT request returned a status code other than 2xx! Response is: \(response)")
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
}


