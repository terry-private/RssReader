//
//  SettingViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit
import Nuke

class SettingViewController: UIViewController, Transitioner {
    //MARK:- @IBOutlet
    
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK:- 変数宣言
    private let cellId = "cellId"
    private let addNewCellId = "addNewCellId"
    private let accountPropertyTableViewCellId = "accountPropertyTableViewCellId"
    private var rssFeedKeyList: [String] = []
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定"
        setUpTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        rssFeedKeySort()
    }
    
    func setUpTable() {
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.register(UINib(nibName: "RssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        settingTableView.register(UINib(nibName: "AccountProperty", bundle: nil), forCellReuseIdentifier: accountPropertyTableViewCellId)
        settingTableView.register(UINib(nibName: "AddNewRssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: addNewCellId)
    }
    func rssFeedKeySort() {
        rssFeedKeyList = CommonData.rssFeedListModel.rssFeedList.keys.sorted()
    }
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "アカウント情報"
        case 1:
            return "購読記事一覧"
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return CommonData.rssFeedListModel.rssFeedList.count + 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = settingTableView.dequeueReusableCell(withIdentifier: accountPropertyTableViewCellId, for: indexPath) as! AccountPropertyTableviewCell
            cell.userConfig = CommonData.loginModel.userConfig
            return cell
        case 1:
            if CommonData.rssFeedListModel.rssFeedList.count == indexPath.row {
                let cell = settingTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewRssFeedTableViewCell
                return cell
            }
            let cell = settingTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RssFeedTableViewCell
            cell.rssFeed = CommonData.rssFeedListModel.rssFeedList[rssFeedKeyList[indexPath.row]]
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // sectionが1の時だけ編集モードにしたい
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 1 && indexPath.row < CommonData.rssFeedListModel.rssFeedList.count
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            return
        case 1:
            CommonData.rssFeedListModel.rssFeedList.removeValue(forKey: rssFeedKeyList[indexPath.row])
            rssFeedKeySort()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            return
        case 1:
            if indexPath.row == CommonData.rssFeedListModel.rssFeedList.count {
                CommonRouter.toSelectRssFeedTypeView(view: self)
            }
            return
        default:
            return
        }
    }
    
}


extension SettingViewController: SelectRssFeedDelegate {
    func setRssFeed(rssFeed: RssFeedProtocol) {
        CommonData.rssFeedListModel.rssFeedList[rssFeed.url] = rssFeed
        rssFeedKeySort()
        settingTableView.reloadData()
    }
}
