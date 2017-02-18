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
    
    
    let server = GlobalVariables.sharedInstance().server
    var data = NSMutableData();
    
    
    fileprivate override init(){
        childObjectContext.parent = managedObjectContext
    }
    
    
    func sendRequest(_ jsonDict:NSDictionary, action:String ){
        currentConnectionString = action;
        let request = NSMutableURLRequest(url: URL(string: "\(server)/\(action)")!);
        print("\(server)/\(action)")
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
                }
            }
                
            else if (status == "error") {
                if connection == getMainFeed {
                    sendErrorNotification(responseDict, name: "getMainFeedFailed")
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
        if let data = responseDict["data"] as? NSDictionary {
            
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
