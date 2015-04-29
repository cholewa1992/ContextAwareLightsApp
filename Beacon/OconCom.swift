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

    var tcpClient:TCPClient!
    var connectedTo:String!

    
    func connect(host:String, port:Int) -> Bool{
        tcpClient = TCPClient(addr: host, port: port)
        var (success,errmsg)=tcpClient.connect(timeout: 1)
        if success{
            println("Connected to \(host):\(port)");
            connectedTo = host;
            return true;
        }
        else{
            println(errmsg)
            return false;
        }
    }
    
    func send(person:Person, peer:Peer, address:String!) -> Bool {
        if(address == nil){ return false; }
        if(tcpClient == nil || connectedTo != address){
            if(!connect(address, port: 2026)){
                return false;
            }
        }
        var msg = Package(person: person, peer: peer).msg
        var (success,errmsg) = tcpClient.send(str: msg)
        if(success){
            println("Msg was sent")
            return true;
        }
        else{
            println(errmsg);
            close();
            return false;
        }
    }
    
    func close(){
        if(tcpClient != nil){
            tcpClient.close();
            tcpClient = nil;
        }
    }
    
}

class Package{
    var msg:String;
    
    init(person:Person, peer:Peer){
        self.msg = "{ \"$type\": \"Ocon.TcpCom.TcpCom+Message, Ocon\", \"Msg\":  { \"$type\":\"Ocon.Messages.EntityMessage, Ocon\", \"Type\": 2, \"Entity\": { \"$type\":\"Pac.Model.Person, Pac\", \"Id\" : \"\(person.id)\", \"Beacons\": ["
        
        
        for beacon in person.beacons{
            
            
            self.msg += "{ \"$type\": \"Pac.Model.Beacon, Pac\", \"Id\": \"\(beacon.uuid.UUIDString)\", \"Rssi\": \(beacon.rssi), \"Distance\": \(beacon.distance), \"Proximity\": \(beacon.proximity), \"Major\": \(beacon.major), \"Minor\": \(beacon.minor) },"
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
    var distance: CLLocationAccuracy
    var proximity: Int
    var major:Int
    var minor:Int
    init(uuid:NSUUID,rssi:Int, distance:CLLocationAccuracy, proximity:Int, major:Int, minor:Int){
        self.uuid = uuid
        self.rssi = rssi
        self.distance = distance
        self.proximity = proximity
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