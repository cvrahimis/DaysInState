//
//  ViewController.swift
//  DaysInState
//
//  Created by Costas Vrahimis on 5/26/16.
//  Copyright © 2016 Costas Vrahimis. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var screenWidth: CGFloat =  0.0
    var screenHeight: CGFloat = 0.0
    @IBOutlet var remindersView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        remindersView = UIView(frame: CGRectMake(0,0, screenWidth, screenHeight))
        remindersView.backgroundColor = UIColor.blueColor()
        remindersView.userInteractionEnabled = true
        self.view.addSubview(remindersView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

