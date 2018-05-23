//
//  File.swift
//  OnTheMap
//
//  Created by Sonal on 5/13/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import Foundation
class StudentData
{
    var fName : String = ""
    var lName : String = ""
    var lat : Double = 0
    var long : Double = 0
    var mURL : String = ""
    var oID : String = ""
    var uKey : String = ""
    
    var firstName:String
    {
        set
        {
            fName = newValue
        }
        get
        {
            return fName
        }
    }
    
    
    var lastName:String
    {
        set
        {
            lName = newValue
        }
        get
        {
            return lName
        }
    }
    
    var latitude:Double
    {
        set
        {
            lat = newValue
        }
        get
        {
            return lat
        }
    }
    
    
    var longitude:Double
    {
        set
        {
            long = newValue
        }
        get
        {
            return long
        }
    }
    
    
    var mediaURL:String
    {
        set
        {
            mURL = newValue
        }
        get
        {
            return mURL
        }
    }
    
    var objectID:String
    {
        set
        {
            oID = newValue
        }
        get
        {
            return oID
        }
    }
    
    
    var uniqueKey:String
    {
        set
        {
            uKey = newValue
        }
        get
        {
            return uKey
        }
    }
}
