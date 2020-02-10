//
//  UIViewExtensions.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/27/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    
    func pin(to superview:UIView){
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: superview.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superview.trailingAnchor).isActive = true
    }
    
    
}
