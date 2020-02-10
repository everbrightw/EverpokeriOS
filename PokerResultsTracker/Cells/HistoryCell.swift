//
//  HistoryCell.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/18/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blindsLabel: UILabel!
    @IBOutlet weak var netResultLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    // icons
    @IBOutlet weak var dollarSign: UIImageView!
    @IBOutlet weak var clockImage: UIImageView!
    @IBOutlet weak var locationImage: UIImageView!
    
    func setHistory(history: History){
        
//        dateLabel.text = "November 25, 2019"
//        blindsLabel.text = "1/2NL"
//        netResultLabel.text = "$620"
//        durationLabel.text = "3:52"
//        locationLabel.text = "CampusCircle"
        
        // styling
        self.backgroundColor = UIColor(red:48/255, green:48/255, blue:62/255, alpha:1)
        self.layer.cornerRadius = 30
        self.clipsToBounds = true
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.gray.cgColor
        // styling icons to white
        dollarSign.tintColor = .white
        clockImage.tintColor = .white
        locationImage.tintColor = .white
        
        // set cell value
        dateLabel.text = history.date
        locationLabel.text = history.location
        blindsLabel.text = history.gameType
        locationLabel.text = history.location
        durationLabel.text = history.duration
        
        formatAndSetNetResult(netResultText: history.result)
        
    }
    
    func formatAndSetNetResult(netResultText: Int){
        if(netResultText < 0){
            let minus: CharacterSet = ["-"]
            netResultLabel.text = "-$" + String(netResultText).trimmingCharacters(in: minus)
            netResultLabel.textColor = UIColor(red:233/255, green:22/255, blue:51/255, alpha:1)
        }
        else{
            netResultLabel.text = "$" + String(netResultText)
            netResultLabel.textColor = UIColor(red:35/255, green:177/255, blue:44/255, alpha:1)
        }
    }
    
    
}
