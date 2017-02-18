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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        (self.view.viewWithTag(2) as! UILabel).text = article.title
        (self.view.viewWithTag(3) as! UIButton).setTitle(article.publisherName, for: .normal)
        (self.view.viewWithTag(5) as! UITextView).text = article.content
    }
    
}
