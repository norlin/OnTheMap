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
    var locations = [StudentLocation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseAPI.getLocations { (data, error) -> Void in
            guard let data = data else {
                print(error)
                return
            }
            
            self.locations = data
            dispatch_async(dispatch_get_main_queue()){
                self.locationsTable.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        if (animated){
            self.tableView.deactivate(true, completion: nil)
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
        return locations.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let location = locations[indexPath.row]
        
        cell.textLabel?.text = "\(location.firstName) \(location.lastName)"
        
        return cell
    }
}