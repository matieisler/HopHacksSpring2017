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
    
    //let server = "http://10.189.23.24:5000"
    let server = "http://127.0.0.1:5000"
    
    let rowHeight = CGFloat(200.0)
    var receivedEvents: [Event]?
    
    class func sharedInstance() -> GlobalVariables {
        return _globalVariablesInstance;
    }
}
