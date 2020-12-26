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

        let splashViewController = UIStoryboard(name: "Splash", bundle: nil).instantiateInitialViewController() as! SplashViewController
        
        // 本番環境
        splashViewController.inject(splashRouter: SplashRouter(view:splashViewController), autoLoginModel: AutoLoginModel(userConfig: UserConfig()))
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = splashViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

