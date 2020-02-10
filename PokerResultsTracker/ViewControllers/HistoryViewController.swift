//
//  HistoryViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/18/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class HistoryViewController:UIViewController{
    
    // Add button
    
    @IBOutlet weak var addSessionButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    // Histories Array
    var histories: [History] = []
    
    @IBOutlet weak var historyTitleLabel: UILabel!
    let cellSpacingHeight: CGFloat = 60 // spacing between each cell
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get user data base
        let db = Firestore.firestore()
              
        // Customizing navigation bar
        self.navigationController!.navigationBar.barTintColor = .black
//        self.navigationController!.navigationBar.isTranslucent = true
        self.navigationController!.navigationBar.tintColor = #colorLiteral(red: 1, green: 0.99997437, blue: 0.9999912977, alpha: 1)
        
        // DB listener
        fetchRealTimeData(db)
        // set delegates and data source
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor(red:41/255, green:42/255, blue:59/255, alpha:1)
        
        // style title
        let myMutableString = NSMutableAttributedString(string: "History", attributes: [NSAttributedString.Key.font :UIFont(name: "Avenir Heavy", size: 32.0)!])
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red:240/255, green:139/255, blue:67/255, alpha:1), range: NSRange(location:0,length:1))
        historyTitleLabel.attributedText = myMutableString
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
                
                    print("Current location is: \(locations)")
                    print("Current net results are: \(netResults)")
                    
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
                    
                    // Refresh Data
                    self.tableView.reloadData()
            }
            
        }
    }
}

// Construct Table List View
extension HistoryViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.histories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let history = histories[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell") as! HistoryCell
        cell.setHistory(history: history)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect (x: 0, y: 0, width: 320, height: 20) ) as UIView
        view.backgroundColor = UIColor(red:41/255, green:42/255, blue:59/255, alpha:1)
        return view
    }
    
}
