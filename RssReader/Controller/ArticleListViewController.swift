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
    //------------------------------------------------------------------------------------
    // @IBOutlet
    //------------------------------------------------------------------------------------
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleTableView: UITableView!
    
    //------------------------------------------------------------------------------------
    // 変数宣言
    //------------------------------------------------------------------------------------
    var cellId = "cellId"
    var items: [Item] = [] {
        didSet {
            articleTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    var articleType: ArticleType = Qiita(tag: "swift")
    
    //------------------------------------------------------------------------------------
    // ライフサイクル関連
    //------------------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.dataSource = self
        articleTableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
    }
    
    //------------------------------------------------------------------------------------
    // 関数
    //------------------------------------------------------------------------------------
    func fetchItems() {
        activityIndicator.startAnimating()
        RssClient.fetchItems(rssApiUrl: articleType.url, completion: {(response) in
            guard let items = response else {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
                
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = articleTableView.cellForRow(at: indexPath) as! ArticleTableViewCell
        guard let url = URL(string: cell.item?.link ?? "") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler:  nil)
        }
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
