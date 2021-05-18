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
    private let fetchTimeIntervalTableViewCellId = "fetchTimeIntervalTableViewCellId"
    private let displayModeTableViewCellId = "displayModeTableViewCellId"
    private var rssFeedKeyList: [String] = []
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LStrings.setting.value
        setUpTable()
        // テストのための設定
        view.accessibilityIdentifier = "setting_view"
        settingTableView.accessibilityIdentifier = "setting_table"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rssFeedKeySort()
        settingTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if CommonData.loginModel.userConfig.userID == nil { CommonRouter.toAuth(view: self)}
    }
    
    func setUpTable() {
        settingTableView.dataSource = self
        settingTableView.delegate = self
        settingTableView.register(UINib(nibName: "RssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        settingTableView.register(UINib(nibName: "AccountProperty", bundle: nil), forCellReuseIdentifier: accountPropertyTableViewCellId)
        settingTableView.register(UINib(nibName: "AddNewRssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: addNewCellId)
        settingTableView.register(UINib(nibName: "FetchTimeInterval", bundle: nil), forCellReuseIdentifier: fetchTimeIntervalTableViewCellId)
        settingTableView.register(UINib(nibName: "DisplayMode", bundle: nil), forCellReuseIdentifier: displayModeTableViewCellId)
    }
    func rssFeedKeySort() {
        rssFeedKeyList = CommonData.rssFeedListModel.rssFeedList.keys.sorted()
    }
    
}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return LStrings.accountProperty.value
        case 1:
            return LStrings.refreshInterval.value
        case 2:
            return LStrings.displayMode.value
        case 3:
            return LStrings.subscriptionArticles.value
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        4
    }
    
    // セクションヘッダーの色を変えられるようにしてます。
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = .init(named: "SectionHeader")
        
        let header = view as! UITableViewHeaderFooterView
        // テキスト色を変更する
        header.textLabel?.textColor = .init(named: "MainLabel")
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
            return 1
        case 3:
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
            
            // テストのための設定
            cell.accessibilityIdentifier = "setting_account_cell"
            cell.myImageView.isAccessibilityElement = true
            cell.myImageView.accessibilityIdentifier = "setting_account_image"
            cell.myDisplayNameLabel.accessibilityIdentifier = "setting_accountName_label"
            return cell
            
        case 1:
            let cell = settingTableView.dequeueReusableCell(withIdentifier: fetchTimeIntervalTableViewCellId, for: indexPath) as! FetchTimeIntervalTableViewCell
            cell.fetchTimeIntervalSegmentedControl.selectedSegmentIndex = CommonData.filterModel.fetchTimeInterval
            
            // テストのための設定
            cell.fetchTimeIntervalSegmentedControl.accessibilityIdentifier = "setting_timeInterval_segmentedControl"
            return cell
            
        case 2:
            let cell = settingTableView.dequeueReusableCell(withIdentifier: displayModeTableViewCellId, for: indexPath) as! DisplayModeTableViewCell
            cell.displayModeSegmentedControl.selectedSegmentIndex = CommonData.filterModel.displayMode.index
            
            // テストのための設定
            cell.displayModeSegmentedControl.accessibilityIdentifier = "setting_displayMode_segmentedControl"
            return cell
            
        case 3:
            if CommonData.rssFeedListModel.rssFeedList.count == indexPath.row {
                let cell = settingTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewRssFeedTableViewCell
                
                // テストのための設定
                cell.accessibilityIdentifier = "setting_addRssFeed_cell"
                return cell
            }
            
            let cell = settingTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RssFeedTableViewCell
            cell.rssFeed = CommonData.rssFeedListModel.rssFeedList[rssFeedKeyList[indexPath.row]]
            
            // テストのための設定
            cell.accessibilityIdentifier = "setting_rssFeed_cell"
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    // sectionが1の時だけ編集モードにしたい
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.section == 3 && indexPath.row < CommonData.rssFeedListModel.rssFeedList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 3:
            CommonData.rssFeedListModel.rssFeedList.removeValue(forKey: rssFeedKeyList[indexPath.row])
            rssFeedKeySort()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        default:
            return
        }
    }
    
    // MARK:- didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            
            CommonData.loginModel.toLogoutAlert(view: self)
        case 3:
            if indexPath.row == CommonData.rssFeedListModel.rssFeedList.count {
                CommonRouter.toSelectRssFeedTypeView(view: self)
            }
        default: break
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

extension SettingViewController: LogoutDelegate {
    func didLogout() {
        settingTableView.reloadData()
        CommonRouter.toAuth(view: self)
    }
}

