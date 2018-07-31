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
    
    func getToStudentLocations(completionHandlerForStudentLocations: @escaping (_ result: [StudentData]?, _ error: NSError?) -> Void)
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
                completionHandlerForStudentLocations(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
    func convertDataToStudentArray(_ data: Data, completionHandlerForStudentsArray: (_ result: [StudentData]?, _ error: NSError?) -> Void)
    {
        var parsedResult: AnyObject! = nil
        do
        {
            print(String(data: data, encoding: .utf8)!)
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as AnyObject
            
            
            if let results = parsedResult?[UdacityClient.JSONResponseKeys.StudentResults] as? [[String:AnyObject]]
            {
                
                let students = StudentData.studentsFromResults(results)
                
                
                completionHandlerForStudentsArray(students, nil)
                
            }
            else
            {
                completionHandlerForStudentsArray(nil, NSError(domain: "getStudents", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudents"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForStudentsArray(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
    }
    
    
    
    func getToASingleStudentLocation(completionHandlerForASingleStudentLocation: @escaping (_ result: StudentData?, _ error: NSError?) -> Void)
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
                completionHandlerForASingleStudentLocation(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
    func convertDataToStudent(_ data: Data, completionHandlerForASingleStudentLocation: (_ result: StudentData?, _ error: NSError?) -> Void)
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
                    
                    completionHandlerForASingleStudentLocation(currentStudent, nil)
                }
                else
                {
                    completionHandlerForASingleStudentLocation(nil, NSError(domain: "getAStudent", code: 10, userInfo: [NSLocalizedDescriptionKey: "No data has been posted by a student"]))
                }
                
            }
            else
            {
                completionHandlerForASingleStudentLocation(nil, NSError(domain: "getAStudent", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse getStudent"]))
            }
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForASingleStudentLocation(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
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
        //        let urlString = "https://parse.udacity.com/parse/classes/StudentLocation/8ZExGR5uX8"
        //        let url = URL(string: urlString)
        //        var request = URLRequest(url: url!)
        //        request.httpMethod = "PUT"
        //        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        //        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        //        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        //        let session = URLSession.shared
        //        let task = session.dataTask(with: request) { data, response, error in
        //            if error != nil { // Handle error…
        //                return
        //            }
        //            print(String(data: data!, encoding: .utf8)!)
        //        }
        //        task.resume()
        
        
        
        
        
        
        //PostMethod
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
            //????
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
    
}
