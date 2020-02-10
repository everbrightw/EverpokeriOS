//
//  StatsViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 12/1/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Firebase
import Foundation

class StatsViewController: UIViewController {

    @IBOutlet weak var netResultValueLabel: UILabel!
    @IBOutlet weak var netHourlyRateValLabel: UILabel!
    @IBOutlet weak var avgNetResultValLabel: UILabel!
    @IBOutlet weak var numSessionValLabel: UILabel!
    @IBOutlet weak var avgDurationValLabel: UILabel!
    @IBOutlet weak var tolDurationValLabel: UILabel!
    
    var histories: [History] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Get user data base
        let db = Firestore.firestore()
        fetchRealTimeData(db)
    }
    
    
    // MARK: -listenr for fetch realtime database change
    fileprivate func fetchRealTimeData(_ db: Firestore) {
        // Fetch Real Time Data
        if Auth.auth().currentUser != nil{
            // Listening multiple document depending on current user id
            db.collection("histories").whereField("user_id", isEqualTo: Auth.auth().currentUser!.uid)
                .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching documents: \(error!)")
                        return
                    }
                    // get current game stats
                    let netResults = documents.map{$0["net_result"]!}
                    let locations = documents.map { $0["location"]! }
                    let gameTypes = documents.map { $0["blinds"]! }
                    let dates = documents.map{$0["date"]}
                    let durations = documents.map{$0["duration"]}
        
                    // TODO: need to change to a more clear way?
                    var newHistories: [History] = []
                    for (index, element) in locations.enumerated(){
                        //append values
                        //date: dates[index] as! String,
                        var tempDate = dates[index]
                        if(tempDate == nil){
                            tempDate  = "No Date Found In Database"
                        }
                       
                        newHistories.append(History(
                            gameType: gameTypes[index] as! String,
                            location: element as! String,
                            result: netResults[index] as! Int,
                            date: tempDate as! String,
                            duration: durations[index] as! String)
                        )
                    }
                    // Set new histories referenced to global arrays
                    // So we can update our table list view dynamically in real time
                    self.histories = newHistories
                    self.updateStatsLabel()
                    
                }
            }
        
        }
    
    // MARK: -update stats page
    func updateStatsLabel(){
        
        setNetResultsLabel()
        setHourRateValue()
        setNumSessionsValue()
        setDurationValue()
    
    }
    // MARK: -set net result labels (both average and total)
    func setNetResultsLabel(){
        
        var totalNetResult:Int = 0
        for (index, _) in self.histories.enumerated(){
            //append values
            //date: dates[index] as! String,
            totalNetResult += self.histories[index].result
        }
        // set average net result
        formatAndSetNetResult(label:avgNetResultValLabel,netResultText: totalNetResult/histories.count)
        // set total average net result
        formatAndSetNetResult(label:netResultValueLabel,netResultText: totalNetResult)
        
    }
    // MARK: -set hour rate label
    func setHourRateValue(){
        
        var totalNetResult:Int = 0
        var totalDuration:Float = 0
        var hourRate:Float = 0.0
        for (index, _) in self.histories.enumerated(){
            //append values
            //date: dates[index] as! String,
            totalNetResult += self.histories[index].result
            totalDuration += self.histories[index].duration.hourFromString
        }
        hourRate = Float(totalNetResult)/totalDuration
        formatAndSetHourRate(netResultText: hourRate)
        
    }
    
    // MARK: -set number of sessions
    func setNumSessionsValue(){
        numSessionValLabel.text = String(histories.count)
    }
    
    // MARK: -set average duration
    func setDurationValue(){
     
        var totalDuration:Float = 0
        for (index, _) in self.histories.enumerated(){
            //append values
            //date: dates[index] as! String,
            
            totalDuration += self.histories[index].duration.hourFromString
        }
        avgDurationValLabel.text = String(format: "%.1f",totalDuration/Float(histories.count)) + " Hour"
        tolDurationValLabel.text = String(format: "%.1f",totalDuration) + " Hour"
    }
    
    
    // TODO: same as other helper function, refractor
    // MARK: -formate total net result and average net result and styling
    func formatAndSetNetResult(label: UILabel,netResultText: Int){
        if(netResultText < 0){
            let minus: CharacterSet = ["-"]
            label.text = "-$" + String(netResultText).trimmingCharacters(in: minus)
            label.textColor = UIColor(red:233/255, green:22/255, blue:51/255, alpha:1)
        }
        else{
            label.text = "$" + String(netResultText)
            label.textColor = UIColor(red:35/255, green:177/255, blue:44/255, alpha:1)
        }
    }
    
    // MARK: format hour rate float and styling
    func formatAndSetHourRate(netResultText: Float){
        if(netResultText < 0.0){
            let minus: CharacterSet = ["-"]
            netHourlyRateValLabel.text = "-$" + String(format: "%.2f",netResultText).trimmingCharacters(in: minus) + "/h"
            netHourlyRateValLabel.textColor = UIColor(red:233/255, green:22/255, blue:51/255, alpha:1)
        }
        else{
            netHourlyRateValLabel.text = "$" + String(format: "%.2f",netResultText) + "/h"
            netHourlyRateValLabel.textColor = UIColor(red:35/255, green:177/255, blue:44/255, alpha:1)
        }
    }
    
    
    

}


extension String{

    var integer: Int {
        return Int(self) ?? 0
    }

    var hourFromString : Float{
        let components: Array = self.components(separatedBy: ":")
        let hours = components[0].integer
        let minutes = components[1].integer
        return Float((hours) + (minutes / 60))
    }
}
