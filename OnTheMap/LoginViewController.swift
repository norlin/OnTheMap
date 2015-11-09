//
//  ViewController.swift
//  OnTheMap
//
//  Created by norlin on 27/09/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginView: GSView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginText: UITextField!
    @IBOutlet weak var passText: UITextField!
    @IBOutlet weak var msgLabel: UILabel!
    
    let udacityAPI = UdacityAPI.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        self.loginView.deactivate(!animated, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        loginView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 1, alpha: 1)
        loginButton.backgroundColor = UIColor(red: 0.3, green: 0.7, blue: 0.3, alpha: 1)
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
        
        self.msgLabel.text = ""
        
        if (login.isEmpty || pass.isEmpty) {
            self.msgLabel.text = "Enter login and password"
            return
        }
        
        loginButton.enabled = false
        udacityAPI.session(login, password: pass){success, msg in
            if (success){
                dispatch_async(dispatch_get_main_queue()){
                    self.onLogin()
                }
            } else {
                if (msg == nil){
                    dispatch_async(dispatch_get_main_queue()){
                        self.msgLabel.text = "Error happened"
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue()){
                        self.msgLabel.text = msg
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue()){
                self.loginButton.enabled = true
            }
        }
    }
    
    func onLogin(){
        if let dest = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") {
            self.loginView.activate(){
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController?.pushViewController(dest, animated: true)
                }
            }
        }
    }
}

