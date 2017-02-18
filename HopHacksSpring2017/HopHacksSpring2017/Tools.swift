//
//  Tools.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import Foundation

class Tools {
    class func dateArrayFromDateTime(_ datetime: String) -> [String] {
        let dateTimeArray = datetime.characters.split{$0 == " "}.map(String.init)
        let dateArray = dateTimeArray[0].characters.split{$0 == "-"}.map(String.init)
        let timeArray = dateTimeArray[1].characters.split{$0 == ":"}.map(String.init)
        var returnArray = [String]()
        for item in dateArray {
            returnArray.append(item)
        }
        for item in timeArray {
            returnArray.append(item)
        }
        return returnArray
    }
    
    class func dateTimeToNSDate(dateTime: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let datePublished = dateFormatter.date(from: dateTime) {
            return datePublished
        }
        return nil
    }
}
