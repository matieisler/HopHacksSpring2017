//
//  OnOffButton.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class OnOffButton: UIButton {
    var buttonState = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addTarget(self, action: #selector(OnOffButton.buttonPressed), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addTarget(self, action: #selector(OnOffButton.buttonPressed), for: .touchUpInside)
    }
    
    func buttonPressed() {
        if buttonState {
            buttonState = false
            self.backgroundColor = UIColor(colorLiteralRed: 198.0/255.0, green: 198.0/255.0, blue: 198.0/255.0, alpha: 1)
        } else {
            buttonState = true
            self.backgroundColor = UIColor(colorLiteralRed: 58.0/255.0, green: 71.0/255.0, blue: 89.0/255.0, alpha: 1)
        }
    }
    
}
