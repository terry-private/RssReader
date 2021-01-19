//
//  ArticleListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import UIKit
import Firebase
import FirebaseUI

class ArticleListViewController: UIViewController, Transitioner {
    var cellId = "cellId"
    var items: [Item] = [] {
        didSet {
            articleTableView.reloadData()
        }
    }
    var articleType: ArticleType = Qiita(tag: "swift")
    @IBOutlet weak var articleTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.dataSource = self
        articleTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RssClient.fetchItems(rssApiUrl: articleType.url, completion: {(response) in
            guard let items = response else { return }
            DispatchQueue.main.async {
                self.items = items
            }
        })
    }

}

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: cellId) as! ArticleTableViewCell
        cell.setArticle(item: items[indexPath.row], articleType: articleType)
        return cell
    }
    
    
}


class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var articleRectangleView: UIView!
    @IBOutlet weak var articleTypeNameLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articlePubDateLabel: UILabel!
    
    var articleType: ArticleType? {
        didSet {
            articleRectangleView.backgroundColor = articleType?.color
            articleTypeNameLabel.text = articleType?.title
        }
    }
    var item: Item? {
        didSet {
            articleTitleLabel.text = item?.title
            articlePubDateLabel.text = item?.pubDate
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setArticle(item: Item, articleType: ArticleType) {
        self.item = item
        self.articleType = articleType
    }
}
