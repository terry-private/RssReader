//
//  MailLoginViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/29.
//

import UIKit

class MailLoginViewController: UIViewController, Transitioner {
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "mailLogin_view"
        mailTextField.layer.borderWidth = 1
        mailTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        mailTextField.layer.cornerRadius = 8
        mailTextField.accessibilityIdentifier = "mailLogin_mail_textField"
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.accessibilityIdentifier = "mailLogin_password_textField"
        
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.secondaryLabel, for: .highlighted)
        loginButton.layer.cornerRadius = 8
        
        loginButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.setTitleColor(.lightGray, for: .highlighted)
        loginButton.accessibilityIdentifier = "mailLogin_login_button"
        
        validation()
    }
    
    /// 入力値が正しい場合のみ確定ボタンを有効にします。
    func validation() {
        let emailValidation = (mailTextField.text ?? "").isMail()
        
        // passwordの文字数が6~12に収まっているかどうか
        let isPasswordCount6To12 = (passwordTextField.text?.count ?? 0) >= 6 && (passwordTextField.text?.count ?? 0) <= 12
        // passwordの文字列が英数字のみかどうか
        let isPasswordAlphaNumeric = passwordTextField.text?.isAlphanumeric() ?? false
        
        let passwordValidation = isPasswordCount6To12 && isPasswordAlphaNumeric
        
        if emailValidation && passwordValidation {
            loginButton.isEnabled = true
            loginButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
        } else {
            loginButton.isEnabled = false
            loginButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    
    private func loginToSignUp() {
        let alert = UIAlertController(title: "新規アカウント", message: "この情報で新規アカウントをお作りしてもよろしいでしょうか？", preferredStyle: UIAlertController.Style.alert)
        alert.view.accessibilityIdentifier = "mailLogin_newAccount_alert"
        // キャンセルボタン追加
        alert.addAction(
            UIAlertAction(
                title: "キャンセル",
                style: UIAlertAction.Style.cancel,
                handler: nil))
        
        // 確定ボタン追加
        alert.addAction(
            UIAlertAction(
                title: "新規アカウント作成",
                style: UIAlertAction.Style.default) { _ in
                CommonRouter.toNewAccountPropertyView(view: self, defaultData: ["mail": self.mailTextField.text ?? "", "password": self.passwordTextField.text ?? ""])
            }
        )
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedLoginButton(_ sender: Any) {
        let isMailType = CommonData.loginModel.userConfig.loginType == "mail"
        let isSameMail = CommonData.loginModel.userConfig.userID == mailTextField.text
        let isSamePassword = CommonData.loginModel.userConfig.password == passwordTextField.text
        
        // 既存のアカウントの場合だけログイン成功
        if isMailType && isSameMail && isSamePassword {
            CommonData.loginModel.userConfig.latestLoginDate = Date()
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        loginToSignUp()
    }
    @IBAction func tappedSignInButton(_ sender: Any) {
        CommonRouter.toNewAccountPropertyView(view: self, defaultData: ["mail": mailTextField.text ?? "", "password": passwordTextField.text ?? ""])
    }
    
    @IBAction func mailTextFieldTappedDone(_ sender: UITextField) {
        validation()
    }
    @IBAction func passwordTextFieldTappedDone(_ sender: UITextField) {
        validation()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        validation()
        view.endEditing(true)
    }
}
