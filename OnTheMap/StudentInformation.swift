//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by norlin on 21/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import CoreLocation

class StudentInformation {
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
        createdAt = parseDate(dict["createdAt"] as! String)!
        updatedAt = parseDate(dict["updatedAt"] as! String)!
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