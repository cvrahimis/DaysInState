//
//  ViewController.swift
//  DaysInState
//
//  Created by Costas Vrahimis on 5/26/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//

import UIKit
import MapKit
import LocalAuthentication

class ViewController: UIViewController , CLLocationManagerDelegate, MKMapViewDelegate{
    var screenWidth: CGFloat =  0.0
    var screenHeight: CGFloat = 0.0
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var mapContainerView: UIView!
    @IBOutlet var logLocBtn: UIButton!
    @IBOutlet var statusLabel: UILabel!
    var mapView: MKMapView!
    
    //var geotifications = [Geotification]()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Location"
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        mainView = UIView(frame: CGRectMake(0,0, screenWidth, screenHeight))
        mainView.backgroundColor = UIColor.whiteColor()
        mainView.userInteractionEnabled = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit User Info", style: .Plain, target: self, action: #selector(userInfoPressed))
        
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
        
        
        statusLabel = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.9, screenHeight * 0.2))
        statusLabel.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.75)
        statusLabel.backgroundColor = UIColor.clearColor()
        statusLabel.text = "Unknown user"
        //statusLabel.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        //statusLabel.numberOfLines = 2
        statusLabel.font = UIFont(name: statusLabel.font.fontName, size: 32)
        statusLabel.textColor = UIColor.blueColor()
        statusLabel.textAlignment = NSTextAlignment.Center
        //label.layer.borderColor = UIColor( red:255/100, green:255/100, blue:255/100, alpha: 1.0 ).CGColor
        //label.layer.borderWidth = 3
        mainView.addSubview(statusLabel)
        
        logLocBtn = UIButton(frame: CGRectMake(0, 0, screenWidth * 0.7, screenHeight * 0.1))
        logLocBtn.center = CGPoint( x: screenWidth * 0.5, y: screenHeight * 0.85)
        logLocBtn.backgroundColor = UIColor.blueColor()
        logLocBtn.setTitle("Log Location with Finger Print", forState: UIControlState.Normal)
        logLocBtn.addTarget(self, action: #selector(logLocPress), forControlEvents: UIControlEvents.TouchUpInside)
        logLocBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        logLocBtn.layer.cornerRadius = 20
        logLocBtn.clipsToBounds = true
        mainView.addSubview(logLocBtn)
        
        mapContainerView.addSubview(mapView)
        mainView.addSubview(mapContainerView)
        self.view.addSubview(mainView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        
        // 3
        //loadAllGeotifications()
    }
    
    func logLocPress(){
        print("Log Location with Finger Print")
        setupData()
        authenticateUser()
    }
    
    func userInfoPressed(){
        let infoVC = InfoViewController()
        //infoVC.modalPresentationStyle = .OverCurrentContext
        //let navCtrl:UINavigationController = UINavigationController()
        //self.navigationController?.popToRootViewControllerAnimated(true)
        //navCtrl.addChildViewController(viewController)
        self.navigationController!.pushViewController(infoVC, animated: true)
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
    }
    
    //============================TouchID functions================================
    
    func setupData() {
        self.statusLabel.text = "Unknown user"
    }
    
    func authenticateUser() {
        let touchIDManager : PITouchIDManager = PITouchIDManager()
        
        touchIDManager.authenticateUser(success: { () -> () in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self.loadDada()
            })
            }, failure: { (evaluationError: NSError) -> () in
                switch evaluationError.code {
                case LAError.SystemCancel.rawValue:
                    print("Authentication cancelled by the system")
                    self.statusLabel.text = "Authentication cancelled by the system"
                case LAError.UserCancel.rawValue:
                    print("Authentication cancelled by the user")
                    self.statusLabel.text = "Authentication cancelled by the user"
                case LAError.UserFallback.rawValue:
                    print("User wants to use a password")
                    self.statusLabel.text = "User wants to use a password"
                    // We show the alert view in the main thread (always update the UI in the main thread)
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                case LAError.TouchIDNotEnrolled.rawValue:
                    print("TouchID not enrolled")
                    self.statusLabel.text = "TouchID not enrolled"
                case LAError.PasscodeNotSet.rawValue:
                    print("Passcode not set")
                    self.statusLabel.text = "Passcode not set"
                default:
                    print("Authentication failed")
                    self.statusLabel.text = "Authentication failed"
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.showPasswordAlert()
                    })
                }
        })
    }
    
    func loadDada() {
        self.statusLabel.text = "User authenticated"
    }
    
    func showPasswordAlert() {
        // New way to present an alert view using UIAlertController
        let alertController : UIAlertController = UIAlertController(title:"TouchID Demo" , message: "Please enter password", preferredStyle: .Alert)
        
        // We define the actions to add to the alert controller
        let cancelAction : UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
            print(action)
        }
        let doneAction : UIAlertAction = UIAlertAction(title: "Done", style: .Default) { (action) -> Void in
            let passwordTextField = alertController.textFields![0] as UITextField
            if let text = passwordTextField.text {
                self.login(text)
            }
        }
        doneAction.enabled = false
        
        // We are customizing the text field using a configuration handler
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue(), usingBlock: { (notification) -> Void in
                doneAction.enabled = textField.text != ""
            })
        }
        alertController.addAction(cancelAction)
        alertController.addAction(doneAction)
        
        self.presentViewController(alertController, animated: true) {
            // Nothing to do here
        }
    }
    
    func login(password: String) {
        if password == "prolific" {
            self.loadDada()
        } else {
            self.showPasswordAlert()
        }
    }
}