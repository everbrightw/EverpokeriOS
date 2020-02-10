//
//  CalendarViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 12/2/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Firebase

class CalendarViewController: UIViewController {

    @IBOutlet var totalDurationLabel: UILabel!
    @IBOutlet var avgDurationLabel: UILabel!
    @IBOutlet var numOfSessionLabel: UILabel!
    @IBOutlet var avgNetResultLabel: UILabel!
    @IBOutlet var netHourlyRateLabel: UILabel!
    @IBOutlet var netResultLabel: UILabel!
    @IBOutlet var dateSelector: UITextField!
    var histories: [History] = []
    var currentDate: String = "current date"
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpDatePickerForTextFields()
        // setting up listner
         let db = Firestore.firestore()
        fetchRealTimeData(db)
    }
    
    
    fileprivate func setUpDatePickerForTextFields() {
        
        //date picker
        datePicker.datePickerMode = .date
        dateSelector.inputView = datePicker
        //create a toolbar
        let startToolbar = UIToolbar()
        startToolbar.sizeToFit()
        
        //add a done button on this toolbar
        let startDoneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(datePickDoneHandler))
        
        startToolbar.setItems([startDoneButton], animated: true)
        
        dateSelector.inputAccessoryView = startToolbar

    }
    
    // MARK: -handling date text field's done clicked for startTimeTextField date picker
    @objc func datePickDoneHandler(){
        
        //  format date and set it to textfield
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateSelector.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
        // update stats
        currentDate = dateSelector.text!
        updateStats()
    }
    
    func updateStats(){
        // filter histories
        print("before trim", self.histories.count)
        let temp_histories = self.histories // save state
        self.histories = trimHistories()
        print("test tri", self.histories.count)
        setNetResultsLabel()
        setHourRateValue()
        setNumSessionsValue()
        setDurationValue()
        self.histories = temp_histories // restore
        
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
        if(histories.count == 0){
            formatAndSetNetResult(label:self.avgNetResultLabel,netResultText: 0)
        }
        else{
            formatAndSetNetResult(label:self.avgNetResultLabel,netResultText: totalNetResult/histories.count)
        }
        // set total average net result
        formatAndSetNetResult(label:self.netResultLabel,netResultText: totalNetResult)
        
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
        numOfSessionLabel.text = String(histories.count)
    }
    
    // MARK: -set average duration
    func setDurationValue(){
     
        var totalDuration:Float = 0
        for (index, _) in self.histories.enumerated(){
            //append values
            //date: dates[index] as! String,
            
            totalDuration += self.histories[index].duration.hourFromString
        }
        avgDurationLabel.text = String(format: "%.1f",totalDuration/Float(histories.count)) + " Hour"
        totalDurationLabel.text = String(format: "%.1f",totalDuration) + " Hour"
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
            netHourlyRateLabel.text = "-$" + String(format: "%.2f",netResultText).trimmingCharacters(in: minus) + "/h"
            netHourlyRateLabel.textColor = UIColor(red:233/255, green:22/255, blue:51/255, alpha:1)
        }
        else{
            netHourlyRateLabel.text = "$" + String(format: "%.2f",netResultText) + "/h"
            netHourlyRateLabel.textColor = UIColor(red:35/255, green:177/255, blue:44/255, alpha:1)
        }
    }
    
    // -MARK: filter histories to display user chosen date's stats
    func trimHistories() -> [History]{
        var trimmedHistories :[History] = []
        for (index, _) in self.histories.enumerated(){
            if(histories[index].date.contains(currentDate)){
                trimmedHistories.append(histories[index])
            }
        }
        return trimmedHistories
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
                }
            }
        
        }
    

}
