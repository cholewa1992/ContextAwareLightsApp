//
//  LocationController.swift
//  Beacon
//
//  Created by Jacob Cholewa on 22/04/15.
//  Copyright (c) 2015 Jacob Cholewa. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController : NSObject, CLLocationManagerDelegate{
    
    let peer = Peer(id: NSUUID.new().UUIDString)

    let locationManager:CLLocationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(UUIDString: "8DEEFBB9-F738-4297-8040-96668BB44281"), identifier: "Roximity")

    var uuid:String!
    var address:String!
    
    let com = OconCom()
    
    
    override init(){
        super.init()
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.pausesLocationUpdatesAutomatically = false
        
        if(CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways){
            locationManager.requestAlwaysAuthorization()
        }
        
        region.notifyEntryStateOnDisplay = true
        startMonitoring()
    }
    
    func startMonitoring(){
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
    }
    
    func stopMonitoring(){
        locationManager.stopMonitoringForRegion(region)
        locationManager.stopRangingBeaconsInRegion(region)
    }
    
    func s (){
        if(CLLocationManager.significantLocationChangeMonitoringAvailable()){
            
        }
    }
    
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("Entered");
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("Exsited");
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        
        if(uuid == nil){
            return;
        }
        
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.Unknown }
        let person = Person(id: uuid, name: "Jacob", beacons: [])
        
        for beacon in knownBeacons{
            person.beacons.append(
                Beacon(
                    uuid:beacon.proximityUUID,
                    rssi: beacon.rssi,
                    distance: beacon.accuracy,
                    proximity: proxToInt(beacon.proximity),
                    major: beacon.major as Int,
                    minor: beacon.minor as Int
                )
            )
        }
        
        println("sent!")
        if(address != nil){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                com.send(person, peer: peer, address: address)
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
}
