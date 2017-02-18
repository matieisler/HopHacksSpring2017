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
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (self.view.viewWithTag(1) as! UIImageView).image = image
        (self.view.viewWithTag(2) as! UILabel).text = group.name!
        (self.view.viewWithTag(3) as! UITextView).text = group.descript!
    }
    
}
