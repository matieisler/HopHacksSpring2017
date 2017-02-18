//
//  EventsViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/17/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var events = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "Events"
        
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.reloadData), name: NSNotification.Name(rawValue: "getEventsFinished"), object: nil)
        
        let dict: NSDictionary = ["start_date": "2017-02-16", "end_date": "2017-02-20"]
        Requests.sharedInstance.sendRequest(dict, action: "getEvents")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalVariables.sharedInstance().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "eventCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        self.performSegue(withIdentifier: "goToOrganizationSegue", sender: self)
    }
    
    func reloadData() {
        if let _ = GlobalVariables.sharedInstance().receivedEvents {
            events = GlobalVariables.sharedInstance().receivedEvents!
            tableView.reloadData()
        }
    }

    
}

