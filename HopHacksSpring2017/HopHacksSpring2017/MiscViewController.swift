//
//  MiscViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/17/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class MiscViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var miscs = [Misc]()
    
    var selectedMisc = -1
    
    var freeAndForSaleButton: OnOffButton!
    var textbookExchangeButton: OnOffButton!
    var pickupSportsButton: OnOffButton!
    var rideshareButton: OnOffButton!
    var roommateSearchButton: OnOffButton!
    var entertainmentButton: OnOffButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationController?.navigationBar.topItem?.title = "Miscellaneous"
        
        NotificationCenter.default.addObserver(self, selector: #selector(MiscViewController.reloadData), name: NSNotification.Name(rawValue: "getMiscFinished"), object: nil)
        
        
        let defaults = UserDefaults.standard
        var prefs = ["free_and_for_sale", "textbook_exchange", "pickup_sports", "ride_share", "roommate_search", "entertainment"]
        if let storedArray = defaults.value(forKey: "miscPreferences") as? NSArray {
            prefs = storedArray as! [String]
        }
        
        let dict = ["types": prefs]
        
        

        Requests.sharedInstance.sendRequest(dict as NSDictionary, action: "getMisc")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return miscs.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 250
        }
        return GlobalVariables.sharedInstance().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell")!
            cell.selectionStyle = .none
            
            freeAndForSaleButton = cell.viewWithTag(1) as! OnOffButton
            textbookExchangeButton = cell.viewWithTag(2) as! OnOffButton
            pickupSportsButton = cell.viewWithTag(3) as! OnOffButton
            rideshareButton = cell.viewWithTag(4) as! OnOffButton
            roommateSearchButton = cell.viewWithTag(5) as! OnOffButton
            entertainmentButton = cell.viewWithTag(6)  as! OnOffButton
            
            freeAndForSaleButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            textbookExchangeButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            pickupSportsButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            rideshareButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            roommateSearchButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            entertainmentButton.addTarget(self, action: #selector(MiscViewController.reloadFromLocalDatabase), for: .touchUpInside)
            
            let defaults = UserDefaults.standard
            if let prefs = defaults.value(forKey: "miscPreferences") as? NSArray {
                if prefs.contains("free_and_for_sale") == false {
                    freeAndForSaleButton.setFalse()
                }
                if prefs.contains("textbook_exchange") == false {
                    textbookExchangeButton.setFalse()
                }
                if prefs.contains("pickup_sports") == false {
                    pickupSportsButton.setFalse()
                }
                if prefs.contains("ride_share") == false {
                    rideshareButton.setFalse()
                }
                if prefs.contains("roommate_search") == false {
                    roommateSearchButton.setFalse()
                }
                if prefs.contains("entertainment") == false {
                    entertainmentButton.setFalse()
                }
            }
            
            
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "miscCell")!
        (cell.viewWithTag(2) as! UILabel).text = miscs[indexPath.row - 1].title!
        (cell.viewWithTag(3) as! UILabel).text = miscs[indexPath.row - 1].content!
        
        DispatchQueue.main.async {
            let data = NSData(contentsOf: NSURL(string: self.miscs[indexPath.row - 1].imageURL!)! as URL)
            let title = self.miscs[indexPath.row - 1].imageURL!
            let image = UIImage(data: data! as Data)!
            (cell.viewWithTag(1) as! UIImageView).image = image
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        if indexPath.row != 0 {
            selectedMisc = indexPath.row
            self.performSegue(withIdentifier: "goToOrganizationSegue", sender: self)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        var selectedButtons = [String]()
        
        if freeAndForSaleButton.buttonState {
            selectedButtons.append("free_and_for_sale")
        }
        if textbookExchangeButton.buttonState {
            selectedButtons.append("textbook_exchange")
        }
        if pickupSportsButton.buttonState {
            selectedButtons.append("pickup_sports")
        }
        if rideshareButton.buttonState {
            selectedButtons.append("ride_share")
        }
        if roommateSearchButton.buttonState {
            selectedButtons.append("roommate_search")
        }
        if entertainmentButton.buttonState {
            selectedButtons.append("entertainment")
        }
        
        let defaults = UserDefaults.standard
        defaults.setValue(selectedButtons, forKey: "miscPreferences")
        defaults.synchronize()
        
        super.viewWillDisappear(animated)
    }
    
    func reloadData() {
        if let m = GlobalVariables.sharedInstance().receivedMisc {
            miscs = m
            tableView.reloadData()
        }
    }
    
    func reloadFromLocalDatabase() {
        var selectedButtons = [String]()
        
        if freeAndForSaleButton.buttonState {
            selectedButtons.append("free_and_for_sale")
        }
        if textbookExchangeButton.buttonState {
            selectedButtons.append("textbook_exchange")
        }
        if pickupSportsButton.buttonState {
            selectedButtons.append("pickup_sports")
        }
        if rideshareButton.buttonState {
            selectedButtons.append("ride_share")
        }
        if roommateSearchButton.buttonState {
            selectedButtons.append("roommate_search")
        }
        if entertainmentButton.buttonState {
            selectedButtons.append("entertainment")
        }
        
        var queryString = ""
        miscs = [Misc]()
        if selectedButtons.count > 0 {
            for i in 0...selectedButtons.count - 1 {
                let m = DatabaseManager.getFromDatabase(entityName: "Misc", predicateString: "postType = \"\(selectedButtons[i])\"") as! [Misc]
                miscs.append(contentsOf: m)
            }
        }
        tableView.reloadData()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! GroupViewController
        destination.mode = 1
        destination.misc = miscs[selectedMisc]
        destination.image = (tableView.cellForRow(at: IndexPath(row: selectedMisc, section: 0))?.viewWithTag(1) as! UIImageView).image!
    }
    
}

