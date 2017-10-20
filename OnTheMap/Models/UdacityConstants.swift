//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/20/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation


struct Constants {
    // MARK: Keys
    struct Keys {
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }

    // MARK: - Methods
    struct Methods {
        static let AuthenticationSessionNew = "https://www.udacity.com/api/session"
        static let UserData = "https://www.udacity.com/api/users/"
        static let StudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
}
