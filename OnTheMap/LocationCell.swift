//
//  LocationCell.swift
//  OnTheMap
//
//  Created by norlin on 21/11/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class LocationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var link: UILabel!
    
    func setLocationData(location: StudentInformation){
        let dateString = humanDate(location.updatedAt)
        
        self.title.text = "\(location.firstName) \(location.lastName)"
        self.date.text = dateString
        
        if let url = location.mediaURL {
            self.link.text = "\(url)"
            self.link.textColor = UIColors.link()
            self.accessoryType = .DisclosureIndicator
            self.selectionStyle = .Blue
        } else {
            self.link.text = "no link"
            self.link.textColor = UIColors.secondary()
            self.accessoryType = .None
            self.selectionStyle = .None
        }
    }
}