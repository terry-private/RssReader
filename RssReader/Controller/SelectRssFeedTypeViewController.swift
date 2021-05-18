//
//  SelectRssFeedTypeViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/19.
//

import UIKit
import Nuke

protocol SelectRssFeedDelegate: AnyObject {
    func setRssFeed(rssFeed: RssFeedProtocol)
}

protocol SelectRssFeedTypeViewControllerProtocol: Transitioner {
    
}

class SelectRssFeedTypeViewController: UIViewController, SelectRssFeedTypeViewControllerProtocol {
    @IBOutlet weak var rssFeedTypeListTableView: UITableView!
    
    let cellId = "cellId"
    weak var delegate: SelectRssFeedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAccessibilityIdentifier()
        rssFeedTypeListTableView.delegate = self
        rssFeedTypeListTableView.dataSource = self
        let closeButton = UIBarButtonItem(title: LStrings.cancel.value, style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
    }
    @objc func close(){
        dismiss(animated: true)
    }
    
    // UITestにおいてXCUIElementを特定するために使います。
    func setAccessibilityIdentifier() {
        view.accessibilityIdentifier = "selectRssFeedType_view"
        rssFeedTypeListTableView.accessibilityIdentifier = "selectRssFeedType_table"
    }
}


extension SelectRssFeedTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        CommonData.rssFeedListModel.typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rssFeedTypeListTableView.dequeueReusableCell(withIdentifier: cellId) as! RssFeedTypeListTableViewCell
        cell.rssFeedType = CommonData.rssFeedListModel.typeList[indexPath.row]
        switch indexPath.row {
        case 0:
            cell.accessibilityIdentifier = "selectRssFeedType_qiita_cell"
        case 1:
            cell.accessibilityIdentifier = "selectRssFeedType_yahoo_cell"
        default:
            print("indexPath.row is over")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.typeList[indexPath.row].toSelectTag(view: self)
    }
}

extension SelectRssFeedTypeViewController: SelectRssFeedDelegate {
    func setRssFeed(rssFeed: RssFeedProtocol) {
        delegate?.setRssFeed(rssFeed: rssFeed)
    }
}

class RssFeedTypeListTableViewCell: UITableViewCell {
    @IBOutlet weak var faviconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    var rssFeedType: RssFeedTypeProtocol? {
        didSet {
            if let url = URL(string: rssFeedType?.faviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            titleLabel.text = rssFeedType?.title
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
