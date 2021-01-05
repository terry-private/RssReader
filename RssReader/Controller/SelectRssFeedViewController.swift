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
    private var selectRssFeedModel: SelectRssFeedModelProtocol?
    private var cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }
    
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
        selectRssFeedTableView.allowsMultipleSelection = true
    }
    
    func inject(selectRssFeedRouter: SelectRssFeedRouterProtocol, selectRssFeedModel: SelectRssFeedModelProtocol) {
        self.selectRssFeedRouter = selectRssFeedRouter
        self.selectRssFeedModel = selectRssFeedModel
    }
    
    
    

}

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectRssTableViewCell
        cell.rssFeedTitleLabel?.text = "sample"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .none
    }
    
}



class SelectRssTableViewCell: UITableViewCell {
    @IBOutlet weak var rssFeedTitleLabel: UILabel!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
