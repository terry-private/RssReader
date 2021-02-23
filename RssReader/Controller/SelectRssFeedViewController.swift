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
    
    @IBOutlet weak var selectRssFeedTableView: UITableView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK:- 変数宣言
    private var rssFeedKeyList: [String] = []
    private let cellId = "cellId"
    private let addNewCellId = "addNewCellId"
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rssFeedKeySort()
        changedSelectedCount()
    }
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
        selectRssFeedTableView.register(UINib(nibName: "RssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        selectRssFeedTableView.register(UINib(nibName: "AddNewRssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: addNewCellId)
    }
    //MARK:- 状態変化系
    
    func changedSelectedCount() {
        setSelectedCountLabel()
        setConfirmButton()
    }
    func setSelectedCountLabel() {
        selectedCountLabel.text = String(CommonData.rssFeedListModel.rssFeedList.count)
    }
    func setConfirmButton() {
        confirmButton.isEnabled = CommonData.rssFeedListModel.rssFeedList.count > 0
    }
    func rssFeedKeySort() {
        rssFeedKeyList = CommonData.rssFeedListModel.rssFeedList.keys.sorted()
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
            return cell
        }
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewRssFeedTableViewCell
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

// MARK:- SelectRssTableViewCell

class SelectRssTableViewCell: UITableViewCell {
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagNameLabel: UILabel!
    var rssFeed: RssFeedProtocol? {
        didSet {
            if let url = URL(string: rssFeed?.faviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            titleLabel.text = rssFeed?.title
            tagNameLabel.text = rssFeed?.tag
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

// MARK:- AddNewRssFeedTableViewCell

class AddNewRssFeedTableViewCell: UITableViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
