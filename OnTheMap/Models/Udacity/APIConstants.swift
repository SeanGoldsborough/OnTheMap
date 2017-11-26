//
//  APIConstants.swift
//  OnTheMapV2
//
//  Created by Sean Goldsborough on 11/21/17.
//  Copyright © 2017 Sean Goldsborough. All rights reserved.
//

import Foundation

extension APIClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: API Keys
        //        static let APIKeyTMDB = "cec14169bb6921f04d7278bbc2277288"
        static let APIKeyUdacity = "cec14169bb6921f04d7278bbc2277288"
        static let APIKeyUdacityNil = ""
        static let APIKeyParse = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let ApplicationIDParse = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        
        // MARK: URLs
        //        static let APIScheme = "https"
        //        static let APIHost = "api.themoviedb.org"
        //        static let APIPath = "/3"
        //        static let AuthorizationURL = "https://www.themoviedb.org/authenticate/"
        //        static let AccountURL = "https://www.themoviedb.org/account/"
        
        static let APISchemeParse = "https"
        static let APIHostParse = "parse.udacity.com"
        static let APIPathParse = "/parse/classes"
        static let baseURLParse = "https://parse.udacity.com/parse/classes/StudentLocation"
        
        static let APISchemeUdacity = "https"
        static let APIHostUdacity = "www.udacity.com"
        static let APIPathUdacity = "/api"
        static let baseURLUdacity = "https://www.udacity.com/api/session"
        
        
    }
    
    // MARK: URL Path Variants
    struct URLPathVariants {
        
        // MARK: Account
        //        static let Account = "/account"
        //        static let AccountIDFavoriteMovies = "/account/{id}/favorite/movies"
        //        static let AccountIDFavorite = "/account/{id}/favorite"
        //        static let AccountIDWatchlistMovies = "/account/{id}/watchlist/movies"
        //        static let AccountIDWatchlist = "/account/{id}/watchlist"
        //
        //        // MARK: Authentication
        //        static let AuthenticationTokenNew = "/authentication/token/new"
        //        static let AuthenticationSessionNew = "/authentication/session/new"
        //
        //        // MARK: Search
        //        static let SearchMovie = "/search/movie"
        //
        //        // MARK: Config
        //        static let Config = "/configuration"
        
        // MARK: PUT - Parse
        static let StudentLocationPath = "/StudentLocation"
        static let ObjectID = "/<objectId>"
        static let ParseUniqueID = "id"
        
        // MARK: Udacity UsersID
        //static let UdacityUserID = "/users/{user_id}"
        static let UdacityUserID = "/users/"
        
        // MARK: Udacity POST Session
        static let UdacitySession = "/session"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
        // Udacity URL Keys
        static let UdacityUniqueID = "id"
    }
    
    // MARK: URL Query Parameter Keys
    struct URLQueryKeys {
        static let APIKey = "api_key"
        static let SessionID = "session_id"
        static let RequestToken = "request_token"
        static let Query = "query"
        
        // Parse URL Query Parameter Keys
        static let Where = "/where"
        static let Limit = "/limit"
        static let Skip = "/skip"
        static let Order = "/order"
        
    }
    
    // MARK: Udacity URL Query Parameter Keys
    struct UdacityParameterKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
    }
    
    // MARK: JSON Body Keys - IDK WTF THIS IS BECAUSE IT SAYS JSON BUT ITS ONLY USED IN THE URL...WTF?!?
    struct JSONBodyKeys {
        static let MediaType = "media_type"
        static let MediaID = "media_id"
        static let Favorite = "favorite"
        static let Watchlist = "watchlist"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: General
        static let StatusMessage = "status_message"
        static let StatusCode = "status_code"
        
        // MARK: Authorization
        static let RequestToken = "request_token"
        static let SessionID = "session_id"
        
        // MARK: Account
        static let UserID = "id"
        
        // MARK: Config
        static let ConfigBaseImageURL = "base_url"
        static let ConfigSecureBaseImageURL = "secure_base_url"
        static let ConfigImages = "images"
        static let ConfigPosterSizes = "poster_sizes"
        static let ConfigProfileSizes = "profile_sizes"
        
        // MARK: Components of a Movie JSON Object We Are Trying To Make Use Of
        static let MovieID = "id"
        static let MovieTitle = "title"
        static let MoviePosterPath = "poster_path"
        static let MovieReleaseDate = "release_date"
        static let MovieReleaseYear = "release_year"
        static let MovieResults = "results"
        
        // MARK: General
        //        static let StatusMessage = "status_message"
        //        static let StatusCode = "status_code"
        //
        // MARK: Udacity Authorization JSON Response
        static let Account = "account"
        static let Registered = "registered"
        static let UniqueKeyUdacity = "key"
        
        static let Session = "session"
        static let SessionIDUdacity = "id"
        static let Expiration = "expiration"
        //1542887989S7e1b5b5a3ad108a68e252783c598e012
        
        // MARK: Udacity Personal Data JSON Response
        static let UdacityPersonalDataID = "key"
        static let UdacityPersonalDataFirstName = "nickname"
        static let UdacityPersonalDataLastName = "lastname"
        static let WebsiteURL = "website_url"
        
        
        // MARK: Parse JSON Response
        static let ParseResults = "results"
        static let ObjectId = "objectId"
        static let UniqueKey = "uniqueKey"
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let CreatedAt = "createdAt"
        static let UpdatedAt = "updatedAt"
        
    }
    
}

