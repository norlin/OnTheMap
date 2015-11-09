//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by norlin on 29/09/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation

class UdacityAPI: HTTP {
    var session_id: String?
    var account_key: String?
    
    struct Constants {
        static let BaseURLSecure: String = "https://www.udacity.com/api"
        static let ApiKey = "12342352453"
    }
    
    struct Methods {
        static let Session = "/session"
    }
    
    struct Keys {
        static let ApiKey: String = "API"
    }
    
    /*
    API Methods
    */
    
    func session(login: String, password: String, completion: ((success: Bool, msg: String?) -> Void)?){
        let url = UdacityAPI.Methods.Session
        let data:[String:AnyObject] = ["udacity": ["username": login, "password": password]]
        self.post(url, jsonBody: data){res, err in
            if let cb = completion {
                if res == nil {
                    cb(success: false, msg: err?.description)
                    return
                }
                
                if let data = res as? NSDictionary {
                    if let err = data.valueForKey("error") as? String {
                        cb(success: false, msg: err)
                        return
                    }
                    let session = data.valueForKey("session") as! NSDictionary
                    self.session_id = session.valueForKey("id") as? String
                    let account = data.valueForKey("account") as! NSDictionary
                    self.account_key = account.valueForKey("key") as? String
                    if (self.session_id != nil && self.account_key != nil){
                        cb(success: true, msg: "Success")
                    } else {
                        cb(success: false, msg: "Can't get account data!")
                    }
                }
            }
        }
    }
    
    func logout(completion: ((success: Bool, msg: String?) -> Void)?){
        let url = UdacityAPI.Methods.Session
        let (urlString, _) = prepareParams(url, parameters: [String:AnyObject]())
        let nsurl = NSURL(string: urlString)!
        let req = NSMutableURLRequest(URL: nsurl)
        req.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()

        for cookie in sharedCookieStorage.cookies! as [NSHTTPCookie] {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }

        if let xsrfCookie = xsrfCookie {
            req.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        request(req){res, err in
            var success = false
            var msg = "Error happened"
            if (res != nil && err == nil){
                success = true
                msg = "Success"
                self.session_id = nil
                self.account_key = nil
            }
            if let cb = completion {
                cb(success: success, msg: msg)
            }
        }
    }
    
    
    
    /*
        some common methods
    */
    
    func prepareParams(url: String, parameters: [String:AnyObject]) -> (String, [String:AnyObject]) {
        var params = parameters
        params[UdacityAPI.Keys.ApiKey] = UdacityAPI.Constants.ApiKey
        
        return (UdacityAPI.Constants.BaseURLSecure + url, params)
    }

    override func get(url: String, parameters:[String:AnyObject] = [String:AnyObject](), completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
    
        let (urlString, params) = prepareParams(url, parameters: parameters)
        return super.get(urlString, parameters: params, completionHandler: completionHandler)
    }
    
    override func post(url: String, parameters: [String:AnyObject] = [String:AnyObject](), jsonBody: [String:AnyObject] = [String:AnyObject](), completionHandler: (result: AnyObject?, error: NSError?) -> Void) -> NSURLSessionDataTask {
        let (urlString, params) = prepareParams(url, parameters: parameters)
        return super.post(urlString, parameters: params, jsonBody: jsonBody, completionHandler: completionHandler)
    }
    
    override class func sharedInstance() -> UdacityAPI {
        struct Singleton {
            static var sharedInstance = UdacityAPI()
        }
        
        return Singleton.sharedInstance
    }
    
    override func parseJSON(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        var parsedResult: AnyObject!
        do {
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            parsedResult = try NSJSONSerialization.JSONObjectWithData(newData, options: .AllowFragments)
        } catch {
            completionHandler(result: nil, error: HTTP.Error("UdacityAPI.parseJSON", code: 1, msg: "Could not parse the data as JSON: '\(data)'"))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
}