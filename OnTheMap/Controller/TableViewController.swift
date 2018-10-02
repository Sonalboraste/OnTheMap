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
    
   
    
    @IBOutlet weak var StudentTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(true)
        
        // put the refresh code here
        // If you need to repeat them to update the data in the view controller, viewDidAppear(_:) is more appropriate to do so.
        refreshTableView()

    }
   
    // Refresh Table Data
    func refreshTableView()
    {
        if let studentTableView = StudentTableView
        {
            studentTableView.reloadData()
        }
    }
}

extension TableViewController : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return StudentModel.sharedInstance().arrayOfStudentData.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentCell")!
        let student = StudentModel.sharedInstance().arrayOfStudentData[(indexPath as NSIndexPath).row]
        
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
        guard let url = URL(string: StudentModel.sharedInstance().arrayOfStudentData[(indexPath as NSIndexPath).row].mediaURL) else {
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
