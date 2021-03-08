//
//  ArticleListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import UIKit
import FirebaseUI
import Nuke

protocol ArticleListViewControllerProtocol: Transitioner, FUIAuthDelegate {
    
}

protocol KeysSortable: AnyObject {
    func keysSort()
}

class ArticleListViewController: UIViewController, ArticleListViewControllerProtocol {
    
    //MARK:- @IBOutlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var articleCollectionView: UICollectionView!
    @IBOutlet weak var splashView: UIView!
    
    //MARK:- 変数宣言
    
    private let articleTableViewCellId = "articleTableViewCellId"
    private let articleCollectionViewCellId = "articleCollectionViewCellId"
    var isFirst = true
    
    var articleListRouter: ArticleListRouterProtocol?
    var sortedArticleKeyList: [String] = []
    
    var timer = Timer()
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        setUpCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // FilterModel.displayModeでテーブルとコレクションのどちらを表示するかの切り替え
        articleTableView.isHidden = CommonData.filterModel.displayMode == .collectionMode
        articleCollectionView.isHidden = CommonData.filterModel.displayMode == .tableMode

        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(CommonData.filterModel.fetchTimeInterval * 60), repeats: true, block: { (timer) in
            self.fetchItems()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if splashView.isHidden {
            if isFirst {
                setUpBarItem()
                isFirst = false
            }
            fetchItems()
        } else {
            dissMissSplashView()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    func setUpTable() {
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
        // 引っ張ってくるくる
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTable), for: UIControl.Event.valueChanged)
        articleTableView.refreshControl = refreshControl
    }
    func setUpCollection() {
        articleCollectionView.delegate = self
        articleCollectionView.dataSource = self
        articleCollectionView.register(UINib(nibName: "ArticleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: articleCollectionViewCellId)
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 20
        let horizontalSpace : CGFloat = 20
        let cellSize : CGFloat = view.bounds.width / 2 - horizontalSpace
        layout.itemSize = CGSize(width: cellSize, height: cellSize)
        articleCollectionView.collectionViewLayout = layout
        // 引っ張ってくるくる
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollection), for: UIControl.Event.valueChanged)
        articleCollectionView.refreshControl = refreshControl
    }
    func setUpBarItem() {
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "最新記事"
    }
    
    @objc func refreshTable() {
        CommonData.rssFeedListModel.fetchItems(rssFeedListModelDelegate: self)
    }
    @objc func refreshCollection() {
        CommonData.rssFeedListModel.fetchItems(rssFeedListModelDelegate: self)
    }
    @objc func presentFilterMenu(){
        CommonRouter.toFilterMenuView(view: self)
    }

    //MARK:- 関数
    
    func inject(articleListRouter: ArticleListRouterProtocol) {
        self.articleListRouter = articleListRouter
    }
    
    // フェードアウトするアニメーションの後にオートログインをし始めます。
    func dissMissSplashView() {
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0
        }, completion: {_ in
            self.splashView.isHidden = true
            CommonData.loginModel.autoLogin(autoLoginDelegate: self)
        })
    }
    
    func fetchItems() {
        activityIndicator.startAnimating()
        CommonData.rssFeedListModel.fetchItems(rssFeedListModelDelegate: self)
    }
}

//MARK:- TableView

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedArticleKeyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: articleTableViewCellId) as! ArticleTableViewCell
        cell.article = CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.changeRead(articleKey: sortedArticleKeyList[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]!)
    }
    
    // MARK:- 右側のスワイプメニュー
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let starAction = UIContextualAction(style: .normal  , title: "star") {
            (contextAction, view, completionHandler) in
            let newIsStar = !CommonData.rssFeedListModel.articleList[self.sortedArticleKeyList[indexPath.row]]!.isStar
            CommonData.rssFeedListModel.changeStar(articleKey: self.sortedArticleKeyList[indexPath.row], isStar: newIsStar)
            self.keysSort()
            completionHandler(true)
        }
        let starImage = UIImage(systemName: "star.fill")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        starAction.image = starImage
        starAction.backgroundColor = .systemYellow
        
       
        let laterReadAction = UIContextualAction(style: .destructive, title:"laterRead") {
            (contextAction, view, completionHandler) in
            let newLaterRead = !CommonData.rssFeedListModel.articleList[self.sortedArticleKeyList[indexPath.row]]!.laterRead
            CommonData.rssFeedListModel.changeLaterRead(articleKey: self.sortedArticleKeyList[indexPath.row], laterRead: newLaterRead)
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
        let isRead = CommonData.rssFeedListModel.articleList[self.sortedArticleKeyList[indexPath.row]]!.read
        let title =  isRead ? "未読にする": "既読にする"
        let readAction = UIContextualAction(style: .normal, title: title) { (action, view, completionHandler) in
            CommonData.rssFeedListModel.changeRead(articleKey: self.sortedArticleKeyList[indexPath.row], read: !isRead)
            self.keysSort()
            completionHandler(true)
        }
        let readImage = UIImage(systemName: "checkmark.circle.fill")
        if !isRead { readAction.image = readImage }
        readAction.backgroundColor = isRead ? .systemGray3 : .systemBlue
        return UISwipeActionsConfiguration(actions: [readAction])
    }
}

// MARK:- CollectionView

extension ArticleListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedArticleKeyList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = articleCollectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionViewCellId, for: indexPath) as! ArticleCollectionViewCell
        cell.article = CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.changeRead(articleKey: sortedArticleKeyList[indexPath.row], read: true)
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]!)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt
        indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {

        // ①プレビューの定義
        let previewProvider: () -> PreviewViewController? = { [unowned self] in
            return PreviewViewController(image: (articleCollectionView.cellForItem(at: indexPath) as! ArticleCollectionViewCell).thumbnailImageView.image!)
        }
        let article = CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]!
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
//MARK:- AutoLoginDelegate

extension ArticleListViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        if isSuccess {
            isFirst = false
            setUpBarItem()
            fetchItems()
        } else {
            articleListRouter?.toAuthView(view: self)
        }
    }
}

//MARK:- FUIAuthDelegate

extension ArticleListViewController: FUIAuthDelegate{
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        if let newUser = user {
            
            // 登録済みのユーザーの場合
            if newUser.uid == CommonData.loginModel.userConfig.userID {
                print("Log in!!")
                CommonData.loginModel.userConfig.latestLoginDate = Date()
                fetchItems()
                return
            }
            
            // 新規ユーザーの場合
            print("Sign up!!")
            CommonData.loginModel.setUserConfig(userID: newUser.uid, photoURL: newUser.photoURL, displayName: newUser.displayName ?? "")
            articleListRouter?.toSelectRssFeedView(view: self)
            return
        }
        
        //失敗した場合
        print("can't auth")
        CommonData.loginModel.autoLogin(autoLoginDelegate: self)
    }
}

//MARK:- RssFeedListModelDelegate
extension ArticleListViewController: RssFeedListModelDelegate {
    func loaded() {
        DispatchQueue.main.async {
            self.keysSort()
            self.activityIndicator.stopAnimating()
            if CommonData.filterModel.displayMode == .tableMode {
                self.articleTableView.refreshControl?.endRefreshing()
            } else {
                self.articleCollectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

extension ArticleListViewController: KeysSortable {
    
    func keysSort() {
        sortedArticleKeyList = CommonData.filterModel.sortMainList(articleList:CommonData.rssFeedListModel.articleList)
        if CommonData.filterModel.displayMode == .tableMode {
            articleTableView.reloadData()
        } else {
            articleCollectionView.reloadData()
        }
    }
}
