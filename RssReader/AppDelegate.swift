//
//  AppDelegate.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        FirebaseApp.configure()

//        let splashViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateInitialViewController() as! SplashViewController
        
        // 本番環境
//        splashViewController.inject(splashRouter: SplashRouter(view:splashViewController), autoLoginModel: LoginModel(userConfig: UserConfig()))
        
        // ダミー環境
//        splashViewController.inject(splashRouter: DummySplashRouter(view:splashViewController), autoLoginModel: DummyLoginModel())
        
        let mainTab = MainTabBarController()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = mainTab
        window?.makeKeyAndVisible()
        
        return true
    }
}

