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

class ArticleListViewController: UIViewController, ArticleListViewControllerProtocol {
    
    //MARK:- @IBOutlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var splashView: UIView!
    
    //MARK:- 変数宣言
    
    var cellId = "cellId"
    var isFirst = true
    
    var loginModel: LoginProtocol?
    var rssFeedListModel : RssFeedListModelProtocol?
    var articleListRouter: ArticleListRouterProtocol?
    var sortedArticleKeyList: [String] = []
    
    //MARK:- ライフサイクル関連
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleTableView.dataSource = self
        articleTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFirst {
            isFirst = false
            dissMissSplashView()
        } else {
            fetchItems()
        }
    }
    

    //MARK:- 関数
    
    func inject(loginModel: LoginProtocol,rssFeedListModel: RssFeedListModelProtocol, articleListRouter: ArticleListRouterProtocol) {
        self.loginModel = loginModel
        self.loginModel?.autoLoginDelegate = self
        
        self.rssFeedListModel = rssFeedListModel
        self.rssFeedListModel?.rssFeedListModelDelegate = self
        
        self.articleListRouter = articleListRouter
    }
    
    // フェードアウトするアニメーションの後にオートログインをし始めます。
    func dissMissSplashView() {
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0
        }, completion: {_ in
            self.navigationItem.title = "記事一覧"
            self.splashView.isHidden = true
            self.loginModel?.autoLogin()
        })
    }
    
    func fetchItems() {
        activityIndicator.startAnimating()
        rssFeedListModel?.fetchItems()
    }
    
    func articleKeySort() {
        sortedArticleKeyList = rssFeedListModel?.articleList.keys.sorted() ?? []
    }

}

//MARK:- TableView

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rssFeedListModel?.articleList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: cellId) as! ArticleTableViewCell
        cell.article = rssFeedListModel?.articleList[sortedArticleKeyList[indexPath.row]]
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

//MARK:- AutoLoginDelegate

extension ArticleListViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        if isSuccess {
            fetchItems()
        } else {
            articleListRouter?.toAuthView()
        }
    }
}

//MARK:- FUIAuthDelegate

extension ArticleListViewController: FUIAuthDelegate{
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
        if let newUser = user {
            
            // 登録済みのユーザーの場合
            if newUser.uid == loginModel?.userConfig.userID {
                print("Log in!!")
                loginModel?.userConfig.latestLoginDate = Date()
                fetchItems()
                return
            }
            
            // 新規ユーザーの場合
            print("Sign up!!")
            loginModel?.setUserConfig(userID: newUser.uid, photoURL: newUser.photoURL, displayName: newUser.displayName ?? "")
            articleListRouter?.toSelectRssFeedView()
            return
            
        }
        
        //失敗した場合
        print("can't auth")
        loginModel?.autoLogin()
    }
}

//MARK:- RssFeedListModelDelegate
extension ArticleListViewController: RssFeedListModelDelegate {
    func loaded() {
        DispatchQueue.main.async {
            self.articleKeySort()
            self.articleTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
}

//MARK:- ArticleTableViewCell

class ArticleTableViewCell: UITableViewCell {
    @IBOutlet weak var rssFeedTypeTitleLabel: UILabel!
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var rssFeedTagLabel: UILabel!
    @IBOutlet weak var articlePubDateLabel: UILabel!
    @IBOutlet weak var faviconImageView: UIImageView!
    var article: Article? {
        didSet {
            if let url = URL(string: article?.rssFeedFaviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            rssFeedTypeTitleLabel.text = article?.rssFeedTitle
            rssFeedTagLabel.text = article?.tag
            articleTitleLabel.text = article?.item.title
            articlePubDateLabel.text = article?.item.pubDate
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
}
