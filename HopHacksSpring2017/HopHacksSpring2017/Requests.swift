//
//  Requests.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit
import CoreData

private let _requestsInstance : Requests = { Requests() }();


class Requests:NSObject,NSURLConnectionDelegate{
    
    static let sharedInstance = Requests()
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let childObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
    var isSyncing = false
    var currentConnectionString:String?;
    
    var getMainFeed: NSURLConnection?
    var getEvents: NSURLConnection?
    var getGroups: NSURLConnection?
    var getMisc: NSURLConnection?
    var getUser: NSURLConnection?
    
    
    let server = GlobalVariables.sharedInstance().server
    var data = NSMutableData();
    
    
    fileprivate override init(){
        childObjectContext.parent = managedObjectContext
    }
    
    
    func sendRequest(_ jsonDict:NSDictionary, action:String ){
        currentConnectionString = action;
        let request = NSMutableURLRequest(url: URL(string: "\(server)/\(action)")!);
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: jsonDict, options: [])
        } catch _ as NSError {
            
            request.httpBody = nil
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //request.setValue("", forHTTPHeaderField: "Accept-Encoding")
        switch (action) {
        case "getMainFeed":
            getMainFeed = NSURLConnection(request: request as URLRequest, delegate: self)
        case "getEvents":
            getEvents = NSURLConnection(request: request as URLRequest, delegate: self)
        case "getGroups":
            getGroups = NSURLConnection(request: request as URLRequest, delegate: self)
        case "getMisc":
            getMisc = NSURLConnection(request: request as URLRequest, delegate: self)
        case "getUser":
            getUser = NSURLConnection(request: request as URLRequest, delegate: self)
        default:
            break;
        }
    }
    
    func logError(_ error:String){
        NSLog(error);
        
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveResponse response: URLResponse!) {
        data = NSMutableData()
    }
    
    func connection(_ connection: NSURLConnection!, didReceiveData data: Data!) {
        self.data.append(data);
    }
    
    
    
    func connectionDidFinishLoading(_ connection: NSURLConnection) {
        
        
        do {
            
            let responseDict = try JSONSerialization.jsonObject(with: data as Data, options: []) as! NSDictionary
            
            let status = responseDict.value(forKey: "status") as! String;
            
            if (status == "ok") {
                if connection == getMainFeed {
                    getMainFeed(responseDict)
                } else if connection == getEvents {
                    getEvents(responseDict)
                } else if connection == getGroups {
                    getGroups(responseDict)
                } else if connection == getMisc {
                    getMisc(responseDict)
                } else if connection == getUser {
                    getUser(responseDict)
                }
            }
                
            else if (status == "error") {
                if connection == getMainFeed {
                    sendErrorNotification(responseDict, name: "getMainFeedFailed")
                } else if connection == getEvents {
                    sendErrorNotification(responseDict, name: "getEventsFailed")
                } else if connection == getGroups {
                    sendErrorNotification(responseDict, name: "getGroupsFailed")
                } else if connection == getMisc {
                    sendErrorNotification(responseDict, name: "getMiscFailed")
                } else if connection == getUser {
                    sendErrorNotification(responseDict, name: "getUserFailed")
                }
                
            }
            
        } catch {
            
            print("\(error)");
            let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)!;
            print(jsonString)
        }
    }
    
    
    
    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
        let errorDict: Dictionary<String,String>! = [
            "errorMessage": "Couldn't contact the server.",
            ]
        if connection == getMainFeed {
            sendErrorNotification(errorDict as NSDictionary, name: "getMainFeedFailed");
        } else if connection == getEvents {
            sendErrorNotification(errorDict as NSDictionary, name: "getEventsFailed")
        } else if connection == getGroups {
            sendErrorNotification(errorDict as NSDictionary, name: "getGroupsFailed")
        } else if connection == getMisc {
            sendErrorNotification(errorDict as NSDictionary, name: "getMiscFailed")
        } else if connection == getUser {
            sendErrorNotification(errorDict as NSDictionary, name: "getUserFailed")
        }
        
    }
    
    func convertStringToDictionary(_ text: String) -> NSArray? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSArray
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    func getMainFeed(_ responseDict: NSDictionary) {
        if let data = responseDict["data"] as? NSArray {
            for art in data {
                let articleDict = art as! NSDictionary
                let content = articleDict["content"] as! String
                let id = articleDict["id"] as! Int
                let title = articleDict["title"] as! String
                let publisherName = articleDict["publisher_name"] as! String
                let imageURL = articleDict["image_url"] as! String
                if DatabaseManager.getItem(entityName: "Article", predicateString: "id=\(id)") == nil {
                    let article = DatabaseManager.insertObject(entityName: "Article") as! Article
                    article.id = Int16(id)
                    article.content = content
                    article.title = title
                    article.publisherName = publisherName
                    article.modelDeleted = false
                    article.imageURL = imageURL
                    article.datePublished = Tools.dateTimeToNSDate(dateTime: articleDict["date_published"] as! String) as NSDate?
                }
            }
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getMainFeedFinished"), object: nil)
            
            try! managedObjectContext.save()
        }
    }
    
    func getEvents(_ responseDict: NSDictionary) {
        if let data = responseDict["data"] as? NSArray {
            let globalVars = GlobalVariables.sharedInstance()
            globalVars.receivedEvents = [Event]()
            for ev in data {
                let eventDict = ev as! NSDictionary
                if DatabaseManager.getItem(entityName: "Event", predicateString: "id=\(eventDict["id"] as! Int16)") == nil {
                    let event = DatabaseManager.insertObject(entityName: "Event") as! Event
                    event.id = eventDict["id"] as! Int16
                    event.host = eventDict["host_name"] as! String
                    event.location = eventDict["location"] as! String
                    //event.startDate = eventDict["start_date"] as! String
                    event.startDate = Tools.dateTimeToNSDate(dateTime: eventDict["start_date"] as! String) as NSDate?
                    event.title = eventDict["title"] as! String
                    event.modelDeleted = false
                    event.info = eventDict["info_file"] as! String
                    event.imageURL = eventDict["image_url"] as! String
                    globalVars.receivedEvents?.append(event)
                } else {
                    globalVars.receivedEvents?.append(DatabaseManager.getItem(entityName: "Event", predicateString: "id=\(eventDict["id"] as! Int16)") as! Event)
                }
            }
            try! managedObjectContext.save()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getEventsFinished"), object: nil)
    }
    
    
    func getMisc(_ responseDict: NSDictionary) {
        if let data = responseDict["data"] as? NSArray {
            let globalVars = GlobalVariables.sharedInstance()
            globalVars.receivedMisc = [Misc]()
            for element in data {
                let miscDict = element as! NSDictionary
                if DatabaseManager.getItem(entityName: "Misc", predicateString: "id=\(miscDict["id"] as! Int16)") == nil {
                    let misc = DatabaseManager.insertObject(entityName: "Misc") as! Misc
                    misc.id = miscDict["id"] as! Int16
                    misc.title = miscDict["title"] as! String
                    misc.content = miscDict["content"] as! String
                    misc.imageURL = miscDict["image_url"] as! String
                    misc.postType = miscDict["post_type"] as! String
                    misc.userID = miscDict["user_id"] as! Int16
                    misc.datePosted = Tools.dateTimeToNSDate(dateTime: miscDict["date_posted"] as! String)! as NSDate?
                    misc.modelDeleted = false
                    globalVars.receivedMisc?.append(misc)
                } else {
                    globalVars.receivedMisc?.append(DatabaseManager.getItem(entityName: "Misc", predicateString: "id=\(miscDict["id"] as! Int16)") as! Misc)
                }
            }
            
            try! managedObjectContext.save()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getMiscFinished"), object: nil)
    }
    
    func getGroups(_ responseDict: NSDictionary) {
        if let data = responseDict["data"] as? NSArray {
            let globalVars = GlobalVariables.sharedInstance()
            globalVars.receivedGroups = [Group]()
            for group in data {
                let groupDict = group as! NSDictionary
                if DatabaseManager.getItem(entityName: "Group", predicateString: "id=\(groupDict["group_id"] as! Int16)") == nil {
                    let group = DatabaseManager.insertObject(entityName: "Group") as! Group
                    group.id = groupDict["group_id"] as! Int16
                    group.name = groupDict["group_name"] as! String
                    group.phone = groupDict["phone"] as! String
                    group.email = groupDict["email"] as! String
                    group.typeName = groupDict["group_type_name"] as! String
                    group.imageURL = groupDict["image_url"] as! String
                    group.descript = groupDict["description"] as! String
                    globalVars.receivedGroups?.append(group)
                } else {
                    globalVars.receivedGroups?.append(DatabaseManager.getItem(entityName: "Group", predicateString: "id=\(groupDict["group_id"] as! Int16)") as! Group)
                }
            }
            try! managedObjectContext.save()
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getGroupsFinished"), object: nil)
    }
    
    func getUser(_ responseDict: NSDictionary) {
        if let data = responseDict["data"] as? NSArray {
            
        }
    }
    
    
    func sendErrorNotification(_ responseDict:NSDictionary, name:String){
        let errorMessage = responseDict.value(forKey: "errorMessage") as! String;
        let errorDict: Dictionary<String,String>! = [
            "error": errorMessage,
            ]
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: self, userInfo: errorDict)
    }
}
