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
    
    var logoutButton: UIBarButtonItem!
    var logoutInProgress = false
    
    override func viewDidLoad() {
        logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
    }
    
    override func viewWillAppear(animated: Bool) {
        logoutButton.enabled = true
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationItem.setLeftBarButtonItem(logoutButton, animated: animated)
    }
    
    func logout(sender: UIBarButtonItem){
        logoutButton.enabled = false
        udacityAPI.logout(){success, msg in
            if (success){
                dispatch_async(dispatch_get_main_queue()){
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
            } else {
                dispatch_async(dispatch_get_main_queue()){
                    self.logoutButton.enabled = true
                    showAlert(self, msg: "Can't logout: \(msg)")
                }
            }
        }
    }
}