//
//  SelectRssFeedViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/27.
//

import UIKit
import Nuke

protocol SelectRssFeedViewProtocol: Transitioner {
    
}

class SelectRssFeedViewController: UIViewController, SelectRssFeedViewProtocol {
    //MARK:- @IBOutlet
    
    @IBOutlet weak var subscribeToLabel: UILabel!
    @IBOutlet weak var selectRssFeedTableView: UITableView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var formOfRssFeed: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK:- 変数宣言
    private var rssFeedKeyList: [String] = []
    private let cellId = "cellId"
    private let addNewCellId = "addNewCellId"
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setAccessibilityIdentifier()
        setLocalizableStrings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rssFeedKeySort()
    }
    
    // UITestにおいてXCUIElementを特定するために使います。
    func setAccessibilityIdentifier() {
        view.accessibilityIdentifier = "selectRssFeed_view"
        selectRssFeedTableView.accessibilityIdentifier = "selectRssFeed_table"
        selectedCountLabel.accessibilityIdentifier = "selectRssFeed_selectedCount_label"
        confirmButton.accessibilityIdentifier = "selectRssFeed_confirm_button"
    }
    
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
        selectRssFeedTableView.register(UINib(nibName: "RssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        selectRssFeedTableView.register(UINib(nibName: "AddNewRssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: addNewCellId)
    }
    
    private func setLocalizableStrings() {
        subscribeToLabel.text = LStrings.subscribeTo
        confirmButton.setTitle(LStrings.enter, for: .normal)
    }
    
    //MARK:- 状態変化系
    
    func changedSelectedCount() {
        setSelectedCountLabel()
        setConfirmButton()
        formOfRssFeed.text = CommonData.rssFeedListModel.rssFeedList.count == 1 ? LStrings.singularFormOfRssFeed : LStrings.pluralFormOfRssFeed
    }
    func setSelectedCountLabel() {
        selectedCountLabel.text = String(CommonData.rssFeedListModel.rssFeedList.count)
    }
    func setConfirmButton() {
        confirmButton.isEnabled = CommonData.rssFeedListModel.rssFeedList.count > 0
    }
    func rssFeedKeySort() {
        rssFeedKeyList = CommonData.rssFeedListModel.rssFeedList.keys.sorted()
        changedSelectedCount()
    }
    
    //MARK:- @IBAction
    
    @IBAction func tappedConfirmButton(_ sender: Any) {
        dismiss(animated: true)
    }
}


//MARK:- TableView

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeedKeyList.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // RssFeedセルかAddNewCellか
        if indexPath.row < CommonData.rssFeedListModel.rssFeedList.count {
            let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RssFeedTableViewCell
            cell.rssFeed = CommonData.rssFeedListModel.rssFeedList[rssFeedKeyList[indexPath.row]]
            cell.articleTaggedWithLabel.text = LStrings.articleTaggedWith
            return cell
        }
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewRssFeedTableViewCell
        cell.addNewRssFeedLabel.text = LStrings.addNewRssFeed
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        changedSelectedCount()
        if indexPath.row == CommonData.rssFeedListModel.rssFeedList.count {
            CommonRouter.toSelectRssFeedTypeView(view: self)
        }
    }
    
    // addNewのセルは削除出来ないようにするため
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row < CommonData.rssFeedListModel.rssFeedList.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.rssFeedList.removeValue(forKey: rssFeedKeyList[indexPath.row])
        rssFeedKeySort()
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
}

extension SelectRssFeedViewController: SelectRssFeedDelegate {
    func setRssFeed(rssFeed: RssFeedProtocol) {
        CommonData.rssFeedListModel.rssFeedList[rssFeed.url] = rssFeed
        rssFeedKeySort()
        selectRssFeedTableView.reloadData()
    }
}


// MARK:- AddNewRssFeedTableViewCell

class AddNewRssFeedTableViewCell: UITableViewCell {
    @IBOutlet weak var addNewRssFeedLabel: UILabel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
