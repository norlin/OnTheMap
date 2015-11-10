//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by norlin on 10/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation

struct StudentLocation {

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
            guard let data = result else {
                completionHandler(data: nil, error: HTTP.Error("getLocations", code: 1, msg: "Can't fetch locations!"))
                return
            }
            
            print(data)
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
        req.addValue(ParseAPI.Constants.ApiKey, forHTTPHeaderField: "X-Parse-REST-API-Ke")
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