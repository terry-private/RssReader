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

    @IBOutlet weak var selectRssFeedTableView: UITableView!
    private var selectRssFeedRouter: SelectRssFeedRouterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    func inject(selectRssFeedRouter: SelectRssFeedRouterProtocol) {
        self.selectRssFeedRouter = selectRssFeedRouter
    }
    
    
    

}

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
