//
//  LoginViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/21.
//

import LineSDK
import UIKit


class LoginViewController: UIViewController {
    let indicator = UIActivityIndicatorView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setLoginButton()
        setIndicator()
    }
    
    private func setLoginButton() {
        // Create Login Button.
        let loginButton = LoginButton()
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        
        // Add button to view and layout it.
        view.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    
    }
    private func setIndicator() {
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        // superViewとみったり張り合わせます。
        indicator.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        indicator.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        indicator.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        indicator.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    func showIndicator() {
        indicator.startAnimating()
    }
    func hideIndicator() {
        indicator.stopAnimating()
    }
    
    func login() {
        LoginManager.shared.login(permissions: [.profile], in: self) {
            result in
            switch result {
            case .success(let loginResult):
                print(loginResult.accessToken.value)
                // Do other things you need with the login result
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        hideIndicator()
        if let profile = loginResult.userProfile {
            print("User ID: \(profile.userID)")
            print("User Display Name: \(profile.displayName)")
            print("User Icon: \(String(describing: profile.pictureURL))")
            CommonData.loginModel.userConfig.userID = profile.userID
            CommonData.loginModel.userConfig.displayName = profile.displayName
            CommonData.loginModel.userConfig.photoURL = profile.pictureURL
            CommonData.loginModel.userConfig.latestLoginDate = Date()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        hideIndicator()
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
        showIndicator()
        print("Login Started.")
    }
}
