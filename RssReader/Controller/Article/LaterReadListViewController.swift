//
//  LaterReadListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class LaterReadListViewController: UIViewController, Transitioner {
    @IBOutlet weak var laterReadListTableView: UITableView!
    var laterReadListKeys: [String] = []
    private let articleTableViewCellId = "articleTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        laterReadListTableView.delegate = self
        laterReadListTableView.dataSource = self
        laterReadListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "後で読む"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keysSort()
    }
    
    @objc func presentFilterMenu(){
        CommonRouter.toFilterMenuView(view: self)
    }
}

extension LaterReadListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laterReadListKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = laterReadListTableView.dequeueReusableCell(withIdentifier: articleTableViewCellId, for: indexPath) as! ArticleTableViewCell
        cell.article = CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]!.read = true
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]!)
    }
    
}

extension LaterReadListViewController: KeysSortable {
    func keysSort() {
        laterReadListKeys = CommonData.filterModel.sortLaterReadList(articleList: CommonData.rssFeedListModel.articleList)
        laterReadListTableView.reloadData()
    }
}