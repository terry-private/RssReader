//
//  SplashViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit


class SplashViewController: UIViewController, Transitioner {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var splashRouter: SplashRouterProtocol?
    private var autoLoginModel: AutoLoginProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        autoLoginModel?.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        autoLoginModel?.autoLogin()

    }
    
    func inject(splashRouter: SplashRouterProtocol, autoLoginModel: AutoLoginProtocol) {
        self.splashRouter = splashRouter
        self.autoLoginModel = autoLoginModel
    }
    
}

extension SplashViewController: AutoLoginDelegate {
    func didAutoLogin(isSuccess: Bool) {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        if isSuccess {
            print("認証完了")
        } else {
            print("認証失敗")
            splashRouter?.transitionToAuthView()
        }
    }
}


