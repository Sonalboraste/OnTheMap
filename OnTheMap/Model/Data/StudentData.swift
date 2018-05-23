//
//  StudentData.swift
//  OnTheMap
//
//  Created by Sonal on 5/13/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation


struct StudentData
{
    
    // MARK: Properties
    var createdAt : String = ""
    var firstName : String = ""
    var lastName : String = ""
    var latitude : Float = 0
    var longitude : Float = 0
    var mapString : String = ""
    var mediaURL : String = ""
    var objectID : String = ""
    var uniqueKey : String = ""
    var updatedAt : String = ""
    
    // MARK: Initializers
    
    // construct a StudentData from a dictionary
    init(dictionary: [String:AnyObject])
    {
        createdAt = dictionary[UdacityClient.JSONResponseKeys.StudentCreatedAt] as! String
        
        if let fName = dictionary[UdacityClient.JSONResponseKeys.StudentFirstName] as? String
        {
            firstName = fName
        }
        else
        {
            firstName = ""
        }
        
        
        if let lName = dictionary[UdacityClient.JSONResponseKeys.StudentLastName] as? String
        {
            lastName = lName
        }
        else
        {
            lastName = ""
        }
        
        if let lat = dictionary[UdacityClient.JSONResponseKeys.StudentLatitude] as? NSNumber
        {
            latitude = lat.floatValue
        }
        
        if let long = dictionary[UdacityClient.JSONResponseKeys.StudentLongitude] as? NSNumber
        {
            longitude = long.floatValue
        }
        
        if let mString = dictionary[UdacityClient.JSONResponseKeys.StudentMapString] as? String
        {
            mapString = mString
        }
        else
        {
            mapString = ""
        }
        
        if let mURL = dictionary[UdacityClient.JSONResponseKeys.StudentMediaURL] as? String
        {
            mediaURL = mURL
        }
        else
        {
            mediaURL = ""
        }
        
        objectID = dictionary[UdacityClient.JSONResponseKeys.StudentObjectID] as! String
        
        if let uKey = dictionary[UdacityClient.JSONResponseKeys.StudentUniqueKey] as? String
        {
            uniqueKey = uKey
        }
        else
        {
            uniqueKey = ""
        }
        
        updatedAt = dictionary[UdacityClient.JSONResponseKeys.StudentUpdatedAt] as! String
        
        
    }
    
    static func studentsFromResults(_ results: [[String:AnyObject]]) -> [StudentData]
    {
        var students = [StudentData]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results
        {
            students.append(StudentData(dictionary: result))
        }
        
        return students
    }
    
}
