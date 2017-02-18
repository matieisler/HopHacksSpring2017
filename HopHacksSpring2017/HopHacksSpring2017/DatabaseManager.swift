//
//  DatabaseManager.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    
    //returns all database objects from the given entity that comply with the predicate string
    
    class func getFromDatabase(entityName:String, predicateString:String="", sortDescriptors:Dictionary<String,Bool>=Dictionary<String,Bool>()) ->[AnyObject]{
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        var finalPredicate:String
        if (predicateString == "") {
            finalPredicate = predicateString + "modelDeleted = 0";
        } else {
            finalPredicate = predicateString + " && modelDeleted = 0";
        }
        
        let resultPredicate = NSPredicate(format: finalPredicate);
        request.predicate=resultPredicate;
        
        var sortDescriptorsArray:[NSSortDescriptor]=[NSSortDescriptor]();
        for item in sortDescriptors{
            let sortDescriptor = NSSortDescriptor(key: item.0, ascending: item.1);
            sortDescriptorsArray.append(sortDescriptor);
        }
        if(sortDescriptorsArray.count != 0){
            request.sortDescriptors = sortDescriptorsArray;
        }
        return try! (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext.fetch(request) as [AnyObject]
    }
    
    class func getItem(entityName:String, predicateString:String, sortDescriptors:Dictionary<String,Bool>=Dictionary<String,Bool>()) ->AnyObject? {
        let objectArray = self.getFromDatabase(entityName: entityName, predicateString: predicateString,sortDescriptors: sortDescriptors);
        if objectArray.count > 0 {
            return objectArray[0]
        } else {
            return nil
        }
        
        
    }
    
    //insert and return an object
    class func insertObject(entityName:String)->AnyObject {
        let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: managedObjectContext)
        
    }
    
}

