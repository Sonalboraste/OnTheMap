//
//  ViewController.swift
//  OnTheMap
//
//  Created by Sonal on 5/1/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController
{

    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func loginPressed(_ sender: Any)
    {
        print("LOGIN SONAL")
        
        /* 2. Make the request */
        let _ = postToLogin(txtUsername.text!, strPassword: txtPassword.text!)
        { (results, error) in
            
            if let error = error
            {
                print(error)
            }
            else
            {
                performUIUpdatesOnMain
                {
                    print("navigate to next screen")
                    
                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
                    self.present(controller, animated: true, completion: nil)
                }
                
            }
        }
        
        
//        //DO the request to udacity for login??????
//        var request = URLRequest(url: URL(string: "https://www.udacity.com/api/session")!)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpBody = "{\"udacity\": {\"username\": \"sonalboraste@gmail.com\", \"password\": \"softy1234\"}}".data(using: .utf8)
//        let session = URLSession.shared
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil { // Handle error…
//                print("Sonal error found!!!")
//                return
//            }
//            let range = Range(5..<data!.count)
//            let newData = data?.subdata(in: range) /* subset response data! */
//            print(String(data: newData!, encoding: .utf8)!)
//        }
//        task.resume()
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
        let task = appDelegate.sharedSession.dataTask(with: request as URLRequest)
        { (data, response, error) in
            
            
            func sendError(_ error: String)
            {
                print(error)
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandlerForLogin(nil, NSError(domain: "taskForGETMethod", code: 1, userInfo: userInfo))
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
        }
        catch
        {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    


}

