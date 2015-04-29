//
//  ViewController.swift
//  Beacon
//
//  Created by Jacob Cholewa on 16/03/15.
//  Copyright (c) 2015 Jacob Cholewa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController  {
    let locationController:LocationController = LocationController()
    
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBAction func buttonPressed(sender: AnyObject) {
        locationController.address = addressField.text
        locationController.uuid = uuidField.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationController.address = addressField.text
        locationController.uuid = uuidField.text
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

