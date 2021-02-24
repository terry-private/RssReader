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
    
    func inject(articleListRouter: ArticleListRouterProtocol) {
        self.articleListRouter = articleListRouter
    }
    
    // フェードアウトするアニメーションの後にオートログインをし始めます。
    func dissMissSplashView() {
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0
        }, completion: {_ in
            self.navigationItem.title = "記事一覧"
            self.splashView.isHidden = true
            CommonData.loginModel.autoLogin(autoLoginDelegate: self)
        })
    }
    
    func fetchItems() {
        activityIndicator.startAnimating()
        CommonData.rssFeedListModel.fetchItems(rssFeedListModelDelegate: self)
    }
    
    func articleKeySort() {
        sortedArticleKeyList = CommonData.rssFeedListModel.articleList.keys.sorted()
    }

}

//MARK:- TableView

extension ArticleListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CommonData.rssFeedListModel.articleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = articleTableView.dequeueReusableCell(withIdentifier: cellId) as! ArticleTableViewCell
        cell.article = CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]!.read = true
        CommonRouter.toArticleDetailView(view: self, article: CommonData.rssFeedListModel.articleList[sortedArticleKeyList[indexPath.row]]!)
    }
}

//MARK:- AutoLoginDelegate

extension ArticleListViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        if isSuccess {
            fetchItems()
        } else {
            articleListRouter?.toAuthView(view: self)
        }
    }
}

//MARK:- FUIAuthDelegate

extension ArticleListViewController: FUIAuthDelegate{
    //　認証画面から離れたときに呼ばれる（キャンセルボタン押下含む）
    public func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?){
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
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var readCheckImageView: UIImageView!
    var article: Article? {
        didSet {
            if let url = URL(string: article?.rssFeedFaviconUrl ?? "") {
                Nuke.loadImage(with: url, into: faviconImageView)
            }
            rssFeedTypeTitleLabel.text = article?.rssFeedTitle
            rssFeedTagLabel.text = article?.tag
            articleTitleLabel.text = article?.item.title
            let pubDate = Date(string: article!.item.pubDate!)
            articlePubDateLabel.text = pubDate.longDate()
            if article?.read ?? false {
                readCheckImageView.alpha = 1
            } else {
                readCheckImageView.alpha = 0
            }
            
            if article?.isStar ?? false {
                starImageView.alpha = 1
            } else {
                starImageView.alpha = 0
            }
            
        }
    }
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
