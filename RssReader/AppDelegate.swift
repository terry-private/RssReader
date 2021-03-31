//
//  AppDelegate.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/21.
//

import UIKit
import Firebase
import RealmSwift
import LineSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()
        LoginManager.shared.setup(channelID: "1655768312", universalLinkURL: nil)
        
        #if Release
            print("Release")
            CommonData.loginModel = LoginModel(userConfig: UserConfig())
            CommonData.rssFeedListModel = RssFeedListModel()
            CommonData.filterModel = FilterModel()
        #elseif DebugSecure
            print("DebugSecure")
            CommonData.loginModel = LoginModel(userConfig: UserConfig())
            CommonData.rssFeedListModel = RssFeedListModel()
            CommonData.filterModel = FilterModel()
        #elseif DebugNonSecure
            print("DebugNonSecure")
            CommonData.loginModel = DummyLoginModel()
            CommonData.rssFeedListModel = RssFeedListModel()
            CommonData.filterModel = FilterModel()
        #elseif DebugDummy
            print("DebugDummy")
            CommonData.loginModel = DummyLoginModel()
            CommonData.rssFeedListModel = DummyRssFeedListModel()
            CommonData.filterModel = DummyFilterModel()
        #endif
        
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }
}

