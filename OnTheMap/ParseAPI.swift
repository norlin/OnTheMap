//
//  ParseAPI.swift
//  OnTheMap
//
//  Created by norlin on 10/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation

class ParseAPI: HTTP {
    var session_id: String?
    var account_key: String?
    var locations: StudentLocations
    
    struct Constants {
        static let BaseURLSecure: String = "https://api.parse.com/1"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let AppID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let Limit = 100
        static let SortBy = "-updatedAt"
    }
    
    struct Methods {
        static let StudentLocations = "/classes/StudentLocation"
    }
    
    struct Keys {
        static let ApiKey = "API"
        static let LimitKey = "limit"
        static let OrderKey = "order"
    }
    
    override init(){
        self.locations = StudentLocations.sharedInstance()
        super.init()
    }
    
    func logout(){
        locations.clear()
        session_id = nil
        account_key = nil
    }
    
    /*
    API Methods
    */
    
    func getLocations(completionHandler: (data: [StudentInformation]?, error: NSError?) -> Void){
        let url = ParseAPI.Methods.StudentLocations
        
        let params: [String: AnyObject] = [
            ParseAPI.Keys.LimitKey: ParseAPI.Constants.Limit,
            ParseAPI.Keys.OrderKey: ParseAPI.Constants.SortBy
        ]
        
        self.get(url, parameters: params) { (result, error) -> Void in
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
            
            var locations = [StudentInformation]()
            for item in results {
                locations.append(StudentInformation(dict: item))
            }
            
            locations.sortInPlace({ $0.updatedAt.compare($1.updatedAt) == .OrderedDescending })
            self.locations.update(locations)
            completionHandler(data: locations, error: nil)
        }
    }
    
    func postLocation(location: [String: AnyObject], completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        let url = ParseAPI.Methods.StudentLocations
        
        let params: [String: AnyObject] = [
            ParseAPI.Keys.LimitKey: ParseAPI.Constants.Limit,
            ParseAPI.Keys.OrderKey: ParseAPI.Constants.SortBy
        ]
        
        self.post(url, parameters: params, jsonBody: location, completionHandler: completionHandler)
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
        let urlString = url + HTTP.escapedParameters(parameters)
        let req = prepareRequest(urlString)
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