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
    var deactivated = false
    
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
        if (!self.deactivated) {
            if completion != nil {
                completion!()
            }
            return
        }
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
        if (!self.deactivated) {
            return
        }
        self.deactivated = false
        if let bgColor = self.colors[self] {
            self.backgroundColor = bgColor
        }
        for view in self.subviews as [UIView] {
            if let bgColor = self.colors[view] {
                view.backgroundColor = bgColor
            }
        }
    }
    
    func deactivate(instant: Bool = false, completion: (() -> Void)?){
        if (self.deactivated) {
            if completion != nil {
                completion!()
            }
            return
        }
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
        if (self.deactivated) {
            return
        }
        self.deactivated = true
        if let bgColor = self.backgroundColor {
            self.colors[self] = bgColor
            self.backgroundColor = self.detectGSColor(bgColor)
        }
        
        for view in self.subviews as [UIView] {
            if let bgColor = view.backgroundColor {
                self.colors[view] = bgColor
                view.backgroundColor = self.detectGSColor(bgColor)
            }
        }
    }
}