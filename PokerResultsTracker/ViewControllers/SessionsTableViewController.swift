//
//  SessionsTableViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/27/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

class SessionsTableViewController: UIViewController {

    var tableView = UITableView()
    var sessions:[Session] = []
    let cellSpacingHeight: CGFloat = 60
    let sessionTitle = "History"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let session1 = Session(sessionImage: UIImage(named: "poker-background")!, title: "Test my table list")
        let session2 = Session(sessionImage: UIImage(named: "poker-background")!, title: "Test my table list1")
        let session3 = Session(sessionImage: UIImage(named: "poker-background")!, title: "Test my table list1")
        sessions.append(session1)
        sessions.append(session2)
        sessions.append(session3)
        
        configureTableView()
        // Do any additional setup after loading the view.
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        setTableViewDelegates()
        tableView.rowHeight = 100
        tableView.register(SessionCell.self, forCellReuseIdentifier: "SessionCell")
        tableView.pin(to: view)
        tableView.backgroundColor = UIColor(red:38/255, green:40/255, blue:52/255, alpha:1)
    }
    
    func setTableViewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SessionsTableViewController: UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sessions.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SessionCell") as! SessionCell
        let session = sessions[indexPath.section]
        print("test", indexPath.section)
        cell.set(session:session)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView(frame:CGRect (x: 0, y: 0, width: 320, height: 20) ) as UIView
        view.backgroundColor = UIColor(red:38/255, green:40/255, blue:52/255, alpha:1)
        return view
    }
    
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 100
//    }
//
}
