//
//  Util.swift
//  OnTheMap
//
//  Created by norlin on 09/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import Foundation
import UIKit

class Util {
    class func showAlert(sender: AnyObject, title: String = "", msg: String){
        if let view = sender as? UIViewController {
            let alertController = UIAlertController(title: title, message: msg, preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
          
            view.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    class func showLoader(view: UIView) -> UIActivityIndicatorView {
        let loader = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        loader.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loader.center = view.center
        loader.backgroundColor = UIColors.loader()
        loader.hidesWhenStopped = true
        dispatch_async(dispatch_get_main_queue()){
            view.addSubview(loader)
        }
        loader.startAnimating()
        return loader
    }
    
    class func hideLoader(loader: UIActivityIndicatorView){
        loader.stopAnimating()
        dispatch_async(dispatch_get_main_queue()){
            loader.removeFromSuperview()
        }
    }

    class func parseDate(dateString: String) -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return dateFormatter.dateFromString(dateString)
    }

    class func humanDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        dateFormatter.timeStyle = .NoStyle
        dateFormatter.dateStyle = .MediumStyle
        return dateFormatter.stringFromDate(date)
    }
    
    class func openURL(sender: AnyObject, url: NSURL) {
        let app = UIApplication.sharedApplication()
        if (app.canOpenURL(url)){
            app.openURL(url)
        } else {
            Util.showAlert(sender, title: "Can't open URL!", msg: "URL '\(url)' seems incorrect, sorry.")
        }
    }
}