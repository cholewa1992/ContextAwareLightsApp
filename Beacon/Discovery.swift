//
//  Discovery.swift
//  Beacon
//
//  Created by Jacob Cholewa on 16/04/15.
//  Copyright (c) 2015 Jacob Cholewa. All rights reserved.
//

import Foundation

class Discovery : GCDAsyncUdpSocketDelegate{
    
    var udpSocket:GCDAsyncUdpSocket!;
    
    init() {
        udpSocket = GCDAsyncUdpSocket(delegate: self, delegateQueue: dispatch_get_main_queue())

        var e:NSErrorPointer = nil;
        
        //Binding to port
        if(!udpSocket.bindToPort(2025, error: e)){
            println(e);
            return;
        }
        
        //Joining multicast group
        if(!udpSocket.joinMulticastGroup("239.5.6.7", error: e)){
            println(e);
            return;
        }
        
        //Begin recieve
        if(!udpSocket.beginReceiving(e)){
            println(e);
            return;
        }

        println("UDP socket was opened!")

    }
    
    func udpSocket(sock: GCDAsyncUdpSocket!, didReceiveData data: NSData!, fromAddress address: NSData!, withFilterContext filterContext: AnyObject!) {

        println("Got data!");
        
    }
}

