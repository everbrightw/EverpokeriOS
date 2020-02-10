//
//  File.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/18/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation
import UIKit

class History{
    
    var gameType: String
    var location: String
    var result: Int
    var date: String
    var duration: String
    
    init(gameType: String, location: String, result: Int, date: String, duration: String){
        self.gameType = gameType
        self.location = location
        self.result = result
        self.date = date
        self.duration = duration
    }
    
    
}
