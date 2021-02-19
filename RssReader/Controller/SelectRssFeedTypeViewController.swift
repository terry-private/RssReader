//
//  SelectRssFeedTypeViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/19.
//

import UIKit
import Nuke

protocol SelectRssFeedTypeViewControllerProtocol: Transitioner {
    
}

class SelectRssFeedTypeViewController: UIViewController, SelectRssFeedTypeViewControllerProtocol {
    @IBOutlet weak var rssFeedTypeListTableView: UITableView!
    
    let cellId = "cellId"
    var typeList: [RssFeedTypeProtocol] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
