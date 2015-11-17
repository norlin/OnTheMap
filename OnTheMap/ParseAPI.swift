//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by norlin on 10/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import CoreLocation

class StudentLocation {
    var createdAt: String
    var firstName: String
    var lastName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var mapString: String
    var mediaURL: String
    var objectId: String
    var uniqueKey: String
    var updatedAt: String
    
    init(dict: [String: AnyObject]){
        createdAt = dict["createdAt"] as! String
        firstName = dict["firstName"] as! String
        lastName = dict["lastName"] as! String
        latitude = dict["latitude"] as! CLLocationDegrees
        longitude = dict["longitude"] as! CLLocationDegrees
        mapString = dict["mapString"] as! String
        mediaURL = dict["mediaURL"] as! String
        objectId = dict["objectId"] as! String
        uniqueKey = dict["uniqueKey"] as! String
        updatedAt = dict["updatedAt"] as! String
    }
}

class ParseAPI: HTTP {
    var session_id: String?
    var account_key: String?
    
    struct Constants {
        static let BaseURLSecure: String = "https://api.parse.com/1"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    }
    
    struct Methods {
        static let StudentLocations = "/classes/StudentLocation"
    }
    
    struct Keys {
        static let ApiKey: String = "API"
    }
    
    /*
    API Methods
    */
    
    func getLocations(completionHandler: (data: [StudentLocation]?, error: NSError?) -> Void){
        let url = ParseAPI.Methods.StudentLocations
        self.get(url) { (result, error) -> Void in
            guard let data = result as? NSDictionary else {
                completionHandler(data: nil, error: HTTP.Error("getLocations", code: 1, msg: "Can't fetch locations!"))
                return
            }
            
            if let err = data.valueForKey("error") {
                completionHandler(data: nil, error: HTTP.Error("getLocations", code: 1, msg: "ParseAPI Error: \(err)"))
                return
            }
            
            guard let results = data.valueForKey("results") as? [[String: AnyObject]] else {
                completionHandler(data: nil, error: HTTP.Error("getLocations", code: 1, msg: "Can't parse locations!"))
                return
            }
            
            var locations = [StudentLocation]()
            for item in results {
                locations.append(StudentLocation(dict: item))
            }
            
            completionHandler(data: locations, error: nil)
        }
    }
    
    /*
        some common methods
    */
    
    func prepareRequest(url: String) -> NSMutableURLRequest {
        let urlString = ParseAPI.Constants.BaseURLSecure + url
        let nsurl = NSURL(string: urlString)!
        let req = NSMutableURLRequest(URL: nsurl)
        req.addValue(ParseAPI.Constants.AppID, forHTTPHeaderField: "X-Parse-Application-Id")
        req.addValue(ParseAPI.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return req
    }
    
    override func get(url: String, parameters:[String:AnyObject] = [String:AnyObject](), completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let req = prepareRequest(url)
        req.HTTPMethod = "GET"
        return request(req, completionHandler: completionHandler)
    }
    
    override func post(url: String, parameters: [String:AnyObject] = [String:AnyObject](), jsonBody: [String:AnyObject] = [String:AnyObject](), completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {

        let req = prepareRequest(url)
        req.HTTPMethod = "POST"
        req.addValue("application/json", forHTTPHeaderField: "Accept")
        req.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            req.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        return request(req, completionHandler: completionHandler)
    }
    
    override class func sharedInstance() -> ParseAPI {
        struct Singleton {
            static var sharedInstance = ParseAPI()
        }
        
        return Singleton.sharedInstance
    }
    
}