//
//  HistoryTableViewController.swift
//  PokerResultsTracker
//
//  Created by Yusen Wang on 11/27/19.
//  Copyright © 2019 Yusen Wang. All rights reserved.
//

import UIKit

//Customized table view for showing poker session histories
class HistorySessionsVC: UIViewController {

    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
        
    }
    
    func configureTableView(){
        view.addSubview(tableView)
        //set delegates
        setTableViewDelegates()
        //set row height
        tableView.rowHeight = 100
        //register cells
        
        //set constraints
        tableView.pin(to: view )
    }
    func setTableViewDelegates(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension HistorySessionsVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
