//
//  TableViewController.swift
//  OnTheMap
//
//  Created by norlin on 02/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: GSView!
    @IBOutlet weak var locationsTable: UITableView!
    let parseAPI = ParseAPI.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (animated){
            self.tableView.deactivate(true, completion: nil)
        }
                
        parseAPI.getLocations { (data, error) -> Void in
            if let error = error {
                Util.showAlert(self, title: "Can't fetch locations!", msg: "\(error.localizedDescription)")
            }
            
            dispatch_async(dispatch_get_main_queue()){
                self.locationsTable.reloadData()
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        if (animated){
            self.tableView.activate(false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let locations = parseAPI.locations {
            return locations.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationItem", forIndexPath: indexPath) as! LocationCell
        guard let locations = parseAPI.locations else {
            Util.showAlert(self, msg: "Can't find locations!")
            return cell
        }
        let location = locations[indexPath.row]
        
        cell.setLocationData(location)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let locations = parseAPI.locations else {
            Util.showAlert(self, msg: "Can't find locations!")
            return
        }
        let location = locations[indexPath.row]
        if let url = location.mediaURL {
            Util.openURL(self, url: url)
        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}