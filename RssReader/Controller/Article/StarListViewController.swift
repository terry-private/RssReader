//
//  StarListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class StarListViewController: UIViewController, Transitioner {
    
    // MARK:- IBOutlet
    
    @IBOutlet weak var starListTableView: UITableView!
    @IBOutlet weak var starListCollectionView: UICollectionView!
    
    // MARK:- 変数宣言
    
    private let articleTableViewCellId = "articleTableViewCellId"
    private let articleCollectionViewCellId = "articleCollectionViewCellId"
    
    var starListKeys: [String] = []
    
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
        starListTableView.isHidden = CommonData.filterModel.displayMode == .collectionMode
        starListCollectionView.isHidden = CommonData.filterModel.displayMode == .tableMode
        keysSort()
    }
    
    func setUpTable() {
        starListTableView.delegate = self
        starListTableView.dataSource = self
        starListTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
    }
    
    func setUpCollection() {
        starListCollectionView.delegate = self
        starListCollectionView.dataSource = self
        starListCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: articleCollectionViewCellId)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = view.bounds.width / 2 - horizontalSpace
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        starListCollectionView.collectionViewLayout = layout
    }
    
    func setUpBarItem() {
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "お気に入り"
    }
    
    @objc func presentFilterMenu(){
        CommonRouter.toFilterMenuView(view: self)
    }
}

// MARK:- テーブルビュー関連
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
}

// MARK:- コレクションビュー関連

extension StarListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return starListKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = starListCollectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionViewCellId, for: indexPath) as! ArticleCollectionViewCell
        cell.article = CommonData.rssFeedListModel.articleList[starListKeys[indexPath.row]]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.changeRead(articleKey: starListKeys[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[starListKeys[indexPath.row]]!)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt
        indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // ①プレビューの定義
        let previewProvider: () -> PreviewViewController? = { [unowned self] in
            return PreviewViewController(image: (starListCollectionView.cellForItem(at: indexPath) as! ArticleCollectionViewCell).thumbnailImageView.image!)
        }
        let article = CommonData.rssFeedListModel.articleList[starListKeys[indexPath.row]]!
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
            let laterReadAction = UIAction(title: "後で読む", image: UIImage(systemName: "tray")) { _ in
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

extension StarListViewController: KeysSortable {
    func keysSort() {
        starListKeys = CommonData.filterModel.sortStarList(articleList:CommonData.rssFeedListModel.articleList)
        if CommonData.filterModel.displayMode == .tableMode {
            starListTableView.reloadData()
        } else {
            starListCollectionView.reloadData()
        }
    }
}
