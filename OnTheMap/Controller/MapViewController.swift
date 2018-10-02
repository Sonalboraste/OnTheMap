//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Sonal on 9/23/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

//
//  MapAndTableTabbedViewController.swift
//  OnTheMap
//
//  Created by Sonal on 5/9/18.
//  Copyright © 2018 Sonal. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate
{
    // MARK: - Properties
    

    
    let regionRadius: CLLocationDistance = 5000000
    // set initial location in USA
    //41.875815, -87.619141
    let initialLocation = CLLocation(latitude: 41.875815, longitude: -87.619141)
    
    @IBOutlet weak var mapView: MKMapView!
    
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        mapView.delegate = self       
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        //Call the udacity parse API to get the student locations
        UpdateMapWithStudentLocations()
        centerMapOnLocation(location: initialLocation)
    }
    
    func UpdateMapWithStudentLocations()
    {
        performUIUpdatesOnMain
            {
                print("Set the pins on MAP")
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                // We will create an MKPointAnnotation for each dictionary in "locations". The
                // point annotations will be stored in this array, and then provided to the map view.
                var annotations = [MKPointAnnotation]()
                
                let arrStudentData = StudentModel.sharedInstance().arrayOfStudentData  // var because this data can be refreshed
                
                //Create map annotation array from student array
                for StudentData in arrStudentData
                {
                    // Notice that the float values are being used to create CLLocationDegree values.
                    // This is a version of the Double type.
                    let lat = CLLocationDegrees(StudentData.latitude)
                    let long = CLLocationDegrees(StudentData.longitude)
                    
                    // The lat and long are used to create a CLLocationCoordinates2D instance.
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    // Here we create the annotation and set its coordiate, title, and subtitle properties
                    let annotation = MKPointAnnotation()
                    
                    annotation.coordinate = coordinate
                    annotation.title = "\(StudentData.firstName) \(StudentData.lastName)"
                    annotation.subtitle = StudentData.mediaURL
                    
                    // Finally we place the annotation in an array of annotations.
                    annotations.append(annotation)
                }
                
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
        }
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
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
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl)
    {
        
        if control == view.rightCalloutAccessoryView
        {
            guard let url = URL(string: (view.annotation?.subtitle!)!) else {
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
    
    
}

