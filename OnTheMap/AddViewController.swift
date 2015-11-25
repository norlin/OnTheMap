//
//  AddViewController.swift
//  OnTheMap
//
//  Created by norlin on 22/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/*
    var firstName: String
    var lastName: String
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var mapString: String
    var mediaURL: NSURL?
*/

class AddViewController: UIViewController, UITextFieldDelegate {
    let udacityAPI = UdacityAPI.sharedInstance()
    let parseAPI = ParseAPI.sharedInstance()

    @IBOutlet var addView: GSView!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var locationPreview: MKMapView!
    @IBOutlet weak var submitButton: UIBarButtonItem!
    
    var coords:CLLocationCoordinate2D?
    var mapString:String?
    var mediaURL:String?
    
    override func viewDidLoad() {
        locationText.delegate = self
        urlText.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        locationPreview.hidden = true
        submitButton.enabled = false
        locationText.text = ""
        urlText.text = ""
        addView.deactivate(true, completion: nil)
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submit(sender: AnyObject) {
        guard let coords = self.coords else {
            Util.showAlert(self, msg: "Please enter your location!")
            return
        }
        
        var location = [String: AnyObject]()
        location["mediaURL"] = urlText.text
        location["latitude"] = coords.latitude
        location["longitude"] = coords.longitude
        location["mapString"] = self.mapString
        
        guard let user = udacityAPI.user else {
            location["firstName"] = "No name"
            location["lastName"] = "Found"
            return
        }
        
        if let account_id = udacityAPI.account_key {
            location["uniqueKey"] = account_id
        }
        
        if let firstName = user[UdacityAPI.Keys.FirstName] as? String {
            location["firstName"] = firstName
        } else if let nickname = user[UdacityAPI.Keys.Nickname] as? String {
            location["firstName"] = nickname
        } else {
            location["firstName"] = "No name"
        }
        
        if let lastName = user[UdacityAPI.Keys.LastName] as? String {
            location["lastName"] = lastName
        } else {
            location["lastName"] = "None"
        }
        
        parseAPI.postLocation(location){result, err in
            if (err != nil){
                Util.showAlert(self, title: "Can't save location!", msg: "\(err?.userInfo[NSLocalizedDescriptionKey])")
                return
            }
            guard let _ = result else {
                Util.showAlert(self, title: "Can't save location!", msg: "No response received.")
                return
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func updateLocation(text: String?){
        self.coords = nil
        self.mapString = nil
        guard let location = text else {
            updateState()
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location){placemarks, error in
            guard let places = placemarks else {
                self.updateState()
                Util.showAlert(self, msg: "Can't find any location!")
                return
            }
            let place = places[0]
            let annotation = MKPointAnnotation()
            guard let coords = place.location?.coordinate else {
                self.updateState()
                Util.showAlert(self, msg: "Can't draw the location!")
                return
            }
            annotation.coordinate = coords
            self.coords = coords
            self.mapString = location
            self.locationPreview.addAnnotation(annotation)
            self.updateState()
            
            dispatch_async(dispatch_get_main_queue()){
                self.locationPreview.hidden = false
                self.locationPreview.setCenterCoordinate(coords, animated: true)
            }
        }
    }
    
    func updateState(){
        if (self.coords == nil){
            dispatch_async(dispatch_get_main_queue()){
                self.locationPreview.hidden = true
            }
        }
        if (self.coords != nil && self.mediaURL != nil){
            dispatch_async(dispatch_get_main_queue()){
                self.submitButton.enabled = true
                self.addView.activate(completion: nil)
            }
        } else {
            dispatch_async(dispatch_get_main_queue()){
                self.submitButton.enabled = false
                self.addView.deactivate(completion: nil)
            }
        }
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return self.parentViewController
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if (textField == urlText){
            let text = textField.text != nil ? textField.text : ""
            
            if (text == ""){
                textField.text = "http://"
            }
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if (textField == locationText){
            updateLocation(textField.text)
            return
        }
        
        if (textField == urlText){
            if (textField.text == "http://"){
                textField.text = ""
            }
            
            if (textField.text != nil && textField.text != ""){
                self.mediaURL = textField.text
            } else {
                self.mediaURL = nil
            }
            updateState()
            return
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true;
    }

}
