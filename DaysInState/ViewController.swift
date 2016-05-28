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
        //mapView.showsUserLocation = true
        mapView.zoomEnabled = true
        mapView.scrollEnabled = true
        mapView.showsUserLocation = true
        //mapView.removeAnnotations(mapView.annotations)
        //self.view.addSubview(mapView)
        
        mapContainerView.addSubview(mapView)
        mainView.addSubview(mapContainerView)
        self.view.addSubview(mainView)
        
        //locationManager.delegate = self
        
        /*locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        let location = self.locationManager.location
        
        let latitude: Double = location!.coordinate.latitude
        let longitude: Double = location!.coordinate.longitude
        
        print("current latitude :: \(latitude)")
        print("current longitude :: \(longitude)")*/
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        // 3
        //loadAllGeotifications()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    // MARK: Location Deleegate functions
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("Monitoring failed for region with identifier: \(region!.identifier)")
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Location Manager failed with the following error: \(error)")
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        mapView.setRegion(region, animated: true)
        locationManager.stopUpdatingLocation()
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    func displayLocationInfo(placeMark: CLPlacemark) {
        // Address dictionary
        //print(placeMark.addressDictionary)
        
        // Location name
        if let locationName = placeMark.addressDictionary!["Name"] as? NSString {
            print(locationName)
        }
        
        // Street address
        /*if let street = placeMark.addressDictionary!["Thoroughfare"] as? NSString {
            print(street)
        }*/
        
        // City
        if let city = placeMark.addressDictionary!["City"] as? NSString {
            print(city)
        }
        
        if let state = placeMark.administrativeArea {
            print(state)
        }
        
        // Zip code
        if let zip = placeMark.addressDictionary!["ZIP"] as? NSString {
            print(zip)
        }
        
        // Country
        if let country = placeMark.addressDictionary!["Country"] as? NSString {
            print(country)
        }
        
        /*if let address = placeMark.addressDictionary![""] as? NSArray {
            let number = address[0]["short_name"] as! String
            let street = address[1]["short_name"] as! String
            let city = address[2]["short_name"] as! String
            let state = address[4]["short_name"] as! String
            let zip = address[6]["short_name"] as! String
            print("\n\(number) \(street), \(city), \(state) \(zip)")
        }*/
    }

}

