//
//  ViewController.swift
//  DaysInState
//
//  Created by Costas Vrahimis on 5/26/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    var screenWidth: CGFloat =  0.0
    var screenHeight: CGFloat = 0.0
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var mapContainerView: UIView!
    var mapView: MKMapView!
    
    //var geotifications = [Geotification]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Location"
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        mainView = UIView(frame: CGRectMake(0,0, screenWidth, screenHeight))
        mainView.backgroundColor = UIColor.redColor()
        mainView.userInteractionEnabled = true
        
        mapContainerView = UIView(frame: CGRectMake(0, self.navigationController!.navigationBar.frame.size.height, screenWidth , screenHeight * 0.6))
        mapContainerView.backgroundColor = UIColor.whiteColor()
        mapContainerView.userInteractionEnabled = true
        
        mapView = MKMapView()
        mapView.frame = CGRectMake(0, 0, screenWidth, screenHeight * 0.6)
        mapView.mapType = MKMapType.Standard
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.showsUserLocation = true
        mapView.removeAnnotations(mapView.annotations)
        //self.view.addSubview(mapView)
        
        mapContainerView.addSubview(mapView)
        mainView.addSubview(mapContainerView)
        self.view.addSubview(mainView)
        /*
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let location = self.locationManager.location
        
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
        
        print("current latitude :: \(latitude)")
        print("current longitude :: \(longitude)")*/
        
        locationManager.delegate = self
        // 2
        locationManager.requestAlwaysAuthorization()
        // 3
        //loadAllGeotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
    // MARK: Functions that update the model/associated views with geotification changes
    
    func addGeotification(geotification: Geotification) {
        //geotifications.append(geotification)
        mapView.addAnnotation(geotification)
        addRadiusOverlayForGeotification(geotification)
        updateGeotificationsCount()
    }
    
    func removeGeotification(geotification: Geotification) {
        //if let indexInArray = geotifications.indexOf(geotification) {
            //geotifications.removeAtIndex(indexInArray)
        //}
        
        mapView.removeAnnotation(geotification)
        removeRadiusOverlayForGeotification(geotification)
        updateGeotificationsCount()
    }
    
    func updateGeotificationsCount() {
        //title = "Geotifications (\(geotifications.count))"
        //navigationItem.rightBarButtonItem?.enabled = (geotifications.count < 20)
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "myGeotification"
        if annotation is Geotification {
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                let removeButton = UIButton(type: .Custom)
                removeButton.frame = CGRect(x: 0, y: 0, width: 23, height: 23)
                removeButton.setImage(UIImage(named: "DeleteGeotification")!, forState: .Normal)
                annotationView?.leftCalloutAccessoryView = removeButton
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        //if overlay is MKCircle {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.lineWidth = 1.0
        circleRenderer.strokeColor = UIColor.purpleColor()
        circleRenderer.fillColor = UIColor.purpleColor().colorWithAlphaComponent(0.4)
        return circleRenderer
        //}
        //return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // Delete geotification
        let geotification = view.annotation as! Geotification
        stopMonitoringGeotification(geotification)
        removeGeotification(geotification)
        //saveAllGeotifications()
    }
    
    // MARK: Map overlay functions
    
    func addRadiusOverlayForGeotification(geotification: Geotification) {
        mapView?.addOverlay(MKCircle(centerCoordinate: geotification.coordinate, radius: geotification.radius))
    }
    
    func removeRadiusOverlayForGeotification(geotification: Geotification) {
        // Find exactly one overlay which has the same coordinates & radius to remove
        if let overlays = mapView?.overlays {
            for overlay in overlays {
                if let circleOverlay = overlay as? MKCircle {
                    let coord = circleOverlay.coordinate
                    if coord.latitude == geotification.coordinate.latitude && coord.longitude == geotification.coordinate.longitude && circleOverlay.radius == geotification.radius {
                        mapView?.removeOverlay(circleOverlay)
                        break
                    }
                }
            }
        }
    }
    
    // MARK: Other mapview functions
    
    @IBAction func zoomToCurrentLocation(sender: AnyObject) {
        zoomToUserLocationInMapView(mapView)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        //mapView.showsUserLocation = (status == .AuthorizedAlways)
    }
    
    func regionWithGeotification(geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate, radius: geotification.radius, identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .OnEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    func startMonitoringGeotification(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailableForClass(CLCircularRegion) {
            showSimpleAlertWithTitle("Error", message: "Geofencing is not supported on this device!", viewController: self)
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .AuthorizedAlways {
            showSimpleAlertWithTitle("Warning", message: "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location.", viewController: self)
        }
        // 3
        let region = regionWithGeotification(geotification)
        // 4
        locationManager.startMonitoringForRegion(region)
    }
    
    func stopMonitoringGeotification(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion {
                if circularRegion.identifier == geotification.identifier {
                    locationManager.stopMonitoringForRegion(circularRegion)
                }
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
   func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        //-
        
        let location = locations.last as! CLLocation
        
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        
        mapView.setRegion(region, animated: true)
        
        
        // Add an annotation on Map View
        var point: MKPointAnnotation! = MKPointAnnotation()
        
        point.coordinate = location.coordinate
        point.title = "Current Location"
        point.subtitle = "sub title"
        
        mapView.addAnnotation(point)
        
        //stop updating location to save battery life
        locationManager.stopUpdatingLocation()
        
    }*/

    
}

