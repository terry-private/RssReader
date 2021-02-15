//
//  ArticleListViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import UIKit
import FirebaseUI

protocol ArticleListViewControllerProtocol: Transitioner, FUIAuthDelegate {
    
}

class ArticleListViewController: UIViewController, ArticleListViewControllerProtocol {
    
    //MARK:- @IBOutlet
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var splashView: UIView!
    
    //MARK:- 変数宣言
    
    var cellId = "cellId"
    var items: [Item] = [] {
        didSet {
            articleTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    var articleType: ArticleType = Qiita(tag: "swift")
    var isFirst = true
    
    var loginModel: LoginProtocol?
    var articleListRouter: ArticleListRouterProtocol?
    
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
            loginModel?.autoLogin()
            isFirst = false
        } else {
            if splashView.isHidden {
                fetchItems()
                return
            }
            // SelectRssFeedViewがdisMissされた場合のみここに到達する。
            dissMissSplashView()
        }
    }
    

    //MARK:- 関数
    
    func inject(loginModel: LoginProtocol, articleListRouter: ArticleListRouterProtocol) {
        self.loginModel = loginModel
        self.loginModel?.autoLoginDelegate = self
        self.articleListRouter = articleListRouter
    }
    
    func dissMissSplashView() {
        UIView.animate(withDuration: 1, animations: {
            self.splashView.alpha = 0
        }, completion: {_ in
            self.navigationItem.title = "記事一覧"
            self.splashView.isHidden = true
            self.fetchItems()
        })
    }
    
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

//MARK:- TableView

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

//MARK:- AutoLoginDelegate

extension ArticleListViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        if isSuccess {
            dissMissSplashView()
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
                dissMissSplashView()
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

//MARK:- ArticleTableViewCell

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
