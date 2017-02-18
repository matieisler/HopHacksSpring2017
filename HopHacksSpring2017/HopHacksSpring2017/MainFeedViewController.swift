//
//  MainFeedViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/17/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "Main Feed"
        
        let dict: NSDictionary = ["user_id": "1"]
        Requests.sharedInstance.sendRequest(dict, action: "getMainFeed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalVariables.sharedInstance().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "mainFeedCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        self.performSegue(withIdentifier: "goToShowArticleSegue", sender: self)
    }

    
}


