//
//  ArticleListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import UIKit
import Firebase
import FirebaseUI

class ArticleListViewController: UIViewController, Transitioner {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad")
        // Do any additional setup after loading the view.
    }
    @IBAction func tappedButton(_ sender: Any) {
        UserConfig().removeUser()
        dismiss(animated: true, completion: nil)
    }

}
