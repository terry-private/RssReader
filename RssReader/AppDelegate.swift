//
//  AppDelegate.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/21.
//

import UIKit
import Firebase
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        
        
        // 本番環境
        CommonData.loginModel = LoginModel(userConfig: UserConfig())
        CommonData.rssFeedListModel = RssFeedListModel()
        CommonData.filterModel = FilterModel()
        // ダミー環境
//        CommonData.loginModel = DummyLoginModel()
//        CommonData.rssFeedListModel = DummyRssFeedListModel()
//        CommonData.filterModel = DummyFilterModel()
        
        let mainTab = MainTabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainTab
        window?.makeKeyAndVisible()
        
        return true
    }
}

