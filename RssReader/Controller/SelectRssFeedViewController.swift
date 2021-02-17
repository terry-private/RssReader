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
    
    private var rssFeedListModel: RssFeedListModelProtocol?
    private var cellId = "cellId"
    private var addNewCellId = "addNewCellId"
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        changedSelectedCount()
        selectRssFeedTableView.register(UINib(nibName: "RssFeedTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
    }
    
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
    }
    
    func inject(rssFeedListModel: RssFeedListModelProtocol) {
        self.rssFeedListModel = rssFeedListModel
    }
    
    
    //MARK:- 状態変化系
    
    func changedSelectedCount() {
        setSelectedCountLabel()
        setConfirmButton()
    }
    func setSelectedCountLabel() {
        selectedCountLabel.text = String(rssFeedListModel?.rssFeedList.count ?? 0)
    }
    func setConfirmButton() {
        confirmButton.isEnabled = (rssFeedListModel?.rssFeedList.count ?? 0) > 0
    }
    
    
    //MARK:- @IBAction
    
    @IBAction func tappedConfirmButton(_ sender: Any) {
        dismiss(animated: true)
    }
}


//MARK:- TableView

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (rssFeedListModel?.rssFeedList.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // RssFeedセルかAddNewCellか
        if indexPath.row < rssFeedListModel?.rssFeedList.count ?? 0 {
            let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! RssFeedTableViewCell
            cell.rssFeed = rssFeedListModel?.rssFeedList[indexPath.row]
            return cell
        }
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: addNewCellId, for: indexPath) as! AddNewRssFeedTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        changedSelectedCount()
    }
    
}

// MARK:- AddNewRssFeedTableViewCell

class AddNewRssFeedTableViewCell: UITableViewCell {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
