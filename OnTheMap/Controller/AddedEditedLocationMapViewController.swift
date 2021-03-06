//
//  AddedEditedLocationMapViewController.swift
//  OnTheMap
//
//  Created by Sonal on 6/10/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit
import MapKit

class AddedEditedLocationMapViewController: UIViewController, MKMapViewDelegate
{
    var location : String = ""
    var latitude : Float = 0.0
    var longitude : Float = 0.0
    var mediaURL : String = ""
    
    
    var userObjectId = StudentData.CurrentStudentData.objectId //d5oWV0RxIH  objectID    String
    
    
    @IBOutlet weak var mapVIew: MKMapView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        mapVIew.delegate = self
        
        print("____In Add Location Map____")
        let newStudentData = NewStudentLocationData()
        
        centerMapOnNewLocation()
        
        setAnnotationForNewLocation(newStudentData: newStudentData)        
        
        
        // Do any additional setup after loading the view.
    }

    func NewStudentLocationData() -> [[String : Any]] {
        return  [
            [
                "createdAt" : "",
                "firstName" : StudentData.CurrentStudentData.firstName,
                "lastName" : StudentData.CurrentStudentData.lastName,
                "latitude" : StudentData.NewStudentLocation.latitude,
                "longitude" : StudentData.NewStudentLocation.longitude,
                "mapString" : StudentData.NewStudentLocation.mapString,
                "mediaURL" : StudentData.NewStudentLocation.mediaURL,
                "objectId" : "",
                "uniqueKey" : StudentData.CurrentStudentData.uniqueKey,
                "updatedAt" : ""
            ]
        ]
    }
    
    func centerMapOnNewLocation()
    {
        
        let newLocation = CLLocation(latitude: CLLocationDegrees(self.latitude), longitude: CLLocationDegrees(self.longitude))
        let newLocationViewRadius: CLLocationDistance = 5000
        
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,newLocationViewRadius, newLocationViewRadius)
        
        mapVIew.setRegion(coordinateRegion, animated: true)
        
    }
    
    func setAnnotationForNewLocation(newStudentData : [[String : Any]])
    {
        var annotations = [MKPointAnnotation]()
        
        for newStudent in newStudentData
        {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(newStudent["latitude"] as! Double)
            let long = CLLocationDegrees(newStudent["longitude"] as! Double)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = newStudent["firstName"] as! String
            let last = newStudent["lastName"] as! String
            let mediaURL = newStudent["mediaURL"] as! String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapVIew.addAnnotations(annotations)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else
        {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    @IBAction func OnFinishButtonClick(_ sender: Any)
    {
        //Check if user is already there using getStudentLocation using uniqueKey that you get from postSession and save that in global variable in .swift class
        //If user location not exist then post the user(your) location to server using post method and uniqueKey
        //If user location exist then update the location using put method and using objectId got from getStudentLocation
        //if successful go back to map/tableview
        
        //if failed show the alert to the user
        /*
         - if one exists, what did you do?
         - if several exists, which one do you consistently choose to use and update?
         - if several student location records for the same student exist, do you know why?
         - if there's no student location for the app user, what did you do?
         */
        
        if StudentData.CurrentStudentData.objectId != ""
        {
            print("UPDATE EXISTING LOCATION")
            //Update the latest student location
            UpdateExistingStudentLocation()
            
        }
        else
        {
            print("POST NEW LOCATION")
            //Post new student location
            CreateNewStudentLocation()
        }
    }
    
    
    func CreateNewStudentLocation()
    {
        
        /* 2. Make the request */
        let _ = UdacityClient.sharedInstance().postToNewStudentLocation(newStudentMapString: location, newStudentMediaURL: mediaURL, newStudentLatitude: latitude, newStudentLongitude: longitude, completionHandlerForPostToNewStudentLocation:
        { (success, error) in
            
            if let error = error
            {
                // display the errorString using createAlert
                print("Unsuccessful in POSTing user location: \(error.code)")
                performUIUpdatesOnMain
                {
                    self.createAlert(title: "Error", message: "Unable to add new location.")
                }
            }
            else
            {
                print("Posted the new student location")
                /*Get current student Location*/
                self.getACurrentAccountStudentLocation()
                
            }
        })
        
    }
    
    func UpdateExistingStudentLocation()
    {
        
        let _ = UdacityClient.sharedInstance().putToExistingStudentLocation(objectIDOfCurrentStudent: StudentData.CurrentStudentData.objectId,updatedMapString: location, updatedMediaURL: mediaURL, updatedLatitude: latitude, updatedLongitude: longitude, completionHandlerForPutToExistingStudentLocation:
        { (success, error) in
            
            if let error = error
            {
                // display the errorString using createAlert
                print("Unsuccessful in updating user location: \(error.code)")
                performUIUpdatesOnMain
                    {
                        self.createAlert(title: "Error", message: "Unable to update exisitng location.")
                }
            }
            else
            {
                print("Updated the exisitng student location")
                
                /*Get current student Location*/
                self.getACurrentAccountStudentLocation()
                
//                performUIUpdatesOnMain
//                {
//                    //self.createAlert(title: "Successfully", message: "Updated the existing location.")
//                    //add the current student to map
//                    //and load 100 students to the map????
//                    let controller = self.storyboard!.instantiateViewController(withIdentifier: "OnTheMapNavigationController") as! UINavigationController
//                    self.present(controller, animated: true, completion: nil)
//                }
                
               
            }
        })
        
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
                
                //set the value of current student
                print("Successfully got the CurrentStudent Object")
                /*Get 100 student Locations*/
                self.getStudentLocations()
                
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
                print("Succesfully got 101 student locations")
                
                
                performUIUpdatesOnMain
                {
                        self.createAlert(title: "Successfully", message: "Posted the new location.")

                        // After all are successful, go back to map/tableview                    
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    // MARK: Alert Views
    func createAlert(title: String, message: String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler:
        { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }

}
