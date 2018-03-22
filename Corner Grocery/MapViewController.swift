//
//  MapViewController.swift
//  Corner Grocery
//
//  Created by YUAN ZHIWEN on 6/5/17.
//  Copyright © 2017 YUAN ZHIWEN. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var timeLabel: UILabel!
    
    var myRoute: MKRoute!
    //a local variable to stop tracking
    var stopRoute: Bool!
    
    var manager:CLLocationManager!
    var myLocations: [CLLocation] = []
    
    var currentLocation: CLLocation!
    var storeLocation: CLLocation!
    
    //use them to estimate distance and time
    var distance: Double!
    var time: Int!
    
    override func viewDidLoad() {
        stopRoute = true
        super.viewDidLoad()
        
        //Setup the Map View
        mapView.delegate = self
        mapView.mapType = MKMapType.standard
        
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        myRoute = MKRoute()
        //save the location of store(in the caulfield)
        storeLocation = CLLocation(latitude: -37.877623, longitude: 145.045374)
        //default label
        timeLabel.text = "Unknown"
    }
    
    //get current location and add 2 annotations to current location and store location
    //and trace route between 2 places
    //https://www.ioscreator.com/tutorials/draw-route-mapkit-tutorial
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = CLLocation()
        //avoid null
        if locations.count != 0{
            //remove all previous annotations and overlays
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.removeOverlays(self.mapView.overlays)
            
            //get latest location
            currentLocation = locations.last
            //stop update current location after already get it
            manager.stopUpdatingLocation()
            
            //add store annotation in map
            let point1 = MKPointAnnotation()
            let point2 = MKPointAnnotation()
            point1.coordinate = storeLocation.coordinate
            point1.title = "Corner Grocery"
            point1.subtitle = "Caufield"
            mapView.addAnnotation(point1)
            
            //add annotation of current location im map
            point2.coordinate = currentLocation.coordinate
            point2.title = "Your location"
            point2.subtitle = "Delivery address"
            mapView.addAnnotation(point2)
            //auto move to the center of current location in map
            mapView.centerCoordinate = point2.coordinate
            
            //use MKDirectionsRequest to compute the route.
            let directionsRequest = MKDirectionsRequest()
            let markCorner = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point1.coordinate.latitude, point1.coordinate.longitude), addressDictionary: nil)
            let markAddress = MKPlacemark(coordinate: CLLocationCoordinate2DMake(point2.coordinate.latitude, point2.coordinate.longitude), addressDictionary: nil)
            
            directionsRequest.source = MKMapItem(placemark: markAddress)
            directionsRequest.destination = MKMapItem(placemark: markCorner)
            //route type is walking
            directionsRequest.transportType = MKDirectionsTransportType.walking
            
            //calculate the direction
            let directions = MKDirections(request: directionsRequest)
            
            
            //draw the route using a polyline as a overlay view in map
            directions.calculate(completionHandler: {
                response, error in
                if error == nil && self.stopRoute == true{
                    self.myRoute = response!.routes[0] as MKRoute
                    self.mapView.add(self.myRoute.polyline)
                    //after getting current location for first time, set stopRoute to false to stop these function
                    self.stopRoute = false
                }
            })
            //zoom into both annotations
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            //stop update current location after already get it
            manager.stopUpdatingLocation()
            
            //get distance betweent 2 locations
            distance = currentLocation.distance(from: storeLocation)
            
            //calculate time based on the distance
            time = calculateTime(distance: distance)
            let hours = getHours(time: time)
            let minutes = getMinutes(time: time)
            //make UI-related thing in the main thread
            DispatchQueue.main.async(){
                self.timeLabel.text = "\(hours) hour \(minutes) mins"
            }
        }
    }
    
    //calculate time based on the distance
    func calculateTime(distance: Double) -> Int{
        time = Int(distance)/333 + 15
        return time
    }
    
    //use time to get hours
    func getHours(time: Int) -> Int{
        return Int(time/60)
    }
    
    //use time to get minutes
    func getMinutes(time: Int) -> Int{
        return time%60
    }
    
    //implement map view
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let myLineRenderer = MKPolylineRenderer(polyline: myRoute.polyline)
        myLineRenderer.strokeColor = UIColor.red
        myLineRenderer.lineWidth = 3
        return myLineRenderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
