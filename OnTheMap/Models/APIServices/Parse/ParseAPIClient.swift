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
        
        return components.url!
    }

    
    // MARK: GET Methods - Parse

    func taskForGETMethodParse(variant: String, parameters: [String:AnyObject], completionHandlerForParseGET: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
        /* 1. Set the parameters */
        var parametersWithApiKey = parameters
        
        /* 2/3. Build the URL, Configure the request */
        let request = NSMutableURLRequest(url: ParseURLFromParameters(parametersWithApiKey, withPathExtension: variant), cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.addValue(Constants.ApplicationIDParse, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.APIKeyParse, forHTTPHeaderField: "X-Parse-REST-API-Key")
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            //print("No data was returned by the request\(data)")
            //print("Data from parse get is: \(String(data: data!, encoding: .utf8)!)")
            
            func sendError(_ error: Error?) {
                print(error)
                completionHandlerForParseGET(nil, error)
                //let userInfo = [NSLocalizedDescriptionKey : error]
                //completionHandlerForParseGET(nil, NSError(domain: "taskForGETMethodParse", code: 1, userInfo: userInfo))
               
            }
            
//            let results = String(data: data!, encoding: .utf8)
//
//            var parseError: AnyObject?
//
//            if let parseError = results!["error"] as? String {
//                print("An error was returned by the request \(parseError)")
//            }
//            if let parsedData = results as? String {
//                print("got the results in parsed data")
//                parseError = parsedData as AnyObject
//                //let errorMessage = parseError!["error"] as? String
//                print("parse GET method error is: \(parseError)")
            
//                if let account = parsedData["error"] as? String {
//                     print("the results are: \(account)")
//                }
//                else {
//                    print("the results are good")
//                }
               
//                let account = parseError!["error"] as? String
//                 print("the account is: \(account)")
//            } else {
//                print("the results are not good")
//
//            }

            
            
//            do {
//                let parsedData = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject
//                //print("the parsedData is: \(parsedData)")
//                guard let account = parsedData["error"] as? String else {print("the results are good");return}
//                print("the results are: \(account)")
//                //accountVariable = account
//            } catch {
//                print("the results are good: ")
//            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                //sendError("Network Unavailable")
                print("No error was returned by the request")
                sendError(error)
                return
            }
            
//            /* GUARD: Did we get a successful 2XX response? */
//            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 {
//                print("valid status code of Parse GET")
//            } else {
//                //sendError("There was an error with your request")
//                sendError(error)
//            }
            
//            let dataResults = String(data: data!, encoding: .utf8)
//            print("Data was returned by the request was: \(dataResults)")
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
//                print("No data was returned by the request \(data)")
                sendError(error)
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandlerForParseGET)
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    
    // MARK: POST Method - PARSE

    func taskForPOSTMethodParse(_ variant: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPOSTParse: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
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
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            func sendError(_ error: Error?) {
                print(error)
                //let userInfo = [NSLocalizedDescriptionKey : error]
                //completionHandlerForPOSTParse(nil, NSError(domain: "taskForPOSTMethodParse", code: 1, userInfo: userInfo))
                completionHandlerForPOSTParse(nil, error)
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                //sendError("No data was returned by the request")
                sendError(error)
                return
            }
            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError(error)
//                //sendError("There was an error with your request")
//                return
//            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error)
                //sendError("Network Unavailable")
                return
            }

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPOSTParse)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }

    
    // MARK: PUT Method - PARSE

    func taskForPUTMethodPARSE(_ variant: String, parameters: [String:AnyObject], jsonBody: String, completionHandlerForPUT: @escaping (_ result: AnyObject?, _ error: Error?) -> Void) -> URLSessionDataTask {
        
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
        /* 4. Make the request */
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            func sendError(_ error: Error?) {
                print(error)
                //let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPUT(nil, error)
                //completionHandlerForPUT(nil, NSError(domain: "taskForPUTMethodPARSE", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError(error)
                //sendError("Network Unavailable")
                return
            }
            
//            /* GUARD: Did we get a successful 2XX response? */
//            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
//                sendError(error)
//                //sendError("There was an error with your request")
//                return
//            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError(error)
                //sendError("No data was returned by the request")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForPUT)
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
}

