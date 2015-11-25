//
//  UdacityAPI.swift
//  OnTheMap
//
//  Created by norlin on 29/09/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UdacityAPI: HTTP {
    var session_id: String?
    var account_key: String?
    var isFacebook = false
    var user: [String: AnyObject]?
    
    struct Constants {
        static let BaseURLSecure: String = "https://www.udacity.com/api"
        static let ApiKey = "12342352453"
        static let FacebookAppID = "365362206864879"
        static let FacebookScheme = "onthemap"
    }
    
    struct Methods {
        static let Session = "/session"
        static let UserData = "/users/"
    }
    
    struct Keys {
        static let ApiKey: String = "API"
        static let Error: String = "error"
        static let Session: String = "session"
        static let SessionId: String = "id"
        static let Account: String = "account"
        static let AccountKey: String = "key"
        static let User: String = "user"
        static let Nickname: String = "nickname"
        static let LastName: String = "last_name"
        static let FirstName: String = "first_name"
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
                    cb(success: false, msg: err?.userInfo[NSLocalizedDescriptionKey] as? String)
                    return
                }
                
                if let data = res as? NSDictionary {
                    if let err = data.valueForKey(UdacityAPI.Keys.Error) as? String {
                        cb(success: false, msg: err)
                        return
                    }
                    let session = data.valueForKey(UdacityAPI.Keys.Session) as! NSDictionary
                    self.session_id = session.valueForKey(UdacityAPI.Keys.SessionId) as? String
                    let account = data.valueForKey(UdacityAPI.Keys.Account) as! NSDictionary
                    self.account_key = account.valueForKey(UdacityAPI.Keys.AccountKey) as? String
                    if (self.session_id != nil && self.account_key != nil){
                        cb(success: true, msg: "Success")
                    } else {
                        cb(success: false, msg: "Can't get account data!")
                    }
                }
            }
        }
    }
    
    func session(accessToken: String, completion: ((success: Bool, msg: String?) -> Void)?){
        let data = ["facebook_mobile": ["access_token": accessToken]]
        let url = UdacityAPI.Methods.Session
        
        self.post(url, jsonBody: data){(res, err) -> Void in
            if let cb = completion {
                print(err)
                if res == nil {
                    cb(success: false, msg: err?.userInfo[NSLocalizedDescriptionKey] as? String)
                    return
                }
                
                if let data = res as? NSDictionary {
                    print(data)
                    if let err = data.valueForKey(UdacityAPI.Keys.Error) as? String {
                        cb(success: false, msg: err)
                        return
                    }
                    let session = data.valueForKey(UdacityAPI.Keys.Session) as! NSDictionary
                    self.session_id = session.valueForKey(UdacityAPI.Keys.SessionId) as? String
                    let account = data.valueForKey(UdacityAPI.Keys.Account) as! NSDictionary
                    self.account_key = account.valueForKey(UdacityAPI.Keys.AccountKey) as? String
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
        if (isFacebook){
            FBSDKLoginManager().logOut()
            self.isFacebook = false
            if let cb = completion {
                cb(success: true, msg: "Success")
            }
            return
        }
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
    
    func userData(completionHandler: (result: AnyObject?, error: NSError?) -> Void){
        guard let user_id = self.account_key else {
            completionHandler(result: nil, error: HTTP.Error("UdacityAPI.userData", code: 2, msg: "self.account_key == nil"))
            return
        }
        
        let url = UdacityAPI.Methods.UserData + user_id
        self.get(url){result, error in
            if let user = result?.valueForKey(UdacityAPI.Keys.User) as? [String: AnyObject] {
                self.user = user
            }
            completionHandler(result: result, error: error)
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