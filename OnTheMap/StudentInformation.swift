//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by norlin on 21/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import CoreLocation

class StudentLocations {
    var locations: [StudentInformation]?
    
    init(){}
    
    func update(locations: [StudentInformation]){
        self.locations = locations
    }
    
    func clear(){
        locations = nil
    }
    
    class func sharedInstance() -> StudentLocations {
        struct Singleton {
            static var sharedInstance = StudentLocations()
        }
        
        return Singleton.sharedInstance
    }
}

struct StudentInformation {
    var createdAt: NSDate
    var updatedAt: NSDate
    var firstName: String
    var lastName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var mapString: String
    var mediaURL: NSURL?
    var objectId: String
    var uniqueKey: String
    
    init(dict: [String: AnyObject]){
        createdAt = Util.parseDate(dict["createdAt"] as! String)!
        updatedAt = Util.parseDate(dict["updatedAt"] as! String)!
        firstName = dict["firstName"] as! String
        lastName = dict["lastName"] as! String
        latitude = dict["latitude"] as! CLLocationDegrees
        longitude = dict["longitude"] as! CLLocationDegrees
        mapString = dict["mapString"] as! String
        if let urlString = dict["mediaURL"] as? String {
            mediaURL = NSURL(string: urlString)
        }
        objectId = dict["objectId"] as! String
        uniqueKey = dict["uniqueKey"] as! String
    }
}