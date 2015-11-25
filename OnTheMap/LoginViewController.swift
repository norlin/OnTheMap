//
//  ViewController.swift
//  OnTheMap
//
//  Created by norlin on 27/09/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginView: GSView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    
    @IBOutlet weak var customFBButton: UIButton!
    
    let udacityAPI = UdacityAPI.sharedInstance()
    let parseAPI = ParseAPI.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let fbButton = FBSDKLoginButton(frame: customFBButton.frame)
        fbButton.readPermissions = ["public_profile"]
        fbButton.delegate = self
        if let token = FBSDKAccessToken.currentAccessToken() {
            self.login(token.tokenString)
        }
        customFBButton.hidden = true
        self.view.addSubview(fbButton)
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loginView.deactivate(!animated, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        loginView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1)
        loginButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1)
        msgLabel.text = ""
        //loginText.text = ""
        //passText.text = ""
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginPress(sender: AnyObject) {
        if (!loginButton.enabled){
            return
        }
        let login = loginText.text!
        let pass = passText.text!
        
        self.msgLabel.text = "Loading..."
        
        if (login.isEmpty || pass.isEmpty) {
            self.msgLabel.text = "Enter login and password"
            return
        }
        
        loginButton.enabled = false
        udacityAPI.session(login, password: pass, completion: onSession)
    }
    
    private func onSession(success: Bool, msg: String?){
        if (success){
            dispatch_async(dispatch_get_main_queue()){
                self.onLogin()
            }
        } else {
            let message = msg == nil ? "Error happened" : msg!
            
            dispatch_async(dispatch_get_main_queue()){
                self.msgLabel.text = message
                Util.showAlert(self, title: "Login failed!", msg: message)
            }
        }
        dispatch_async(dispatch_get_main_queue()){
            self.loginButton.enabled = true
        }
    }
    
    func onLogin(){
        if let dest = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") {
            self.msgLabel.text = "Success!"
            self.loginView.activate(){
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController?.pushViewController(dest, animated: true)
                }
            }
        }
    }
    
    func login(token: String){
        udacityAPI.session(token){success, msg in
            if (!success){
                FBSDKLoginManager().logOut()
                self.udacityAPI.isFacebook = false
            } else {
                self.udacityAPI.isFacebook = true
            }
            self.onSession(success, msg: msg)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error != nil) {
            Util.showAlert(self, title: "Facebook Login", msg: "\(error.description)")
        }
        
        if (result.isCancelled){
            print("login cancelled")
            return
        }
        
        if let token = result.token {
            self.login(token.tokenString)
        } else {
            Util.showAlert(self, title: "Facebook Login", msg: "Can't get Udacity session!")
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        udacityAPI.logout(){success, msg in
            if (success){
                self.parseAPI.logout()
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    Util.showAlert(self, msg: "Can't logout: \(msg)")
                }
            }
        }
    }
}

