//
//  ParseConvenience.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/23/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation
extension ParseClient {}
//TODO: Create func for GETting Student Locations, GETting a Student Location, POSTing a Student Location, PUTting a Student Location



//GETting Student Locations
//To get multiple student locations at one time, you'll want to use the following API method:
//
//Method: https://parse.udacity.com/parse/classes/StudentLocation
//Method Type: GET
//Optional Parameters:
//limit - (Number) specifies the maximum number of StudentLocation objects to return in the JSON response
//Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=100
//skip - (Number) use this parameter with limit to paginate through results
//Example: https://parse.udacity.com/parse/classes/StudentLocation?limit=200&skip=400
//order - (String) a comma-separate list of key names that specify the sorted order of the results
//Prefixing a key name with a negative sign reverses the order (default order is ascending)
//Example: https://parse.udacity.com/parse/classes/StudentLocation?order=-updatedAt
//Example Request:
//var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error...
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()



//GETting a Student Location
//To get a single student location, you'll want to use the following API method:
//
//Method: https://parse.udacity.com/parse/classes/StudentLocation
//Method Type: GET
//Required Parameters:
//where - (Parse Query) a SQL-like query allowing you to check if an object value matches some target value
//Example: https://parse.udacity.com/parse/classes/StudentLocation?where=%7B%22uniqueKey%22%3A%221234%22%7D
//the above URL is the escaped form of… https://parse.udacity.com/parse/classes/StudentLocation?where={"uniqueKey":"1234"}
//you can read more about these types of queries in Parse’s REST API documentation
//Example Request:
//let urlString = "https://parse.udacity.com/parse/classes/StudentLocation"
//let url = URL(string: urlString)
//var request = URLRequest(url: url!)
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()

//POSTing a Student Location
//To create a new student location, you'll want to use the following API method:
//
//Method: https://parse.udacity.com/parse/classes/StudentLocation
//Method Type: POST
//Example Request:
//var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
//request.httpMethod = "POST"
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}".data(using: .utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()



//PUTting a Student Location
//To update an existing student location, you'll want to use the following API method:
//
//Method: https://parse.udacity.com/parse/classes/StudentLocation/<objectId>
//Method Type: PUT
//Required Parameters:
//objectId - (String) the object ID of the StudentLocation to update; specify the object ID right after StudentLocation in URL as seen below
//Example: https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8
//Example Request:
//let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
//let url = URL(string: urlString)
//var request = URLRequest(url: url!)
//request.httpMethod = "PUT"
//request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
//request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
//request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
//let session = URLSession.shared
//let task = session.dataTask(with: request) { data, response, error in
//    if error != nil { // Handle error…
//        return
//    }
//    print(String(data: data!, encoding: .utf8)!)
//}
//task.resume()

