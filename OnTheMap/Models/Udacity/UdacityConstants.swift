//
//  UdacityConstants.swift
//  OnTheMap
//
//  Created by Sean Goldsborough on 10/20/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

extension UdacityClient {
   
    

struct Constants {
    // MARK: Keys
    struct Keys {
        static let ApiKey : String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        
    }
    
    // MARK: URL Components
    struct URLComponents {
        static let UdacityBaseURL = "https://www.udacity.com/api/"
        static let SessionURL = "https://www.udacity.com/api/session"
        
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    // MARK: - Methods
    struct Methods {
        static let AuthenticationSessionNew = "https://www.udacity.com/api/session"
        static let UserData = "https://www.udacity.com/api/users/"
        static let StudentLocations = "https://parse.udacity.com/parse/classes/StudentLocation"
        
    }
    

    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Key
        static let ApiKey = "cec14169bb6921f04d7278bbc2277288"
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.themoviedb.org"
        static let ApiPath = "/3"
        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        static let AccountURL = "https://www.themoviedb.org/account/"
    }
    
    // MARK: Methods - URL Path Parameters
    struct URLPathParam {
        
        static let Session = "session"
        static let users = "users/"
        
        // MARK: Account
        static let Account = "/account"
        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        static let AccountIDFavorite = "/account/{id}/favorite"
        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        static let AccountIDWatchlist = "/account/{id}/watchlist"
        
        // MARK: Authentication
        static let AuthenticationTokenNew = "/authentication/token/new"
        static let AuthenticationSessionNew = "/authentication/session/new"
        
        // MARK: Search
        static let SearchMovie = "/search/movie"
        
        // MARK: Config
        static let Config = "/configuration"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        static let UserID = "id"
    }
    
    // MARK: Parameter Keys - URL Query Strings
    struct ParameterKeys {
        static let ApiKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
        static let UserID = "id"
        static let expiration = "expiration"
        static let registered = "registered"
        static let key = "key"
    }
    
    struct Session {
        static let UserID = "id"
        static let expiration = "expiration"
    }
    
    struct Account {
        static let registered = "registered"
        static let key = "key"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
        
        static let UdacityDict = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Account = "account"
        static let registered = "registered"
        static let AccountKey = "key"
        static let Session = "session"
        static let SessionID = "id"
        static let expiration = "expiration"
        
        
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        //static let account = "account"
        
        //static let Session = "session"
        //static let SessionID = "id"
        
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        
        
//        static let ConfigImages = "images"
//        static let ConfigPosterSizes = "poster_sizes"
//        static let ConfigProfileSizes = "profile_sizes"
//
//        // MARK: Movies
//        static let MovieID = "id"
//        static let MovieTitle = "title"
//        static let MoviePosterPath = "poster_path"
//        static let MovieReleaseDate = "release_date"
//        static let MovieReleaseYear = "release_year"
//        static let MovieResults = "results"
        
    }
    
    
}
}
