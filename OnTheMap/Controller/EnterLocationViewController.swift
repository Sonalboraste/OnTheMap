//
//  EnterLocationViewController.swift
//  OnTheMap
//
//  Created by Sonal on 5/24/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit
import MapKit

class EnterLocationViewController: UIViewController
{    
    let geocoder = CLGeocoder()
    var location: CLLocation?
    
    @IBOutlet weak var LocationTextField: UITextField!
    
    @IBOutlet weak var WebsiteLinkTextField: UITextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        print("!!!Test Enter Location View Controller!!!")
    }
    
    @IBAction func cancelAddLocation(_ sender: Any)
    {
        LocationTextField.text = ""
        WebsiteLinkTextField.text = ""
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func OnFindLocationClicked(_ sender: Any)
    {
        if ((LocationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.isEmpty)! || ((WebsiteLinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))?.isEmpty)!
        {
            showAlert(strTitle: "Invalid location/url", strMessage: "Please enter valid location and url")
        }
        else
        {
            let address = (LocationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))
            
            geocoder.geocodeAddressString(address!)
            { (placemarks, error) in
                
                self.location = self.processResponse(withPlacemarks: placemarks, error: error)
                
                self.performSegue(withIdentifier: "addedEditedLocationMap", sender: self.location )
            }
        }
    }
    
    private func processResponse(withPlacemarks placemarks: [CLPlacemark]?, error: Error?) -> CLLocation
    {
        var location: CLLocation?
        if let error = error
        {
            print("Unable to forward geocode address \(error)")
            self.showAlert(strTitle: "Location Error", strMessage: "Unable to find location for address")
        }
        else
        {
            
            if let placemarks = placemarks, placemarks.count > 0
            {
                location = placemarks.first?.location
            }
            if let location = location
            {
                let coordinate = location.coordinate
                print("The coordinates are: Lat:\(coordinate.latitude) Long:\(coordinate.longitude)")
                
            }
            else
            {
                self.showAlert(strTitle: "Location Error", strMessage: "Unable to find location for address")
            }
        }
        
        return location!
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nextViewController = segue.destination as! AddedEditedLocationMapViewController
        let loc = sender as? CLLocation
        
        nextViewController.location = LocationTextField.text!
        nextViewController.latitude = Float((loc!.coordinate.latitude))
        nextViewController.longitude = Float((loc!.coordinate.longitude))
        nextViewController.mediaURL = (WebsiteLinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        
        
        // store user's new location and url in struct
        StudentData.NewStudentLocation.mapString = LocationTextField.text!
        StudentData.NewStudentLocation.mediaURL =  (WebsiteLinkTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines))!
        StudentData.NewStudentLocation.latitude = (loc!.coordinate.latitude)
        StudentData.NewStudentLocation.longitude = (loc!.coordinate.longitude)
        
    }
        
    func showAlert(strTitle:String,strMessage:String)
    {
        let alert = UIAlertController(title: strTitle, message: strMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        self.present(alert, animated: true)
    }
}

