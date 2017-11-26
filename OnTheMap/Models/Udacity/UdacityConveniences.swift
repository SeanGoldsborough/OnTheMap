//
//  UdacityConveniences.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 11/5/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    func postSession(email: String, password: String, _ completionHandlerForUserID: @escaping (_ success: Bool, _ sessionID: Int?, _ errorString: String?) -> Void) {
        //var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        var request = URLRequest(url: URL(string: Constants.URLComponents.SessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
               // completionHandlerForPOST("nil", false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
                        if error != nil { // Handle error…
                            print("ERROR!")
                            return
                        }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299  else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
                /* GUARD: Was there any data returned? */
                guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
               // completionHandlerForPOST("nil", false, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
                return
                }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)! + "UdacityMethodsError")
            //self.parseJSON(newData)
            let parsedData = self.parseJSON(newData)
            print(newData)
            
            //UdacityClient().convertDataWithCompletionHandler(newData, completionHandlerForConvertingData: completionHandlerForPOST)
            
            
            //TODO: Parse JSON Further to return a Boolean value on account/registered to allow further login access
        }
        task.resume()
        
    }
    
    func simplePostSession(email: String, password: String) {
        //var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        var request = URLRequest(url: URL(string: Constants.URLComponents.SessionURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            func sendError(_ error: String) {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                // completionHandlerForPOST("nil", false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            if error != nil { // Handle error…
                print("ERROR!")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299  else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                let userInfo = [NSLocalizedDescriptionKey: "No data was returned by the request!"]
                // completionHandlerForPOST("nil", false, NSError(domain: "taskForPostMethod", code: 1, userInfo: userInfo))
                return
            }
            
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)! + "UdacityMethodsError")
            //self.parseJSON(newData)
            let parsedData = self.parseJSON(newData)
            print(newData)
            
            //UdacityClient().convertDataWithCompletionHandler(newData, completionHandlerForConvertingData: completionHandlerForPOST)
            
            
            //TODO: Parse JSON Further to return a Boolean value on account/registered to allow further login access
        }
        task.resume()
        
    }
    
    //TODO: Replace the User Number with a Variable?
    //TODO: Make parsing Account:Registered/Key and Session:ID/Expiration two separate funcs
    //func getUserData(_ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void)
    
    
//    func getUserData(email: String, password: String, _ completionHandlerForUserID: @escaping (_ success: Bool, _ userID: Int?, _ errorString: String?) -> Void) {
//        
//        //MARK: Setup Params - Should be UdacityClient.ParameterKeys.UserID: UdacityClient.sharedInstance().userID!
//         let parameters = [UdacityClient.Constants.ParameterKeys.UserID: UdacityClient.sharedInstance().userID!]
//            
//        
//        //var registeredInt: Int
//        //let request = URLRequest(url: URL(string: "https://www.udacity.com/api/users/3903878747")!)
//        let request = URLRequest(url: URL(string: Constants.URLComponents.UdacityBaseURL + Constants.URLPathParam.users)!)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                print("\(error!) + UdacityMethodsError2")
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
//            print("got dat user data! MMMmmmmmmMMmMMMmmmm")
//            print(request)
//            
//            do {
//                let parsedData = try JSONSerialization.jsonObject(with: newData!, options: .allowFragments) as AnyObject
//                //print(parsedData)
//                
//                guard let jsonArray = parsedData as? [String: Any] else {print("ERROR0");return}
//                guard let jsonDictionary = jsonArray as? [String: Any] else {return}
//                guard let account = jsonDictionary["account"] as? [String: Any] else {print("ERROR1"); return}
//                guard let registered = account["registered"] as? Int else {print("ERROR2"); return}
//                print(registered)
//                print(jsonArray)
//                //registeredInt = registered + registeredInt
//                //print(registeredInt)
//                
//            } catch {
//                let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(newData)'"]
//                
//            }
//            //print(registeredInt)
//            
////            performUpdatesOnMain {
////                if registeredInt == 1 {
////
////                } else {
////
////                }
////            }
//            
//        }
//        
//        task.resume()
//        
//    }
    
    func deleteSession() {
        
//        let loginStoryboard = storyboard?.instantiateViewController(withIdentifier: "LoginVC")
//        self.present(loginStoryboard!, animated: true, completion: nil)
        
        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                print("ERROR with LOGOUT")
                return
            }
            
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
        }
        print("Session has been deleted. YAAAAAAAAY!!!!!")
        //DISMISS STORYBOARD OR VC OR WHATEVERZ HERE AFTER LOGGING OUT
       
//        let loginVC = LoginVC()
//        loginVC.present(LoginVC(), animated: true, completion: nil)
        
        task.resume()
       
        
    }
    
    func parseJSON(_ data: Data) -> Void {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
        } catch {
            print("\(error) + UdacityMethodsError-parseJSON")
            let userInfo = [NSLocalizedDescriptionKey: "Could not parse the data as JSON: \(data)"]
            
        }
        
    }
    
}
