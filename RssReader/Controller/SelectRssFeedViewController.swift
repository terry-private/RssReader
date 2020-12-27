//
//  SelectRssFeedViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/27.
//

import UIKit

protocol SelectRssFeedViewProtocol: Transitioner {
    
}

class SelectRssFeedViewController: UIViewController, SelectRssFeedViewProtocol {

    private var selectRssFeedRouter: SelectRssFeedRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func inject(selectRssFeedRouter: SelectRssFeedRouterProtocol) {
        self.selectRssFeedRouter = selectRssFeedRouter
    }
    
    @IBAction func tappedSelectButton(_ sender: Any) {
        selectRssFeedRouter?.toArticleListView()
    }
    

}
