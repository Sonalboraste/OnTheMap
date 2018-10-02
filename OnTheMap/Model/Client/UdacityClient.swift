//
//  UdacityClient.swift
//  OnTheMap
//
//  Created by Sonal on 5/3/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit

class UdacityClient: NSObject
{
    // MARK: Shared Instance
    
    class func sharedInstance() -> UdacityClient
    {
        struct Singleton
        {
            static var sharedInstance = UdacityClient()
        }
        return Singleton.sharedInstance
    }
    
    
    func postToLogin(_ strUserName: String, strPassword: String, completionHandlerForLogin: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void)
    {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let parameterValue = [UdacityClient.SubParameterKeys.UdacityUsername : strUserName,
                              UdacityClient.SubParameterKeys.UdacityPassword: strPassword]
        
        _ = [UdacityClient.ParameterKeys.AccountUdacity : parameterValue]
        
        let jsonBody = "{\"\(UdacityClient.ParameterKeys.AccountUdacity)\": {\"\(UdacityClient.SubParameterKeys.UdacityUsername)\": \"\(strUserName)\", \"\(UdacityClient.SubParameterKeys.UdacityPassword)\": \"\(strPassword)\"}}"
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: URL(string: UdacityClient.Constants.AccountLoginURL)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonBody.data(using: .utf8)
        
        /* 4. Make the request */
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogin(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your internet connection!")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertData: completionHandlerForLogin)
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    // given raw JSON, return a usable Foundation object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertData: (_ result: AnyObject?, _ error: NSError?) -> Void)
    {
        
        var parsedResult: AnyObject! = nil
        do
        {
            let range = Range(5..<data.count)
            let newData = data.subdata(in: range) /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            
            parsedResult = try JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject
            
            
            if let result = parsedResult?[UdacityClient.JSONResponseKeys.Account] as? [String:AnyObject]
            {
                /*Set the values of singleton account properties*/
                _ = CurrentAccount.accountFromResult(result)
                
                completionHandlerForConvertData(parsedResult, nil)
                
            }
            else
            {
                completionHandlerForConvertData(nil, NSError(domain: "getAccount", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getAccount"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
    }
    
    
    
    
    func getToStudentLocations(completionHandlerForStudentLocations: @escaping (_ success:Bool, _ error: NSError?) -> Void)
    {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        
        /* 2/3. Build the URL, Configure the request */
        var request = URLRequest(url: URL(string: UdacityClient.Constants.StudentLocationsURL)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForStudentLocations(false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataToStudentArray(data, completionHandlerForStudentsArray: completionHandlerForStudentLocations)
            
            
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    
    // given raw JSON, return a usable Foundation object
    func convertDataToStudentArray(_ data: Data, completionHandlerForStudentsArray: (_ success:Bool, _ error: NSError?) -> Void)
    {
        var parsedResult: AnyObject! = nil
        do
        {
            //print(String(data: data, encoding: .utf8)!)
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
            if let results = parsedResult?[UdacityClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]]
            {
                
               // let students = StudentData.studentsFromResults(results)
                
                var arrayOfLocationsDictionaries = results
                
                // clear out all user data after successful logout
                StudentModel.sharedInstance().arrayOfStudentData = []
                //Check if a user location exists, if yes, add it to the 100 student locations. If a user location does not exist, then do not add user location to 100 student locations.
                guard StudentData.CurrentStudentData.objectId != "" else
                {
                    
                    // objectId == "", ignore currentStudentDate and go straight to inputting 100 student
                    
                    
                    // MARK: Store 100 Student Locations (User has not posted a location yet)
                    StudentModel.sharedInstance().arrayOfStudentData = StudentData.studentsFromResults(arrayOfLocationsDictionaries)
                    
                    // Only completionHander that sets 'data' to 'true'
                    completionHandlerForStudentsArray(true, nil)
                    return
                }
                
                // StudentData.CurrentStudentData.objectId exists, append 1 CurrentStudentData to 100 students array
               
                arrayOfLocationsDictionaries.insert(StudentData.currentStudentDataDictionary, at: 0)
                
                //  MARK: Store 101 Student locations (includes 1 User Location)
                StudentModel.sharedInstance().arrayOfStudentData = StudentData.studentsFromResults(arrayOfLocationsDictionaries)
                // create constants to prep for refreshing the two view controllers
                
                
                
                
                completionHandlerForStudentsArray(true, nil)
                
            }
            else
            {
                completionHandlerForStudentsArray(false, NSError(domain: "getStudents", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudents"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForStudentsArray(false, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    
    
    func getToASingleStudentLocation(completionHandlerForASingleStudentLocation: @escaping (_ success:Bool, _ error: NSError?) -> Void)
    {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        
        /* 2/3. Build the URL, Configure the request */
        var strURL = UdacityClient.Constants.StudentLocationsURL
        //strURL += "?where={\"uniqueKey\":\"\(CurrentAccount.accountKey)\"}"
        strURL += "?where=%7B%22uniqueKey%22%3A%22\(CurrentAccount.accountKey)%22%7D"
        
        var request = URLRequest(url: URL(string: strURL)!)
        
        //var request = URLRequest(url: URL(string: strURL.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        /* 4. Make the request */
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForASingleStudentLocation(false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertDataToStudent(data, completionHandlerForASingleStudentLocation: completionHandlerForASingleStudentLocation)
            
            
        }
        
        /* 7. Start the request */
        task.resume()
    }

    
    // given raw JSON, return a usable Foundation object
    func convertDataToStudent(_ data: Data, completionHandlerForASingleStudentLocation: (_ success:Bool, _ error: NSError?) -> Void)
    {
        var parsedResult: AnyObject! = nil
        do
        {
            print(String(data: data, encoding: .utf8)!)
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
            if let results = parsedResult?[UdacityClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]]
            {
                print(results)
                if(results.count>0)
                {
                    let currentStudent = StudentData.singleStudentFromResults(results)
                    
                    // Store data into StudentData.CurrentStudentData
                   
                    print("results[0] parsed 'firstName: \(StudentData.CurrentStudentData.firstName)")
                    StudentData.CurrentStudentData.firstName = currentStudent.firstName
                    print("results[0] parsed 'firstName: \(StudentData.CurrentStudentData.firstName)")
                    
                    print("results[0] parsed 'lastName: \(StudentData.CurrentStudentData.lastName)")
                    StudentData.CurrentStudentData.lastName = currentStudent.lastName
                    print("results[0] parsed 'lastName: \(StudentData.CurrentStudentData.lastName)")
                    
                    print("results[0] parsed 'objectID: \(StudentData.CurrentStudentData.objectId)")
                    StudentData.CurrentStudentData.objectId = currentStudent.objectID
                    print("results[0] parsed 'objectID: \(StudentData.CurrentStudentData.objectId)")
                    
                    print("results[0] parsed 'mapString: \(StudentData.CurrentStudentData.mapString)")
                    StudentData.CurrentStudentData.mapString = currentStudent.mapString
                    print("results[0] parsed 'mapString: \(StudentData.CurrentStudentData.mapString)")
                    
                    print("results[0] parsed 'mediaURL: \(StudentData.CurrentStudentData.mediaURL)")
                    StudentData.CurrentStudentData.mediaURL = currentStudent.mediaURL
                    print("results[0] parsed 'mediaURL: \(StudentData.CurrentStudentData.mediaURL)")
                    
                    print("results[0] parsed 'lat: \(StudentData.CurrentStudentData.latitude)")
                    StudentData.CurrentStudentData.latitude = Double(currentStudent.latitude)
                    print("results[0] parsed 'lat: \(StudentData.CurrentStudentData.latitude)")
                    
                    print("results[0] parsed 'long: \(StudentData.CurrentStudentData.longitude)")
                    StudentData.CurrentStudentData.longitude = Double(currentStudent.longitude)
                    print("results[0] parsed 'long: \(StudentData.CurrentStudentData.longitude)")
                    
                    print("results[0] parsed 'createdAt: \(StudentData.CurrentStudentData.createdAt)")
                    StudentData.CurrentStudentData.createdAt = currentStudent.createdAt
                    print("results[0] parsed 'createdAt: \(StudentData.CurrentStudentData.createdAt)")
                    
                    print("results[0] parsed 'updatedAt: \(StudentData.CurrentStudentData.updatedAt)")
                    StudentData.CurrentStudentData.updatedAt = currentStudent.updatedAt
                    print("results[0] parsed 'updatedAt: \(StudentData.CurrentStudentData.updatedAt)")
                    
                    completionHandlerForASingleStudentLocation(true, nil)
                }
                else
                {
                    completionHandlerForASingleStudentLocation(false, NSError(domain: "getAStudent", code: 10, userInfo: [NSLocalizedDescriptionKey: "No data has been posted by a student"]))
                }
                
            }
            else
            {
                completionHandlerForASingleStudentLocation(false, NSError(domain: "getAStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudent"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForASingleStudentLocation(false, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }    
    
     func postToNewStudentLocation(newStudentMapString: String, newStudentMediaURL: String, newStudentLatitude: Float, newStudentLongitude: Float, completionHandlerForPostToNewStudentLocation: @escaping (_ success:Bool, _ error:NSError?) -> Void)
     {
        //PostMethod
        print("Post the location to server")
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //NOTE: Do not post your name and location to the map
        request.httpBody = "{\"uniqueKey\": \"\(CurrentAccount.accountKey)\", \"firstName\": \"Hema\", \"lastName\": \"Rumba\",\"mapString\": \"\(newStudentMapString)\", \"mediaURL\": \"\(newStudentMediaURL)\",\"latitude\": \(newStudentLatitude), \"longitude\": \(newStudentLongitude)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPostToNewStudentLocation(false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            //????
            print(String(data: data, encoding: .utf8)!)

            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertNewStudentDataWithCompletionHandler(data, completionHandlerForPostToNewStudentLocation: completionHandlerForPostToNewStudentLocation)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    // given raw JSON, return a usable Foundation object
    private func convertNewStudentDataWithCompletionHandler(_ data: Data, completionHandlerForPostToNewStudentLocation: (_ success:Bool, _ error: NSError?) -> Void)
    {
        
        var parsedResult: AnyObject! = nil
        do
        {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
            if let objectID = parsedResult?[UdacityClient.JSONResponseKeys.StudentObjectID] as? String
            {
                /*Set the values of current student object ID*/
                
                StudentData.CurrentStudentData.objectId = objectID
                completionHandlerForPostToNewStudentLocation(true, nil)
                
            }
            else
            {
                completionHandlerForPostToNewStudentLocation(false, NSError(domain: "PostLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getAccount"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForPostToNewStudentLocation(false, NSError(domain: "convertNewStudentDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
    }
    
    
    func putToExistingStudentLocation(objectIDOfCurrentStudent : String,updatedMapString: String, updatedMediaURL: String, updatedLatitude: Float, updatedLongitude: Float, completionHandlerForPutToExistingStudentLocation: @escaping (_ success:Bool, _ error:NSError?) -> Void)
    {
        //PutMethod
        
        print("Put/update the location to server")
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation/"+objectIDOfCurrentStudent)!)
        request.httpMethod = "PUT"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //NOTE: Do not post your name and location to the map
        request.httpBody = "{\"uniqueKey\": \"\(CurrentAccount.accountKey)\", \"firstName\": \"Hema\", \"lastName\": \"Rumba\",\"mapString\": \"\(updatedMapString)\", \"mediaURL\": \"\(updatedMediaURL)\",\"latitude\": \(updatedLatitude), \"longitude\": \(updatedLongitude)}".data(using: .utf8)
        
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForPutToExistingStudentLocation(false, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
            }
            
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                sendError("There was an error with your request: \(error!)")
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError("Your request returned a status code other than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                sendError("No data was returned by the request!")
                return
            }
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            
            print(String(data: data, encoding: .utf8)!)
            
            /* 5/6. Parse the data and use the data (happens in completion handler) */
            self.convertExistingStudentDataWithCompletionHandler(data, completionHandlerForPutToExistingStudentLocation: completionHandlerForPutToExistingStudentLocation)
        }
        
        /* 7. Start the request */
        task.resume()
    }
    
    
    private func convertExistingStudentDataWithCompletionHandler(_ data: Data, completionHandlerForPutToExistingStudentLocation: (_ success:Bool, _ error: NSError?) -> Void)
    {
        
        var parsedResult: AnyObject! = nil
        do
        {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
            if let updatedAt = parsedResult?[UdacityClient.JSONResponseKeys.StudentUpdatedAt] as? String
            {
                /*Set the values of current student object ID*/
                
                print("updatedAt:"+updatedAt)
                
                completionHandlerForPutToExistingStudentLocation(true, nil)
                
            }
            else
            {
                completionHandlerForPutToExistingStudentLocation(false, NSError(domain: "PutLocation", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getAccount"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForPutToExistingStudentLocation(false, NSError(domain: "convertNewStudentDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
    }
    
    func taskForDeleteSession()
    {
        // Once you get a session ID using Udacity's API, you should delete the session ID to "logout". This is accomplished by using Udacity’s session method
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
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                print("Your Request Returned A Status Code Other Than 2xx!")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                print("No data was returned by the request!")
                return
            }
            
            let range = Range(5..<data!.count)
            let newData = data?.subdata(in: range) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            
            print("User has Successfully Logged Out")
            
            // clear out all user data after successful logout
            self.clearUserData()
        }
        task.resume()
    }
    
    func clearUserData()
    {
        // clear out all user data after successful logout
        StudentModel.sharedInstance().arrayOfStudentData = []
        
        // clear out all user data after successful logout       
        
        StudentData.NewStudentLocation.latitude = 0.0
        StudentData.NewStudentLocation.longitude = 0.0
        StudentData.NewStudentLocation.mapString = ""
        StudentData.NewStudentLocation.mediaURL = ""
        
        StudentData.CurrentStudentData.firstName = ""
        StudentData.CurrentStudentData.lastName = ""
        StudentData.CurrentStudentData.objectId = ""
        StudentData.CurrentStudentData.uniqueKey = ""
        StudentData.CurrentStudentData.mapString = ""
        StudentData.CurrentStudentData.mediaURL = ""
        
        StudentData.currentStudentDataDictionary = [:]
    }

    
}
