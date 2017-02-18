//
//  GlobalVariables.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit


private let _globalVariablesInstance : GlobalVariables = { GlobalVariables() } ();

class GlobalVariables {
    
    let server = "http://10.189.91.61:5000"

    let rowHeight = CGFloat(200.0)
    
    class func sharedInstance() -> GlobalVariables {
        return _globalVariablesInstance;
    }
}