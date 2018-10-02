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
    
    @IBOutlet weak var progressBarWaitCursor: UIActivityIndicatorView!
    
    var appDelegate: AppDelegate!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        progressBarWaitCursor.stopAnimating()
        progressBarWaitCursor.hidesWhenStopped = true
        
        // get the app delegate
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpPressed(_ sender: Any)
    {
        print("Sign up pressed!")
    }
    
    @IBAction func loginPressed(_ sender: Any)
    {
        print("LOGIN Clicked")
        
        progressBarWaitCursor.startAnimating()
        
        /* 2. Make the request */
        let _ = UdacityClient.sharedInstance().postToLogin(txtUsername.text!, strPassword: txtPassword.text!)
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
                /*Get current student Location*/
                self.getACurrentAccountStudentLocation()
                
            }
        }
        
        
    }
    
    func showAlert(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
    
    
    
    
    //getAStudentLocation using uniqueKey
    func getACurrentAccountStudentLocation()
    {
        /* 2. Make the request */
        let _ = UdacityClient.sharedInstance().getToASingleStudentLocation(completionHandlerForASingleStudentLocation:
        { (student, error) in
            
            if let error = error
            {
                print(error)
                if(error.code==10)
                {
                    print("No data has been posted by a student")
                    
                }
            }
            else
            {
                
                performUIUpdatesOnMain
                {
                    //set the value of current student
                    print("Successfully got the CurrentStudent Object")
                    /*Get 100 student Locations*/
                    self.getStudentLocations()
                }
            }
        })
        
    }
    
    func getStudentLocations()
    {
        /* 2. Make the request */
        let _ = UdacityClient.sharedInstance().getToStudentLocations(completionHandlerForStudentLocations:
        { (success, error) in
            
            if let error = error
            {
                print(error)
            }
            else
            {
                print("Succesfully got 100 student locations")
                
                self.completeLogin()
                
            }
        })
    }
    
    
    func completeLogin()
    {
        performUIUpdatesOnMain
        {
                print("navigate to next screen")
                
                let controller = self.storyboard!.instantiateViewController(withIdentifier: "MapAndListNavigationController")
                self.present(controller, animated: true, completion: nil)
        }
    }

}

