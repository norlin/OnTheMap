//
//  ViewGrayscale.swift
//  OnTheMap
//
//  Created by norlin on 29/09/15.
//  Copyright © 2015 norlin. All rights reserved.
//

import UIKit

class GSView: UIView {
    var colors: [UIView: UIColor] = [UIView: UIColor]()
    
    func detectGSColor(color: UIColor) -> UIColor {
        let cColor = CIColor(color: color)
        let r = cColor.red
        let g = cColor.green
        let b = cColor.blue
        let a = cColor.alpha
        
        let m = (r + g + b) / 3
        
        return UIColor(red: m, green: m, blue: m, alpha: a)
    }
    
    func activate(instant: Bool = false, completion: (() -> Void)?){
        if (instant == true){
            self.activate()
            if completion != nil {
                completion!()
            }
        } else {
            UIView.animateWithDuration(1, animations: {() -> Void in
                self.activate()
            }){success in
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func activate(){
        if (self.colors[self] != nil) {
            self.backgroundColor = self.colors[self]
        }
        for view in self.subviews {
            if (self.colors[view] != nil) {
                view.backgroundColor = self.colors[view]
            }
        }
    }
    
    func deactivate(instant: Bool = false, completion: (() -> Void)?){
        if (instant == true){
            self.deactivate()
            if completion != nil {
                completion!()
            }
        } else {
            UIView.animateWithDuration(1, animations: {() -> Void in
                self.deactivate()
            }){success in
                if completion != nil {
                    completion!()
                }
            }
        }
    }
    
    func deactivate(){
        if (self.backgroundColor != nil) {
            self.colors[self] = self.backgroundColor
            self.backgroundColor = self.detectGSColor(self.colors[self]!)
        }
        for view in self.subviews {
            if (view.backgroundColor != nil) {
                self.colors[view] = view.backgroundColor
                view.backgroundColor = self.detectGSColor(self.colors[view]!)
            }
        }
    }
}