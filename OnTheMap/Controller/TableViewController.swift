//
//  TableViewController.swift
//  OnTheMap
//
//  Created by Sonal on 5/17/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit


class TableViewController : UIViewController
{
    // This is an array of Students instances
    
    var allStudents: [StudentData] = [StudentData]()
    
    @IBOutlet weak var StudentTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // create and set the logout button
        //parent!.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(logout))
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        UdacityClient.sharedInstance().getToStudentLocations(completionHandlerForStudentLocations:
        { (students, error) in
            
            if let error = error
            {
                print(error)
            }
            else
            {
                self.allStudents = students!
                
                print(self.allStudents.count)
                
                performUIUpdatesOnMain
                {
                    print("Set the student data to tableview on MAP")
                    self.StudentTableView.reloadData()
                }
            }
        })
    }
}

extension TableViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return allStudents.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let student = allStudents[(indexPath as NSIndexPath).row]
        
        // Set the name
        cell.textLabel?.text = student.firstName + " " + student.lastName
        
        
        // If the cell has a detail label, we will put the media URL in.
        if let detailTextLabel = cell.detailTextLabel
        {
            detailTextLabel.text = "\(student.mediaURL)"
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let url = URL(string: allStudents[(indexPath as NSIndexPath).row].mediaURL) else {
            return //be safe
        }
        
        //iOS10 and above use completion handler
        if #available(iOS 10.0, *)
        {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        else
        {
            UIApplication.shared.openURL(url)
        }
    }
    
}
