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
    
}
