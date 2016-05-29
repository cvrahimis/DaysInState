//
//  InfoViewController.swift
//  DaysInState
//
//  Created by Costas Vrahimis on 5/28/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//

import Foundation
import UIKit

class InfoViewController: UIViewController, UITextFieldDelegate, UIScrollViewDelegate{
    var screenWidth: CGFloat =  0.0
    var screenHeight: CGFloat = 0.0
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var firstName: UITextField!
    @IBOutlet var lastName: UITextField!
    @IBOutlet var address1: UITextField!
    @IBOutlet var address2: UITextField!
    @IBOutlet var city: UITextField!
    @IBOutlet var state: UITextField!
    @IBOutlet var zip: UITextField!
    @IBOutlet var label: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Info"
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        mainView = UIView(frame: CGRectMake(0,0, screenWidth, screenHeight))
        mainView.backgroundColor = UIColor.redColor()
        mainView.userInteractionEnabled = true
        
        scrollView = UIScrollView(frame: CGRectMake(0, 0, screenWidth, screenHeight))
        //scrollView.center = CGPointMake(screenWidth * 0.5, screenHeight)
        scrollView.backgroundColor = UIColor.blueColor()
        scrollView.pagingEnabled = false
        scrollView.scrollEnabled = true
        scrollView.userInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        let touch = UITapGestureRecognizer(target:self, action:#selector(InfoViewController.scrollViewTap))
        scrollView.addGestureRecognizer(touch)
        scrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 1.3)
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
        
        firstName = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        firstName.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.1)
        firstName.delegate = self
        firstName.layer.cornerRadius = 10
        firstName.clipsToBounds = true
        firstName.placeholder = " First Name"
        firstName.backgroundColor = UIColor.whiteColor()
        firstName.tag = 0
        scrollView.addSubview(firstName)
        
        lastName = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        lastName.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.2)
        lastName.delegate = self
        lastName.layer.cornerRadius = 10
        lastName.clipsToBounds = true
        lastName.placeholder = " Last Name"
        lastName.backgroundColor = UIColor.whiteColor()
        lastName.tag = 1
        scrollView.addSubview(lastName)
        
        label = UILabel(frame: CGRectMake(0, 0, screenWidth * 0.9, screenHeight * 0.2))
        label.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.3)
        label.backgroundColor = UIColor.clearColor()
        label.text = "Please input your name and primary Address"
        label.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 2
        label.font = UIFont(name: label.font.fontName, size: 32)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        //label.layer.borderColor = UIColor( red:255/100, green:255/100, blue:255/100, alpha: 1.0 ).CGColor
        //label.layer.borderWidth = 3
        scrollView.addSubview(label)
        
        address1 = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        address1.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.4)
        address1.delegate = self
        address1.layer.cornerRadius = 10
        address1.clipsToBounds = true
        address1.placeholder = " Address line 1"
        address1.backgroundColor = UIColor.whiteColor()
        address1.tag = 2
        scrollView.addSubview(address1)
        
        address2 = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        address2.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.5)
        address2.delegate = self
        address2.layer.cornerRadius = 10
        address2.clipsToBounds = true
        address2.placeholder = " Address line 2"
        address2.backgroundColor = UIColor.whiteColor()
        address2.tag = 3
        scrollView.addSubview(address2)
        
        city = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        city.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.6)
        city.delegate = self
        city.layer.cornerRadius = 10
        city.clipsToBounds = true
        city.placeholder = " City"
        city.backgroundColor = UIColor.whiteColor()
        city.tag = 4
        scrollView.addSubview(city)
        
        state = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        state.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.7)
        state.delegate = self
        state.layer.cornerRadius = 10
        state.clipsToBounds = true
        state.placeholder = " State"
        state.backgroundColor = UIColor.whiteColor()
        state.tag = 5
        scrollView.addSubview(state)
        
        zip = UITextField(frame: CGRectMake(0, 0, screenWidth * 0.75, screenHeight * 0.075))
        zip.center = CGPointMake(screenWidth * 0.5, screenHeight * 0.8)
        zip.delegate = self
        zip.layer.cornerRadius = 10
        zip.clipsToBounds = true
        zip.placeholder = " Zip"
        zip.backgroundColor = UIColor.whiteColor()
        zip.tag = 6
        scrollView.addSubview(zip)
       
        mainView.addSubview(scrollView)
        self.view.addSubview(mainView)
    }
    
    func scrollViewTap(){
        view.endEditing(true)
        scrollView.contentOffset = CGPoint(x: 0, y: -64)//find mathamatical way to calculate 64
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.contentOffset = CGPoint(x: 0, y: (Int(textField.bounds.height) * textField.tag))
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        switch textField.tag
        {
            case 0:
                lastName.becomeFirstResponder()
                lastName.delegate = self
            case 1:
                address1.becomeFirstResponder()
                address1.delegate = self
            case 2:
                address2.becomeFirstResponder()
                address2.delegate = self
            case 3:
                city.becomeFirstResponder()
                city.delegate = self
            case 4:
                state.becomeFirstResponder()
                state.delegate = self
            case 5:
                zip.becomeFirstResponder()
                zip.delegate = self
            default:
                self.view.endEditing(true)
                scrollView.contentOffset = CGPoint(x: 0, y: -64) //find mathamatical way to calculate 64
        }
        
        return false;
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

