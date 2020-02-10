//
//  ReportsChartView.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 12/1/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit
import Macaw
import Firebase

class ReportsChartView: MacawView{
    
    static var reports: [Report] = createFakeData()
    static let maxValue             = 3000
    static let maxValueLineHeight   = 180
    static let lineWidth: Double    = 600
      
    static let dataDivisor = Double(maxValue/maxValueLineHeight)
    static let adjustedData: [Double] = reports.map({$0.netResult/dataDivisor})
    static var animations: [Animation] = []
    static let db = Firestore.firestore()

 
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: ReportsChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func createChart() -> Group{
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        return Group(contents: items, place: .identity)
    }
    
    private static func addYAxisItems() -> [Node]{
        let maxLines = 12
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 400
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        for i in 1...maxLines{
            let y = yAxisHeight - (Double(i) * lineSpacing)
            
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            let valueText = Text(text: "\(-3000 + 2 * i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    private static func addXAxisItems() -> [Node]{
        let chartBaseY: Double = 220
        var newNodes: [Node] = []
        for i in 1...adjustedData.count{
            let x = (Double(i) * 50)
            let valueText = Text(text: reports[i-1].day, align: .max, baseline: .mid, place: .move(dx:x, dy:400 + 15))
            valueText.fill = Color.white
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        let xBaseAxis = Line(x1: 0, y1: 400, x2: lineWidth, y2: 400).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xBaseAxis)
        newNodes.append(xAxis)
        
        return newNodes
    }
    private static func createBars() -> Group {
         print("report", reports[11].netResult)
        let fill = LinearGradient(degree: 90, from: Color(val: 0xff4704), to: Color(val: 0xff4704).with(a: 0.33))
        let items = adjustedData.map {_ in Group()}
        
        animations = items.enumerated().map(){ (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1){t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 50 + 25, y: 220 - height, w: 30, h: height)
                return [rect.fill(with:fill)]
                
            }
            
        }
        return items.group()
    }
    
    static func playAnimations(){
        print("report", reports[11].netResult)
        
        animations.combine().play()
    }
    
    
    
    static func createFakeData() -> [Report]{
        
        let Jan: Report = Report(day: "Jan", netResult: 2000)
        let Feb: Report = Report(day: "Feb", netResult: 2100)
        let Mar: Report = Report(day: "Mar", netResult: 1800)
        let Apr: Report = Report(day: "Apr", netResult: 3000)
        let May: Report = Report(day: "May", netResult: -1000)
        let Jun: Report = Report(day: "Jun", netResult: 2000)
        let Jul: Report = Report(day: "Jul", netResult: 800)
        let Aug: Report = Report(day: "Aug", netResult: -900)
        let Sep: Report = Report(day: "Sep", netResult: -2300)
        let Oct: Report = Report(day: "Oct", netResult: 1666)
        let Nov: Report = Report(day: "Nov", netResult: 2850)
        let Dec: Report = Report(day: "Dec", netResult: -980)
        return [Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec]
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
       
}
