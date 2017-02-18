//
//  GroupsViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/17/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit


class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var groups = [Group]()
    var selectedGroup = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.topItem?.title = "Groups"
        
        NotificationCenter.default.addObserver(self, selector: #selector(GroupsViewController.reloadData), name: NSNotification.Name(rawValue: "getGroupsFinished"), object: nil)
        
        let dict: NSDictionary = ["user_id": "1"]
        Requests.sharedInstance.sendRequest(dict, action: "getGroups")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalVariables.sharedInstance().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell")!
        (cell.viewWithTag(2) as! UILabel).text = groups[indexPath.row].name
        (cell.viewWithTag(3) as! UILabel).text = groups[indexPath.row].descript
        
        
        DispatchQueue.main.async {
            let data = NSData(contentsOf: NSURL(string: self.groups[indexPath.row].imageURL!)! as URL)
            let image = UIImage(data: data! as Data)!
            (cell.viewWithTag(1) as! UIImageView).image = image
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        selectedGroup = indexPath.row
        self.performSegue(withIdentifier: "goToOrganizationSegue", sender: self)
    }
    
    func reloadData() {
        groups = GlobalVariables.sharedInstance().receivedGroups!
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! GroupViewController).group = groups[selectedGroup]
        (segue.destination as! GroupViewController).image = (tableView.cellForRow(at: IndexPath(row: selectedGroup, section: 0))?.viewWithTag(1) as! UIImageView).image!
    }
    
}

