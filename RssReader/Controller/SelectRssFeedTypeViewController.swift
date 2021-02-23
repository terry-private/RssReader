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
    var typeList: [RssFeedTypeProtocol] = []
    weak var delegate: SelectRssFeedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rssFeedTypeListTableView.delegate = self
        rssFeedTypeListTableView.dataSource = self
        let closeButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(close))
        navigationItem.leftBarButtonItem = closeButton
    }
    @objc func close(){
        dismiss(animated: true)
    }
}


extension SelectRssFeedTypeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = rssFeedTypeListTableView.dequeueReusableCell(withIdentifier: cellId) as! RssFeedTypeListTableViewCell
        cell.rssFeedType = typeList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            delegate!.setRssFeed(rssFeed: typeList[0].makeRssFeed(tag: "python")!)
            dismiss(animated: true)
            return
        case 1:
            CommonRouter.toSelectYahooTagView(view: self)
            return
        default:
            return
        }
        
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
