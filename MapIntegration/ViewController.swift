//
//  ViewController.swift
//  MapIntegration
//
//  Created by Karlo Pagtakhan on 01/09/2016.
//  Copyright © 2016 AccessIT. All rights reserved.
//

import UIKit
import MapKit

var favoritePlaces = [FavoritePlace]()
var selectedPlace : FavoritePlace?

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager : CLLocationManager!
    @IBOutlet var map: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        //Show selected place or show current location
        if let selectedLocation = selectedPlace{
            setLocation(selectedPlace!)
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        //Add long press gesture to save new places
        var uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 2.0
        map.addGestureRecognizer(uilpgr)
        
        
    }
    
    // Reusable method that sets that location of a map
    func setMapRegion(map:  MKMapView, latitude: CLLocationDegrees, longitude: CLLocationDegrees,latitudeDelta: CLLocationDegrees = 0.1, longitudeDelta: CLLocationDegrees = 0.1){
        let center = CLLocationCoordinate2DMake(latitude, longitude)
        let span = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        let region = MKCoordinateRegionMake(center, span)
        map.setRegion(region, animated: true)
    }
    
    //Set the location from the selectedPlace
    func setLocation(selectedPlace: FavoritePlace){
        let coordinates = CLLocationCoordinate2DMake(selectedPlace.latitude, selectedPlace.longtitude)
        
        self.map.setCenterCoordinate(coordinates, animated: true)
        
        setMapRegion(self.map, latitude: selectedPlace.latitude, longitude: selectedPlace.longtitude, latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        let annotation = MKPointAnnotation()
        annotation.title = selectedPlace.name
        annotation.coordinate = CLLocationCoordinate2DMake(selectedPlace.latitude, selectedPlace.longtitude)
        
        self.map.addAnnotation(annotation)
    }
    
    func action(gesture:UIGestureRecognizer){
    
        if gesture.state == UIGestureRecognizerState.Began{
        
            let touchPoint = gesture.locationInView(self.map)
            let newCoordinate = self.map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            var placeName = " "
            
            
            // Get Touch Point details
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemark, error) -> Void in
                if error == nil {
                    if let p = placemark?[0]{
                        if p.areasOfInterest != nil{
                            print("Area of Interest: \(p.areasOfInterest!)")
                            placeName = p.areasOfInterest![0]
                        }
                        if p.subThoroughfare != nil{
                            print("SubThoroughfare: \(p.subThoroughfare!)")
                            if placeName.isEmpty{
                                placeName = p.subThoroughfare!
                            }
                        }
                        if p.thoroughfare != nil{
                            print("ThoroughFare: \(p.thoroughfare)!")
                            if p.subThoroughfare != nil{
                                placeName += " " + p.thoroughfare!
                            }
                        }
                        if p.locality != nil{
                            print("Locality: \(p.locality!)")
                        }
                        if p.subLocality != nil{
                            print("Sublocality: \(p.subLocality!)")
                        }
                        
                        if p.administrativeArea != nil{
                            print("Admistrative Area: \(p.administrativeArea!)")
                        }
                        if p.country != nil{
                            print("Country: \(p.country!)")
                        }
                        if p.postalCode != nil{
                            print("Postal Code: \(p.postalCode!)")
                        }
                    }
                
                }
                
                // Place annotation on Touch Point
                let annotation = MKPointAnnotation()
                annotation.title = placeName
                annotation.coordinate = newCoordinate
                self.map.addAnnotation(annotation)
                
                //Save Touch Point
                favoritePlaces.append(FavoritePlace(name: placeName, latitude: newCoordinate.latitude, longitude: newCoordinate.longitude))
            })
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let selectedLocation = selectedPlace{
            //Show place selected from the tableView
            setLocation(selectedPlace!)
        } else {
            //Show current location
            let userLocation: CLLocation = locations[0] as! CLLocation
            setMapRegion(self.map, latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, latitudeDelta: 0.01, longitudeDelta: 0.01)
        
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

