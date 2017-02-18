//
//  ArticleViewController.swift
//  HopHacksSpring2017
//
//  Created by Matias Eisler on 2/18/17.
//  Copyright © 2017 Matias Eisler. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    var article: Article!
    var event: Event!
    var image: UIImage?
    var mode = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        switch mode {
            //0 for article, 1 for event
        case 0:
            (self.view.viewWithTag(2) as! UILabel).text = article.title
            (self.view.viewWithTag(3) as! UIButton).setTitle(article.publisherName, for: .normal)
            let date = article.datePublished!
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            (self.view.viewWithTag(4) as! UILabel).text = "\(formatter.string(from: date as Date))"
            (self.view.viewWithTag(5) as! UITextView).text = article.content
            
            if let _ = image {
                (self.view.viewWithTag(1) as! UIImageView).image = image!
            } else {
                DispatchQueue.main.async {
                    let data = NSData(contentsOf: NSURL(string: self.article.imageURL!) as! URL)
                    let image = UIImage(data: data! as Data)!
                    (self.view.viewWithTag(1) as! UIImageView).image = image
                }
            }
        case 1:
            (self.view.viewWithTag(2) as! UILabel).text = event.title
            (self.view.viewWithTag(3) as! UIButton).setTitle(event.host, for: .normal)
            let date = event.startDate!
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            (self.view.viewWithTag(4) as! UILabel).text = "\(formatter.string(from: date as! Date))  @ \(event.location!)"
            (self.view.viewWithTag(5) as! UITextView).text = event.info!
            
            if let _ = image {
                (self.view.viewWithTag(1) as! UIImageView).image = image!
            } else {
                DispatchQueue.main.async {
                    let data = NSData(contentsOf: NSURL(string: self.event.imageURL!) as! URL)
                    let image = UIImage(data: data! as Data)!
                    (self.view.viewWithTag(1) as! UIImageView).image = image
                }
            }
        default:
            break
        }
        
        
        
        self.navigationController?.navigationBar.topItem?.title = "Articles"
    }
    
}
