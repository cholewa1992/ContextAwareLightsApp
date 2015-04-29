//
//  ViewController.swift
//  Beacon
//
//  Created by Jacob Cholewa on 16/03/15.
//  Copyright (c) 2015 Jacob Cholewa. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate  {
    
    
    let peer = Peer(id: NSUUID.new().UUIDString)
    
    let locationManager:CLLocationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "8DEEFBB9-F738-4297-8040-96668BB44281"), identifier: "Roximity")
    let com = OconCom()
    
    var prior: [Int :Double] = [:]
    var tries: [Int :Int] = [:]
    let alpha = 0.5;
    
    @IBOutlet weak var uuidField: UITextField!
    @IBOutlet weak var addressField: UITextField!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 99999;
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways){
            locationManager.requestAlwaysAuthorization()
        }
        
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.distanceFilter = 99999
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        if(uuidField.text == nil){
            return;
        }
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        let person = Person(id: uuidField.text, name: "Jacob", beacons: [])
        
        for beacon in knownBeacons{
            
            var id = (beacon.major as Int) * 10000 + (beacon.minor as Int)
            var t:Double = beacon.accuracy
            prior[id] = prior[id] == nil ? t : alpha * t + (1 - alpha) * prior[id]!
            tries[id] = 0;

        }
        
        for id in tries.keys {
            if(tries[id] <= 3){
                tries[id] = tries[id]! + 1
                let major:Int = id/10000;
                let minor:Int = id - (major * 10000)
            
                person.beacons.append(
                    Beacon(
                        distance: prior[id]!,
                        major: major,
                        minor: minor
                    )
                )
            }else{
                tries.removeValueForKey(id)
                prior.removeValueForKey(id)
            }
        }
        
        if(addressField.text != nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                com.send(person, peer: peer, address: addressField.text)
            })
        }
    }
    
    func proxToInt(prox:CLProximity) -> Int{
        switch(prox){
        case CLProximity.Unknown: return 0;
        case CLProximity.Immediate: return 1;
        case CLProximity.Near: return 2;
        case CLProximity.Far: return 3;
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

