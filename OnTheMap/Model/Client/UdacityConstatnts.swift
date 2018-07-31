//
//  UdacityConstatnts.swift
//  OnTheMap
//
//  Created by Sonal on 5/3/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit
extension UdacityClient
{
    struct Constants
    {
        // MARK: URLs
        static let AccountLoginURL = "https://www.udacity.com/api/session"
        static let StudentLocationsURL = "https://parse.udacity.com/parse/classes/StudentLocation"
    }
    
    struct Methods
    {
        
    }
    
    struct ParameterKeys
    {
        //MARK: Account Login
        static let AccountUdacity = "udacity"        

    }
    
    struct SubParameterKeys
    {
        static let UdacityUsername = "username"
        static let UdacityPassword = "password"
    }    
    
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys
    {
        // MARK: Account Login
        static let AccountRegistered = "registered"
        static let AccountKey = "key"
        static let SessionID = "id"
        static let SessionExpiration = "expiration"
        static let Account = "account"
        static let Session = "session"
        
        //MARK: Student Array
        static let StudentResults = "results"
        static let StudentCreatedAt = "createdAt"
        static let StudentFirstName = "firstName"
        static let StudentLastName = "lastName"
        static let StudentLatitude = "latitude"
        static let StudentLongitude = "longitude"
        static let StudentMapString = "mapString"
        static let StudentMediaURL = "mediaURL"
        static let StudentObjectID = "objectId"
        static let StudentUniqueKey = "uniqueKey"
        static let StudentUpdatedAt = "updatedAt"
        
        
        
    }
    
    
}
