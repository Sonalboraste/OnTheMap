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
        { (result, error) in
            
            if let error = error
            {
                print(error)
                performUIUpdatesOnMain
                {
                    self.showAlert(strTitle: "Error", strMessage: error.userInfo.values.first! as! String)
                }
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
    }
    
    func showAlert(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
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
    


}

