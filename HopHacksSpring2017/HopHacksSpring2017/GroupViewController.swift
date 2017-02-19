//
//  GroupViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    
    var group: Group!
    var misc: Misc!
    var image: UIImage!
    
    var mode = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch mode {
        case 0:
            (self.view.viewWithTag(1) as! UIImageView).image = image
            (self.view.viewWithTag(2) as! UILabel).text = group.name!
            (self.view.viewWithTag(3) as! UITextView).text = group.descript!
        case 1:
            (self.view.viewWithTag(1) as! UIImageView).image = image
            (self.view.viewWithTag(2) as! UILabel).text = misc.title
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            let dateString = formatter.string(from: misc.datePosted! as Date)
            (self.view.viewWithTag(4) as! UILabel).text = "\(formatter.string(from: date as Date))"
            (self.view.viewWithTag(3) as! UITextView).text = "Date Posted: \(dateString)\n\(misc.content)"
        default:
            break
        }
        
    }
    
}
