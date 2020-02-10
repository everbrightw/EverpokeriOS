 //
//  ReportsViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 12/1/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Firebase
import Charts
 
class ReportsViewController: UIViewController {

    @IBOutlet var pieChartView: PieChartView! // pie chart view
    var winningDataEntry = PieChartDataEntry(value: 0)
    var lossingDataEntry = PieChartDataEntry(value: 0)
    
    @IBOutlet var reportChartVIew: ReportsChartView!
    @IBOutlet var switchChartButton: UIButton!
    
    let db = Firestore.firestore()
    var histories: [History] = []
    
    var currentChartIsBar: Bool = true// keeping tack of current chart

    var winOrLoseDataEntries: [PieChartDataEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reportChartVIew.contentMode = .scaleAspectFit
        // Do any additional setup after loading the view.
        fetchRealTimeData(db)
        
        // set up pie chart
        setUpPieChart()
        
        
    }
    
    func setUpPieChart(){
       
        winningDataEntry.value = 0
        winningDataEntry.label = "Wins"
        
        lossingDataEntry.value = 0
        lossingDataEntry.label = "Loses"
        
        winOrLoseDataEntries = [winningDataEntry, lossingDataEntry]
        
        updatePieChart()
        
    }
    
    func updatePieChart(){
        let chartDataSet = PieChartDataSet(entries: winOrLoseDataEntries, label:nil)
        let chartData = PieChartData(dataSet: chartDataSet)
        let colors = [UIColor(red:35/255, green:177/255, blue:44/255, alpha:1), UIColor(red:233/255, green:22/255, blue:51/255, alpha:1)]
        chartDataSet.colors = colors as! [NSUIColor]
        pieChartView.data = chartData
        // initialize pie chart to be hidden
        if(currentChartIsBar){
            pieChartView.alpha = 0
        }
        else{
            pieChartView.alpha = 1
        }
    }
    
    
    @IBAction func showPieChart(_ sender: Any) {
        if(currentChartIsBar){
            reportChartVIew.alpha = 0
            pieChartView.alpha = 1
            switchChartButton.setTitle("Show Bar Chart", for: .normal)
            self.currentChartIsBar = false
        }
        else{
            pieChartView.alpha = 0
            reportChartVIew.alpha = 1
            switchChartButton.setTitle("Show Pie Chart", for: .normal)
            self.currentChartIsBar = true
        }
        
    }
    
    @IBAction func updateBars(_ sender: Any) {
        if(currentChartIsBar){
            ReportsChartView.playAnimations()
        }
    
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
                   // keep track of winning and losing sessions counts
                   var tempWinCount: Int = 0
                   var tempLoseCount: Int = 0
                
                   for (index, element) in locations.enumerated(){
                       //append values
                       //date: dates[index] as! String,
                       var tempDate = dates[index]
                       if(tempDate == nil){
                           tempDate  = "No Date Found In Database"
                       }
                        var netResult: Int = netResults[index] as! Int
                        
                    
                        if(netResult > 0){
                            tempWinCount += 1
                        }else{
                            tempLoseCount += 1
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
                   self.winningDataEntry.value = Double(tempWinCount)
                   self.lossingDataEntry.value = Double(tempLoseCount)
                   self.updatePieChart()
           }
           
       }
   }
    
    
    
    static func generateReport(histories: [History])-> [Report]{

        var Jan: Double = 0.0
        var Feb: Double = 0.0
        var Mar: Double = 0.0
        var Apr: Double = 0.0
        var May: Double = 0.0
        var Jun: Double = 0.0
        var Jul: Double = 0.0
        var Aug: Double = 0.0
        var Sep: Double = 0.0
        var Oct: Double = 0.0
        var Nov: Double = 0.0
        var Dec: Double = 0.0
        //return [Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
        for (index, _) in histories.enumerated(){
            if(histories[index].date.contains("Jan")){
                Jan += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Feb")){
                Feb += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Mar")){
                Mar += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Apr")){
                Apr += Double(histories[index].result)
            }
            else if(histories[index].date.contains("May")){
                May += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Jun")){
                Jun += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Jul")){
                Jul += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Aug")){
                Aug += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Sep")){
                Sep += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Oct")){
                Oct += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Nov")){
                Nov += Double(histories[index].result)
            }
            else if(histories[index].date.contains("Dec")){
                Dec += Double(histories[index].result)
            }
        }
        return [Report(day: "Jan", netResult: 0), Report(day: "Feb", netResult: Feb), Report(day: "Mar", netResult: Mar), Report(day: "Apr", netResult: Apr), Report(day: "May", netResult: May), Report(day: "Jun", netResult: Jun), Report(day: "Jul", netResult: Jul), Report(day: "Aug", netResult: Aug), Report(day: "Sep", netResult: Sep), Report(day: "Oct", netResult: Oct), Report(day: "Nov", netResult: Nov), Report(day: "Jan", netResult: Dec)]
    }
    
    static func getReportTemplate() -> [Report]{
        
        let Jan: Report = Report(day: "Jan", netResult: 0)
        let Feb: Report = Report(day: "Feb", netResult: 0)
        let Mar: Report = Report(day: "Mar", netResult: 0)
        let Apr: Report = Report(day: "Apr", netResult: 0)
        let May: Report = Report(day: "May", netResult: 0)
        let Jun: Report = Report(day: "Jun", netResult: 0)
        let Jul: Report = Report(day: "Jul", netResult: 0)
        let Aug: Report = Report(day: "Aug", netResult: 0)
        let Sep: Report = Report(day: "Sep", netResult: 0)
        let Oct: Report = Report(day: "Oct", netResult: 0)
        let Nov: Report = Report(day: "Nov", netResult: 0)
        let Dec: Report = Report(day: "Dec", netResult: 0)
        return [Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
        
    }

}
