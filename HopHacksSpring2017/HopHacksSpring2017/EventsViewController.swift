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
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "Events"
        
        self.tableView.separatorStyle = .none
        
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell")!
        (cell.viewWithTag(2) as! UILabel).text = events[indexPath.row].title!
        (cell.viewWithTag(3) as! UILabel).text = events[indexPath.row].info!
        let date = events[indexPath.row].startDate
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        (cell.viewWithTag(4) as! UILabel).text = "\(formatter.string(from: date as! Date))  @ \(events[indexPath.row].location!)"
        print(events[indexPath.row].info!)
        
        DispatchQueue.main.async {
            let data = NSData(contentsOf: NSURL(string: self.events[indexPath.row].imageURL!)! as URL)
            let image = UIImage(data: data! as Data)!
            (cell.viewWithTag(1) as! UIImageView).image = image
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        selectedIndex = indexPath.row
        self.performSegue(withIdentifier: "goToShowArticleSegue", sender: self)
    }
    
    func reloadData() {
        if let _ = GlobalVariables.sharedInstance().receivedEvents {
            events = GlobalVariables.sharedInstance().receivedEvents!
            tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ArticleViewController
        destination.event = events[selectedIndex]
        destination.mode = 1
    }

    
}

