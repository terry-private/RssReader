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
    @IBOutlet weak var splashView: UIView!
    
    //MARK:- 変数宣言
    
    var articleTableViewCellId = "articleTableViewCellId"
    var isFirst = true
    
    var articleListRouter: ArticleListRouterProtocol?
    var sortedArticleKeyList: [String] = []
    
    var timer = Timer()
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: articleTableViewCellId)
    }
    @objc func presentFilterMenu(){
        CommonRouter.toFilterMenuView(view: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    func setUpBarItem() {
        let hamburgerMenuButton = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(presentFilterMenu))
        hamburgerMenuButton.tintColor = .systemBlue
        navigationItem.leftBarButtonItem = hamburgerMenuButton
        navigationItem.title = "最新記事"
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
        }
    }
}

extension ArticleListViewController: KeysSortable {
    
    func keysSort() {
        sortedArticleKeyList = CommonData.filterModel.sortMainList(articleList:CommonData.rssFeedListModel.articleList)
        articleTableView.reloadData()
    }
}
