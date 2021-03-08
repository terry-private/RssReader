//
//  StarListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class StarListViewController: UIViewController, Transitioner {
    @IBOutlet weak var starListTableView: UITableView!
    var starListKeys: [String] = []
    private let articleTableViewCellId = "articleTableViewCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        starListTableView.delegate = self
        starListTableView.dataSource = self
        starListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "お気に入り"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keysSort()
    }
    
    @objc func presentFilterMenu(){
        CommonRouter.toFilterMenuView(view: self)
    }
}
extension StarListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return starListKeys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = starListTableView.dequeueReusableCell(withIdentifier: articleTableViewCellId, for: indexPath) as! ArticleTableViewCell
        cell.article = CommonData.rssFeedListModel.articleList[starListKeys[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.changeRead(articleKey: starListKeys[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[starListKeys[indexPath.row]]!)
    }
    // MARK:- 右側のスワイプメニュー
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let starAction = UIContextualAction(style: .normal  , title: "star") {
            (contextAction, view, completionHandler) in
            let newIsStar = !CommonData.rssFeedListModel.articleList[self.starListKeys[indexPath.row]]!.isStar
            CommonData.rssFeedListModel.changeStar(articleKey: self.starListKeys[indexPath.row], isStar: newIsStar)
            self.keysSort()
            completionHandler(true)
        }
        let starImage = UIImage(systemName: "star.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        starAction.image = starImage
        starAction.backgroundColor = .systemYellow
        
       
        let laterReadAction = UIContextualAction(style: .destructive, title:"laterRead") {
            (contextAction, view, completionHandler) in
            let newLaterRead = !CommonData.rssFeedListModel.articleList[self.starListKeys[indexPath.row]]!.laterRead
            CommonData.rssFeedListModel.changeLaterRead(articleKey: self.starListKeys[indexPath.row], laterRead: newLaterRead)
            self.keysSort()
            completionHandler(true)
        }
        let laterReadImage = UIImage(systemName: "tray.fill")?.withTintColor(.white , renderingMode: .alwaysTemplate)
        laterReadAction.image = laterReadImage
        laterReadAction.backgroundColor = .systemGreen
        
        let swipeAction = UISwipeActionsConfiguration(actions:[laterReadAction, starAction])
        swipeAction.performsFirstActionWithFullSwipe = false
        
        return swipeAction
        
    }
    
    // MARK:- 左側のスワイプメニュー
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isRead = CommonData.rssFeedListModel.articleList[self.starListKeys[indexPath.row]]!.read
        let title =  isRead ? "未読にする": "既読にする"
        let readAction = UIContextualAction(style: .normal, title: title) { (action, view, completionHandler) in
            CommonData.rssFeedListModel.changeRead(articleKey: self.starListKeys[indexPath.row], read: !isRead)
            self.keysSort()
            completionHandler(true)
        }
        let readImage = UIImage(systemName: "checkmark.circle.fill")
        if !isRead { readAction.image = readImage }
        readAction.backgroundColor = isRead ? .systemGray3 : .systemBlue
        return UISwipeActionsConfiguration(actions: [readAction])
    }
}

extension StarListViewController: KeysSortable {
    func keysSort() {
        starListKeys = CommonData.filterModel.sortStarList(articleList:CommonData.rssFeedListModel.articleList)
        starListTableView.reloadData()
    }
}
