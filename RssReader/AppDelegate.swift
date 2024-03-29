//
//  AppDelegate.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/21.
//

import UIKit
//import RealmSwift
import LineSDK
import GoogleMaps
import GooglePlaces
import GoogleMobileAds

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        LoginManager.shared.setup(channelID: "1655768312", universalLinkURL: nil)
        GMSServices.provideAPIKey("AIzaSyBPekACKXneaSB8Z_JqjZYfnAhdr_DFhuM")
        GMSPlacesClient.provideAPIKey("AIzaSyBPekACKXneaSB8Z_JqjZYfnAhdr_DFhuM")
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        #if DebugSecure
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
        #else
            print("Release")
            CommonData.loginModel = LoginModel(userConfig: UserConfig())
            CommonData.rssFeedListModel = RssFeedListModel()
            CommonData.filterModel = FilterModel()
        #endif
        
        // Testの時にアニメーションをオフにする
        if ProcessInfo.processInfo.arguments.contains("-isUITest") {
            UIView.setAnimationsEnabled(false)
        }
        
        // TabBarが透明になるのを防ぐ
        if #available(iOS 15.0, *) {
            // disable UITab bar transparent
            let tabBarAppearance: UITabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
            UITabBar.appearance().standardAppearance = tabBarAppearance
        }
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return LoginManager.shared.application(app, open: url)
    }
}

