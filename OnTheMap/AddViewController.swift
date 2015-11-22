//
//  AddViewController.swift
//  OnTheMap
//
//  Created by norlin on 22/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {

    override func viewWillAppear(animated: Bool) {

    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.parentViewController
    }

}
