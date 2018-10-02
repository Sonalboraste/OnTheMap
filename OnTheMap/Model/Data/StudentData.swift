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
        if let createTime = dictionary[UdacityClient.JSONResponseKeys.StudentCreatedAt] as? String
        {
            createdAt = createTime
        }
        else
        {
            createdAt = "01/01/2000"
        }
        
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
        
        
        if let updateTime = dictionary[UdacityClient.JSONResponseKeys.StudentUpdatedAt] as? String
        {
            updatedAt = updateTime
        }
        else
        {
            updatedAt = "01/01/2000"
        }
        
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
    
    static func singleStudentFromResults(_ results: [[String:AnyObject]]) -> StudentData
    {
        //?????Sort the result by createdAt and return the latest student location back
        _ = StudentData(dictionary: results[0])
        
        
        var students = [StudentData]()
        
        // iterate through array of dictionaries, each Student is a dictionary
        for result in results
        {
            students.append(StudentData(dictionary: result))
        }
        
        /* Next, the .sorted(by:) method returns a collection that compares
           an element in the array against the next element and arranges the collection by date.
           The sorted collection is assigned back to the students array
          So, if student have multiple locations submitted then sort them by createdAt
          and return the latest created location back.
         */
        
        students = students.sorted(by: {
            $0.createdAt.compare($1.createdAt) == .orderedDescending
        })
        
       
        
        return students[0]
    }
    
    
    
    // MARK: New Student Location - When User Adds a New Location
    struct NewStudentLocation {
        static var mapString = ""
        static var mediaURL = ""
        static var latitude = 0.0
        static var longitude = 0.0
    }
    
    
    // Stores current student data
    struct CurrentStudentData
    {
        static var uniqueKey = CurrentAccount.accountKey
        static var firstName = "Hema"
        static var lastName = "Rumba"
        static var objectId = ""    // updated when there's a student location in Parse; used for PUT
        static var latitude = 0.0
        static var longitude = 0.0
        static var mapString = ""
        static var mediaURL = ""
        static var createdAt : String = ""
        static var updatedAt : String = ""
    }
    
    // MARK: User Location Dictionary
    static var currentStudentDataDictionary : [String: AnyObject] = [
        "objectId" : CurrentStudentData.objectId as AnyObject,
        "uniqueKey": CurrentStudentData.uniqueKey as AnyObject,
        "firstName": CurrentStudentData.firstName as AnyObject,
        "lastName" : CurrentStudentData.lastName as AnyObject,
        "latitude" : CurrentStudentData.latitude as AnyObject,
        "mapString": CurrentStudentData.mapString as AnyObject,
        "mediaURL": CurrentStudentData.mediaURL as AnyObject,
        "createdAt": CurrentStudentData.mapString as AnyObject,
        "updatedAt": CurrentStudentData.mediaURL as AnyObject
    ]

    
}


