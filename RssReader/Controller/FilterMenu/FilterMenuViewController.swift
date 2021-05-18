//
//  FilterMenuViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/25.
//

import UIKit

class FilterMenuViewController: UIViewController, Transitioner {
    @IBOutlet weak var filterMenuListTableView: UITableView!
    private var rssFeedKeyList: [String] = []
    private let containReadTableViewCellId = "containReadTableViewCellId"
    private let sortTypeTableViewCellId = "sortTypeTableViewCellId"
    private let orderByTableViewCellId = "orderByTableViewCellId"
    private let pubDateAfterTableViewCellId = "pubDateAfterTableViewCellId"
    private let rssFeedDisplayTableViewCellId = "rssFeedDisplayTableViewCellId"
    
    weak var articleKeySortable: KeysSortable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        rssFeedKeyList = CommonData.rssFeedListModel.rssFeedList.keys.sorted()
        
        // テストのための設定
        view.accessibilityIdentifier = "filterMenu_view"
        
    }
    func setUpTable() {
        filterMenuListTableView.delegate = self
        filterMenuListTableView.dataSource = self
        filterMenuListTableView.register(UINib(nibName: "SortTypeTableViewCell", bundle: nil), forCellReuseIdentifier: sortTypeTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "ContainReadTableViewCell", bundle: nil), forCellReuseIdentifier: containReadTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "OrderByTableViewCell", bundle: nil), forCellReuseIdentifier: orderByTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "PubDateAfterTableViewCell", bundle: nil), forCellReuseIdentifier: pubDateAfterTableViewCellId)
        filterMenuListTableView.register(UINib(nibName: "RssFeedDisplayTableViewCell", bundle: nil), forCellReuseIdentifier: rssFeedDisplayTableViewCellId)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        articleKeySortable?.keysSort()
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
            return LStrings.sort.value
        case 1:
            return LStrings.displayOfRead.value
        case 2:
            return LStrings.daysOfDisplay.value
        case 3:
            return LStrings.displayArticle.value
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
    
    // セクションヘッダーの色を変えられるようにしてます。
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = .init(named: "SectionHeader")
        
        let header = view as! UITableViewHeaderFooterView
        // テキスト色を変更する
        header.textLabel?.textColor = .init(named: "MainLabel")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: sortTypeTableViewCellId) as! SortTypeTableViewCell
                cell.sortTypeSegmentedControl.selectedSegmentIndex = CommonData.filterModel.sortType.index
                
                // テストのための設定
                cell.sortTypeSegmentedControl.accessibilityIdentifier = "filterMenu_sortType_segmentedControl"
                
                return cell
                
            } else {
                let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: orderByTableViewCellId) as! OrderByTableViewCell
                if CommonData.filterModel.orderByDesc {
                    cell.orderBySegmentedControl.selectedSegmentIndex = 0
                } else {
                    cell.orderBySegmentedControl.selectedSegmentIndex = 1
                }
                
                // テストのための設定
                cell.orderBySegmentedControl.accessibilityIdentifier = "filterMenu_orderBy_segmentedControl"
                
                return cell
                
            }
        case 1:
            let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: containReadTableViewCellId) as! ContainReadTableViewCell
            cell.readSwitch.setOn(CommonData.filterModel.containRead, animated: false)
            
            // テストのための設定
            cell.accessibilityIdentifier = "filterMenu_containRead_switch"
            
            return cell
            
        case 2:
            let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: pubDateAfterTableViewCellId) as! PubDateAfterTableViewCell
            cell.pubDateAfterSegmentedControl.selectedSegmentIndex = CommonData.filterModel.pubDateAfter - 1
            
            // テストのための設定
            cell.pubDateAfterSegmentedControl.accessibilityIdentifier = "filterMenu_pubDateAfter_segmentedControl"
            
            return cell
            
        case 3:
            let cell = filterMenuListTableView.dequeueReusableCell(withIdentifier: rssFeedDisplayTableViewCellId) as! RssFeedDisplayTableViewCell
            cell.rssFeedKey = rssFeedKeyList[indexPath.row]
            
            // テストのための設定
            cell.accessibilityIdentifier = "filterMenu_rssFeed_cell"
            
            return cell
            
        default:
            return UITableViewCell()
        }
        
    }
}
