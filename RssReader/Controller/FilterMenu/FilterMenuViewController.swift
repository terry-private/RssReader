//
//  FilterMenuViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/25.
//

import UIKit

class FilterMenuViewController: UIViewController, Transitioner {
    @IBOutlet weak var filterMenuListTableView: UITableView!
    
    private let containReadTableViewCellId = "containReadTableViewCellId"
    private let sortTypeTableViewCellId = "sortTypeTableViewCellId"
    private let orderByTableViewCell = "orderByTableViewCell"
    private let pubDateAfterTableViewCell = "pubDateAfterTableViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }
    func setUpTable() {
        filterMenuListTableView.delegate = self
        filterMenuListTableView.dataSource = self
        filterMenuListTableView.register(UINib(nibName: "SortTypeTableViewCell", bundle: nil), forCellReuseIdentifier: sortTypeTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "ContainReadTableViewCell", bundle: nil), forCellReuseIdentifier: containReadTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "OrderByTableViewCell", bundle: nil), forCellReuseIdentifier: orderByTableViewCell)
        filterMenuListTableView.register(UINib(nibName: "PubDateAfterTableViewCell", bundle: nil), forCellReuseIdentifier: pubDateAfterTableViewCell)
    }
}
extension FilterMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "ソート"
        case 1:
            return "既読の表示"
        case 2:
            return "表示日数"
        case 3:
            return "購読記事の表示"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1...2:
            return 1
        case 3:
            return CommonData.rssFeedListModel.rssFeedList.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: sortTypeTableViewCellId) as! SortTypeTableViewCell
                return cell
            } else {
                let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: orderByTableViewCell) as! OrderByTableViewCell
                return cell
            }
        case 1:
            let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: containReadTableViewCellId) as! ContainReadTableViewCell
            return cell
        case 2:
            let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: pubDateAfterTableViewCell) as! PubDateAfterTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
