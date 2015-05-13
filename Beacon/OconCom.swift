//
//  OconCom.swift
//  Beacon
//
//  Created by Jacob Cholewa on 08/04/15.
//  Copyright (c) 2015 Jacob Cholewa. All rights reserved.
//

import Foundation
import CoreLocation



class OconCom {

    var udpClient:UDPClient!
    var connectedTo:String!

    
    func connect(host:String, port:Int) -> Bool{
        udpClient = UDPClient(addr: host, port: port)
        connectedTo = host;
        return true
    }
    
    func send(person:Person, peer:Peer, address:String!) -> Bool {
        if(address == nil){ return false; }
        if(udpClient == nil || connectedTo != address){
            connect(address, port: 2027)
        }
        
        var msg = Package(person: person, peer: peer).msg
        var (success,errmsg) = udpClient.send(str: msg)
        if(success){
            //println("Msg was sent")
            return true;
        }
        else
        {
            println("Msg was not sent");
            println(errmsg);
            return false;
        }
    }
    
    func close(){
        if(udpClient != nil){
            udpClient.close();
            udpClient = nil;
        }
    }
    
}

class Package{
    var msg:String;
    
    init(person:Person, peer:Peer){
        self.msg = "{ \"$type\": \"ContextAwareLights.CustomeCom+Message, ContextAwareLights\", \"Msg\":  { \"$type\":\"Ocon.Messages.EntityMessage, Ocon\", \"Type\": 2, \"Entity\": { \"$type\":\"ContextAwareLights.Model.Person, ContextAwareLights\", \"Id\" : \"\(person.id)\", \"Beacons\": ["
        
        
        for beacon in person.beacons{
            
            
            self.msg += "{ \"$type\": \"ContextAwareLights.Model.Beacon, ContextAwareLights\", \"Id\": \"\(beacon.uuid.UUIDString)\", \"Rssi\": \(beacon.rssi), \"Distance\": \(beacon.distance), \"Proximity\": \(beacon.proximity), \"Major\": \(beacon.major), \"Minor\": \(beacon.minor) },"
        }
        
        
        self.msg += "] }}, \"Peer\": { \"$type\": \"Ocon.OconCommunication.Peer, Ocon\", \"Id\": \"\(peer.id)\" } }"
    }
}

class Peer{
    var id:String;
    init(id:String){
        self.id = id;
    }
}

class Beacon{
    var uuid:NSUUID
    var rssi:Int
    var proximity: Int
    var distance: CLLocationAccuracy
    var major:Int
    var minor:Int
    init(/*uuid:NSUUID,rssi:Int, proximity:Int,*/ distance:CLLocationAccuracy, major:Int, minor:Int){
        self.uuid = NSUUID.new() //uuid
        self.rssi = 0 //rssi
        self.proximity = 0 //proximity
        self.distance = distance
        self.major = major
        self.minor = minor
    }
}

class Person{
    var id:String
    var name:String
    var beacons:[Beacon]
    init(id:String, name:String, beacons:[Beacon]){
        self.id = id
        self.name = name
        self.beacons = beacons
    }
}