//
//  MainFeedViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/17/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class MainFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var barItem: UITabBarItem!
    
    var articles = [Article]()
    var articleToSend = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        self.navigationController?.navigationBar.topItem?.title = "Main Feed"
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainFeedViewController.reloadData), name: NSNotification.Name(rawValue: "getMainFeedFinished"), object: nil)
        
        let dict: NSDictionary = ["user_id": "1"]
        Requests.sharedInstance.sendRequest(dict, action: "getMainFeed")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return GlobalVariables.sharedInstance().rowHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainFeedCell")!
        (cell.viewWithTag(2) as! UILabel).text = articles[indexPath.row].title
        (cell.viewWithTag(3) as! UILabel).text = articles[indexPath.row].content
        
        
        DispatchQueue.main.async {
            let data = NSData(contentsOf: NSURL(string: self.articles[indexPath.row].imageURL!)! as URL)
            let image = UIImage(data: data! as Data)!
            (cell.viewWithTag(1) as! UIImageView).image = image
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.setSelected(false, animated: false)
        articleToSend = indexPath.row
        self.performSegue(withIdentifier: "goToShowArticleSegue", sender: self)
    }
    
    func reloadData() {
        articles = DatabaseManager.getFromDatabase(entityName: "Article") as! [Article]
        tableView.reloadData()
    }
    
    func loadImage() {
        var image = UIImage(named: "Badge")
        let widthHeightRatio = (image?.size.width)! / (image?.size.height)!
        let height = self.tabBarController!.tabBar.frame.height * 1.3
        let width = height * widthHeightRatio
        UIGraphicsBeginImageContext(CGSize(width: width, height: height))
        image!.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let screenHeight = UIScreen.main.bounds.height
        //barItem.imageInsets = UIEdgeInsetsMake(screenHeight/100, -6, -screenHeight/100, 6)
        barItem.image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        barItem.selectedImage = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        barItem.title = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ArticleViewController
        destination.article = articles[articleToSend]
        destination.mode = 0
        destination.image = (tableView.cellForRow(at: IndexPath(row: articleToSend, section: 0))?.viewWithTag(1) as! UIImageView).image
    }

    
}


