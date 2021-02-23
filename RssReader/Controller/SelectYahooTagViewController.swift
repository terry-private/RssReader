//
//  SelectYahooTagViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/23.
//

import UIKit

protocol SelectYahooTagViewControllerProtocol: Transitioner {
    
}

class SelectYahooTagViewController: UIViewController, Transitioner {
    @IBOutlet weak var yahooTagTableView: UITableView!
    private let cellId = "cellId"
    private var feedList: [ArticleList]?
    override func viewDidLoad() {
        super.viewDidLoad()
        yahooTagTableView.delegate = self
        yahooTagTableView.dataSource = self
    }
}
extension SelectYahooTagViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        YahooTag.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = yahooTagTableView.dequeueReusableCell(withIdentifier: cellId) as! YahooTagTableViewCell
        YahooTag.allCases[indexPath.row]
        return cell
    }
    
    
}

class YahooTagTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
