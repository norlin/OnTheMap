//
//  MapViewController.swift
//  OnTheMap
//
//  Created by norlin on 22/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var mapView: GSView!
    @IBOutlet weak var map: MKMapView!
    let parseAPI = ParseAPI.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        parseAPI.getLocations { (data, error) -> Void in
            if let error = error {
                Util.showAlert(self, title: "Can't fetch locations!", msg: "\(error.localizedDescription)")
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.updateMap()
            }
        }

    }
    
    override func viewWillAppear(animated: Bool) {
        if (animated){
            self.mapView.deactivate(true, completion: nil)
        }
    }

    override func viewDidAppear(animated: Bool) {
        if (animated){
            self.mapView.activate(false, completion: nil)
        }
    }
    
    func updateMap(){
        //MKPointAnnotation
        guard let locations = parseAPI.locations else {
            return
        }
        
        var annotations = [MKPointAnnotation]()
        for item in locations {
            let point = MKPointAnnotation()
            point.coordinate.latitude = item.latitude
            point.coordinate.longitude = item.longitude
            point.title = "\(item.firstName) \(item.lastName)"
            point.subtitle = item.mediaURL != nil ? "\(item.mediaURL!)" : ""
            
            annotations.append(point)
        }
        map.addAnnotations(annotations)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation.isKindOfClass(MKUserLocation)){
            return nil
        }
        
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
        annotationView.canShowCallout = true
        let calloutView = UIButton(type: .DetailDisclosure)
        annotationView.rightCalloutAccessoryView = calloutView
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let point = view.annotation as! MKPointAnnotation
        if let urlString = point.subtitle {
            if let url = NSURL(string: urlString) {
                Util.openURL(self, url: url)
            }
        }
    }
    
    
}