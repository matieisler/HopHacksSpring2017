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
        
        NotificationCenter.default.addObserver(self, selector: #selector(EventsViewController.reloadData), name: NSNotification.Name(rawValue: "getMiscFinished"), object: nil)
        
        
        var dict: NSMutableDictionary = NSMutableDictionary()
        let defaults = UserDefaults.standard
        if let prefs = defaults.value(forKey: "miscPreferences") as? NSArray {
            dict.setValue(prefs, forKey: "types")
        }
        Requests.sharedInstance.sendRequest(dict, action: "getMisc")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
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
            
            let defaults = UserDefaults.standard
            if let prefs = defaults.value(forKey: "miscPreferences") as? NSArray {
                if prefs.contains("free_and_for_sale") == false {
                    freeAndForSaleButton.buttonPressed()
                }
                if prefs.contains("textbook_exchange") == false {
                    textbookExchangeButton.buttonPressed()
                }
                if prefs.contains("pickup_sports") == false {
                    pickupSportsButton.buttonPressed()
                }
                if prefs.contains("ride_share") == false {
                    rideshareButton.buttonPressed()
                }
                if prefs.contains("roommate_search") == false {
                    roommateSearchButton.buttonPressed()
                }
                if prefs.contains("entertainment") == false {
                    entertainmentButton.buttonPressed()
                }
            }
            
            
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "miscCell")!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        if indexPath.row != 0 {
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
        
        super.viewWillDisappear(animated)
    }
    
}

