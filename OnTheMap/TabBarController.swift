//
//  TabBarController.swift
//  OnTheMap
//
//  Created by norlin on 09/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    let udacityAPI = UdacityAPI.sharedInstance()
    let parseAPI = ParseAPI.sharedInstance()
    
    var logoutButton: UIBarButtonItem!
    var addButton: UIBarButtonItem!
    var logoutInProgress = false
    
    override func viewDidLoad() {
        logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        addButton = UIBarButtonItem(image: UIImage(named: "PinIcon"), style: .Plain, target: self, action: "addLocation:")
        udacityAPI.userData { (result, error) -> Void in
            guard let user = self.udacityAPI.user else {
                Util.showAlert(self, msg: "Can't find user info!")
                return
            }
            if let nickname = user[UdacityAPI.Keys.Nickname] as? String {
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationItem.title = "Hi, \(nickname)!"
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        logoutButton.enabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setLeftBarButtonItem(logoutButton, animated: animated)
        self.navigationItem.setRightBarButtonItem(addButton, animated: animated)
    }
    
    func logout(sender: UIBarButtonItem){
        logoutButton.enabled = false
        udacityAPI.logout(){success, msg in
            if (success){
                self.parseAPI.logout()
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.logoutButton.enabled = true
                    Util.showAlert(self, msg: "Can't logout: \(msg)")
                }
            }
        }
    }    
    func addLocation(sender: UIBarButtonItem){
        guard let addViewController = self.storyboard?.instantiateViewControllerWithIdentifier("addViewController") else {
        
            Util.showAlert(self, msg: "Can't create view!")
            return
        }
        
        self.presentViewController(addViewController, animated: true, completion: nil)
    }
}