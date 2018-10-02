//
//  MapAndTableTabbedViewController.swift
//  OnTheMap
//
//  Created by Sonal on 5/9/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit

class MapAndTableTabbedViewController: UITabBarController
{
    
    @IBOutlet weak var LgoutButton: UIBarButtonItem!
    
    @IBOutlet weak var AddLocationButton: UIBarButtonItem!
    
    
    @IBOutlet weak var RefreshButton: UIBarButtonItem!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        
    }
   
    @IBAction func LogoutClicked(_ sender: Any)
    {
        print("nil the session");
        
        UdacityClient.sharedInstance().taskForDeleteSession()
        
        performUIUpdatesOnMain
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func AddLocationClicked(_ sender: Any)
    {
        print("TEST Add Location")
    }
    

    @IBAction func RefreshClicked(_ sender: Any)
    {
         print("TEST Refresh Location")
        
        // create constants to prep for refreshing the two view controllers
        let mapViewController = self.viewControllers?[0] as! MapViewController
        let tableViewController = self.viewControllers![1] as! TableViewController
        
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
                performUIUpdatesOnMain
                {
                    // update UI in MapViewController and ListTableViewController
                    print("Refreshed UI")
                    mapViewController.UpdateMapWithStudentLocations()
                    tableViewController.refreshTableView()
                }
                
            }
        })
        
    }
    
}
