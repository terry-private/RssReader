//
//  SettingViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit
import FirebaseUI
import Nuke

class SettingViewController: UIViewController, Transitioner {
    //MARK:- @IBOutlet
    
    @IBOutlet weak var settingTableView: UITableView!
    
    //MARK:- 変数宣言
    private let cellId = "cellId"
    private let addNewCellId = "addNewCellId"
    private let accountPropertyTableViewCellId = "accountPropertyTableViewCellId"
    private let fetchTimeIntervalTableViewCellId = "fetchTimeIntervalTableViewCellId"
    private var rssFeedKeyList: [String] = []
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "設定"
        setUpTable()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rssFeedKeySort()
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
            return "RSS取得間隔"
        case 2:
            return "購読記事一覧"
        default:
            return ""
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        case 2:
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
            let cell = settingTableView.dequeueReusableCell(withIdentifier: fetchTimeIntervalTableViewCellId, for: indexPath) as! FetchTimeIntervalTableViewCell
            cell.fetchTimeIntervalSegmentedControl.selectedSegmentIndex = CommonData.filterModel.fetchTimeInterval
            return cell
        case 2:
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
    
    // MARK:- didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section{
        case 0:
            CommonData.loginModel.toLogoutAlert(view: self)
        case 1:
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


extension SettingViewController: FUIAuthDelegate {
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        if let newUser = user {
            
            // 登録済みのユーザーの場合
            if newUser.uid == CommonData.loginModel.userConfig.userID {
                print("Log in!!")
                CommonData.loginModel.userConfig.latestLoginDate = Date()
                settingTableView.reloadData()
                return
            }
            
            // 新規ユーザーの場合
            print("Sign up!!")
            CommonData.loginModel.setUserConfig(userID: newUser.uid, photoURL: newUser.photoURL, displayName: newUser.displayName ?? "")
            settingTableView.reloadData()
            return
            
        }
        
        //失敗した場合
        print("can't auth")
        CommonRouter.toAuth(view: self)
    }
}
