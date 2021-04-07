//
//  LaterReadListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class LaterReadListViewController: UIViewController, Transitioner {
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var laterReadListTableView: UITableView!
    @IBOutlet weak var laterReadCollectionView: UICollectionView!
    
    // MARK:- 変数宣言
    
    private let articleTableViewCellId = "articleTableViewCellId"
    private let articleCollectionViewCellId = "articleCollectionViewCellId"
    
    var laterReadListKeys: [String] = []
    
    // MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpCollection()
        setUpBarItem()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FilterModel.displayModeでテーブルとコレクションのどちらを表示するかの切り替え
        laterReadListTableView.isHidden = CommonData.filterModel.displayMode == .collectionMode
        laterReadCollectionView.isHidden = CommonData.filterModel.displayMode == .tableMode
        if CommonData.filterModel.displayMode == .tableMode {
            view.sendSubviewToBack(laterReadListTableView)
            
        } else {
            view.sendSubviewToBack(laterReadCollectionView)
        }
        keysSort()
    }
    
    func setUpTable() {
        laterReadListTableView.delegate = self
        laterReadListTableView.dataSource = self
        laterReadListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
    }
    
    func setUpCollection() {
        laterReadCollectionView.delegate = self
        laterReadCollectionView.dataSource = self
        laterReadCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: articleCollectionViewCellId)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = view.bounds.width / 2 - horizontalSpace
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        laterReadCollectionView.collectionViewLayout = layout
    }
    
    func setUpBarItem() {
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "後で読む"
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
        CommonData.rssFeedListModel.changeRead(articleKey: laterReadListKeys[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]!)
    }
    
    // MARK:- 右側のスワイプメニュー
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let starAction = UIContextualAction(style: .normal  , title: "star") {
            (contextAction, view, completionHandler) in
            let newIsStar = !CommonData.rssFeedListModel.articleList[self.laterReadListKeys[indexPath.row]]!.isStar
            CommonData.rssFeedListModel.changeStar(articleKey: self.laterReadListKeys[indexPath.row], isStar: newIsStar)
            self.keysSort()
            completionHandler(true)
        }
        let starImage = UIImage(systemName: "star.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        starAction.image = starImage
        starAction.backgroundColor = .systemYellow
        
       
        let laterReadAction = UIContextualAction(style: .destructive, title:"laterRead") {
            (contextAction, view, completionHandler) in
            let newLaterRead = !CommonData.rssFeedListModel.articleList[self.laterReadListKeys[indexPath.row]]!.laterRead
            CommonData.rssFeedListModel.changeLaterRead(articleKey: self.laterReadListKeys[indexPath.row], laterRead: newLaterRead)
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
        let isRead = CommonData.rssFeedListModel.articleList[self.laterReadListKeys[indexPath.row]]!.read
        let title =  isRead ? "未読にする": "既読にする"
        let readAction = UIContextualAction(style: .normal, title: title) { (action, view, completionHandler) in
            CommonData.rssFeedListModel.changeRead(articleKey: self.laterReadListKeys[indexPath.row], read: !isRead)
            self.keysSort()
            completionHandler(true)
        }
        let readImage = UIImage(systemName: "checkmark.circle.fill")
        if !isRead { readAction.image = readImage }
        readAction.backgroundColor = isRead ? .systemGray3 : .systemBlue
        return UISwipeActionsConfiguration(actions: [readAction])
    }
}

extension LaterReadListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return laterReadListKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = laterReadCollectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionViewCellId, for: indexPath) as! ArticleCollectionViewCell
        cell.article = CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.changeRead(articleKey: laterReadListKeys[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]!)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt
        indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // ①プレビューの定義
        let previewProvider: () -> PreviewViewController? = { [unowned self] in
            return PreviewViewController(image: (laterReadCollectionView.cellForItem(at: indexPath) as! ArticleCollectionViewCell).thumbnailImageView.image!)
        }
        let article = CommonData.rssFeedListModel.articleList[laterReadListKeys[indexPath.row]]!
        // ②メニューの定義
        let actionProvider: ([UIMenuElement]) -> UIMenu? = { _ in
            // 既読⇄未読
            let read = article.read
            let readAction = UIAction(title: read ? "未読にする" : "既読にする", image: UIImage(systemName: read ? "checkmark.circle.fill" : "checkmark.circle")) { _ in
                CommonData.rssFeedListModel.changeRead(articleKey: article.item.link, read: !read)
                self.keysSort()
            }
            // お気に入り
            let newIsStar = article.isStar
            let starAction = UIAction(title: newIsStar ? "お気に入り解除" : "お気に入り", image: UIImage(systemName: newIsStar ? "star.fill" : "star")) { _ in
                CommonData.rssFeedListModel.changeStar(articleKey: article.item.link, isStar: !newIsStar)
                self.keysSort()
            }
            
            // 後で読む
            let laterRead = article.laterRead
            let laterReadAction = UIAction(title: laterRead ? "後で読むを解除" : "後で読む", image: UIImage(systemName: "tray")) { _ in
                CommonData.rssFeedListModel.changeLaterRead(articleKey: article.item.link, laterRead: !laterRead)
                self.keysSort()
            }

            return UIMenu(title: "編集", image: nil, identifier: nil, children: [readAction, starAction, laterReadAction])
        }

        return UIContextMenuConfiguration(identifier: nil,
                                          previewProvider: previewProvider,
                                          actionProvider: actionProvider)
    }
}
extension LaterReadListViewController: KeysSortable {
    func keysSort() {
        laterReadListKeys = CommonData.filterModel.sortLaterReadList(articleList: CommonData.rssFeedListModel.articleList)
        if CommonData.filterModel.displayMode == .tableMode {
            laterReadListTableView.reloadData()
        } else {
            laterReadCollectionView.reloadData()
        }
    }
}
