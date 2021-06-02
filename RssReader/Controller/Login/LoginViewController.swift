//
//  LoginViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/21.
//

import LineSDK
import UIKit


class LoginViewController: UIViewController, Transitioner {
    let indicator = UIActivityIndicatorView()
    let stackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "login_view"
        view.addSubview(stackView)
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        #if DebugDummy
        setDummyLoginButton()
        #else
        setLineLoginButton()
        setMailLoginButton()
        #endif
        
        setIndicator()
        view.backgroundColor = UIColor(named: "MainBG")
        
    }
    
    // MARK:- Line Login Button
    private func setLineLoginButton() {
        // Create Login Button.
        let loginButton = LoginButton()
        loginButton.accessibilityIdentifier = "line_login_button"
        loginButton.delegate = self
        
        // Configuration for permissions and presenting.
        loginButton.permissions = [.profile]
        loginButton.presentingViewController = self
        // Add button to view and layout it.
        stackView.addArrangedSubview(loginButton)
    
    }
    
    // MARK:- Mail Login Button
    private func setMailLoginButton() {
        let loginButton = UIButton()
        loginButton.accessibilityIdentifier = "mail_login_button"
        loginButton.addTarget(self, action: #selector(tappedMailLoginButton), for: .touchUpInside)
        loginButton.layer.cornerRadius = 8
        loginButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.tintColor = .white
        loginButton.setImage(UIImage(systemName: "mail"), for: .normal)
        loginButton.setTitle("　　" + LStrings.mailLogin.value, for: .normal)
        loginButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .caption1)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        stackView.addArrangedSubview(loginButton)
    }
    @objc func tappedMailLoginButton() {
        CommonRouter.toMailLoginView(view: self)
    }
    
    // MARK:- Dummy Login Button
    private func setDummyLoginButton() {
        let loginButton = UIButton()
        loginButton.accessibilityIdentifier = "dummy_login_button"
        loginButton.setTitle(LStrings.idLoginButtonTitle.value, for: .normal)
        loginButton.setTitleColor(.systemBlue, for: .normal)
        loginButton.addTarget(self, action: #selector(tappedDummyLoginButton), for: .touchUpInside)
        stackView.addArrangedSubview(loginButton)
    }
    @objc func tappedDummyLoginButton() {
        let alert = UIAlertController(title: LStrings.login.value, message: LStrings.loginAlertMessage.value, preferredStyle: UIAlertController.Style.alert)
        alert.view.accessibilityIdentifier = "dummy_login_alert"
        
        // テキストフィールド追加
        // アラート画面でloginIDを入力させます。
        var alertTextField: UITextField?
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            alertTextField = textField
            textField.text = ""
            textField.placeholder = LStrings.halfAlphanumeric8_12.value
        })
        alertTextField?.accessibilityIdentifier = "dummy_login_id_textField"

        // キャンセルボタン追加
        let cancelButton = UIAlertAction(
            title: LStrings.cancel.value,
                style: UIAlertAction.Style.cancel,
                handler: nil
        )
        alert.addAction(cancelButton)
        
        // 確定ボタン追加
        let loginButton = UIAlertAction(
            title: LStrings.login.value,
            style: UIAlertAction.Style.default) { _ in
            if let text = alertTextField?.text {
                if text == "" { return }
                if let error = self.validId(uid: text) {
                    self.validError(error: error)
                    return
                }
                CommonData.loginModel.userConfig.userID = text
                CommonData.loginModel.userConfig.displayName = text
                CommonData.loginModel.userConfig.latestLoginDate = Date()
                self.dismiss(animated: true)
                
            }
        }
        alert.addAction(loginButton)
        
        self.present(alert, animated: true, completion: nil)
    }
    private func validError(error: String) {
        presentErrorAlert(title: LStrings.errorAlertTitle.value, message: error)
        return
        let errorAlert = UIAlertController(title: LStrings.errorAlertTitle.value,
                                              message: error,
                                              preferredStyle: .alert)
        errorAlert.addAction(UIAlertAction(title: "OK", style: .cancel))
        errorAlert.view.accessibilityIdentifier = "dummy_login_error_alert"
        self.present(errorAlert,animated: true,completion: nil)
    }
    
    /// エラーの場合にエラーメッセージをString型で返し、成功の場合はnilを返します。
    /// - Parameter uid: ログインIDの入力内容
    /// - Returns: エラーメッセージ or nil (成功時)
    func validId(uid: String) -> String? {
        if uid.count < 8 || uid.count > 12 {
            return LStrings.countErrorMessage.value
        }
        if !uid.isAlphanumeric() {
            return LStrings.alphanumericErrorMessage.value
        }
        return nil
    }
    
    // MARK:- Indicator
    private func setIndicator() {
        view.addSubview(indicator)
        indicator.hidesWhenStopped = true
        // superViewとぴったり張り合わせます。
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
    
}


// MARK:- Lineのログイン完了後のメソッド　LoginButtonDelegate
extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LoginResult) {
        hideIndicator()
        if let profile = loginResult.userProfile {
            CommonData.loginModel.userConfig.loginType = "line"
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
