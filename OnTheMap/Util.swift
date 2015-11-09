//
//  Util.swift
//  OnTheMap
//
//  Created by norlin on 09/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import UIKit

func showAlert(sender: AnyObject, title: String = "", msg: String){
    if let view = sender as? UIViewController {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
      
        view.presentViewController(alertController, animated: true, completion: nil)
    }
}