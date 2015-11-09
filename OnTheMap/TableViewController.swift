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
    
    let udacityAPI = UdacityAPI.sharedInstance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        return cell
    }
}