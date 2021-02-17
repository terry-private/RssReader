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
    //MARK:- @IBOutlet
    
    @IBOutlet weak var selectRssFeedTableView: UITableView!
    @IBOutlet weak var selectedCountLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    //MARK:- 変数宣言
    
    private var selectRssFeedModel: SelectRssFeedModelProtocol?
    private var cellId = "cellId"
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        changedSelectedCount()
    }
    
    func setUpTable() {
        selectRssFeedTableView.delegate = self
        selectRssFeedTableView.dataSource = self
    }
    
    func inject(selectRssFeedModel: SelectRssFeedModelProtocol) {
        self.selectRssFeedModel = selectRssFeedModel
    }
    
    
    //MARK:- 状態変化系
    
    func changedSelectedCount() {
        setSelectedCountLabel()
        setConfirmButton()
    }
    func setSelectedCountLabel() {
        selectedCountLabel.text = String(selectRssFeedModel?.selectedRssFeedList.count ?? 0)
    }
    func setConfirmButton() {
        confirmButton.isEnabled = (selectRssFeedModel?.selectedRssFeedList.count ?? 0) > 0
    }
    
    
    //MARK:- @IBAction
    
    @IBAction func tappedConfirmButton(_ sender: Any) {
        dismiss(animated: true)
    }
}


//MARK:- TableView

extension SelectRssFeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectRssFeedModel?.rssFeedList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = selectRssFeedTableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectRssTableViewCell
        let title = selectRssFeedModel?.rssFeedList[indexPath.row] ?? ""
        let isSelected = selectRssFeedModel?.selectedRssFeedList.contains(title) ?? false
        cell.rssFeedTitleLabel?.text = title
        cell.isSelectedRssFeed = isSelected
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = selectRssFeedModel?.rssFeedList[indexPath.row] ?? ""
        let cell = selectRssFeedTableView.cellForRow(at: indexPath) as! SelectRssTableViewCell
        if cell.isSelectedRssFeed {
            selectRssFeedModel?.selectedRssFeedList.remove(title)
            cell.isSelectedRssFeed = false
        } else {
            selectRssFeedModel?.selectedRssFeedList.insert(title)
            cell.isSelectedRssFeed = true
        }
        changedSelectedCount()
    }
    
}

// MARK:- SelectRssTableViewCell

class SelectRssTableViewCell: UITableViewCell {
    @IBOutlet weak var rssFeedTitleLabel: UILabel!
    @IBOutlet weak var isSelectedLabel: UILabel!
    var isSelectedRssFeed: Bool  = false{
        didSet {
            if isSelectedRssFeed {
                isSelectedLabel.textColor = .systemGreen
                isSelectedLabel.text = "選択済み"
            } else {
                isSelectedLabel.textColor = .systemGray
                isSelectedLabel.text = "未選択"
            }
        }
    }
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
