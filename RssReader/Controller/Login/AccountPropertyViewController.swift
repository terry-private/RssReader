//
//  AccountPropertyViewController.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/29.
//

import UIKit

class AccountPropertyViewController: UIViewController, Transitioner {
    // MARK:- IBOutlet
    @IBOutlet weak var profileImageButton: UIButton!
    @IBOutlet weak var mailTitleLabel: UILabel!
    @IBOutlet weak var mailTextField: UITextField!
    @IBOutlet weak var passwordTitleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTitleLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var stackViewCenterY: NSLayoutConstraint!
    
    enum UseCase {
        case NewAccount
        case EditAccount
    }

    // MARK:- 変数宣言
    var useCase: UseCase = .NewAccount
    var defaultData: [String: String] = [:]
    
    // キーボードでテキストフィールドが隠れないようにするための必要な高さ
    private var currentTextFieldHeightFromViewBottom: CGFloat = 0
    private var isChangedCurrentTestField = false
    // MAEK:- ライフサイクル系
    override func viewDidLoad() {
        super.viewDidLoad()
        view.accessibilityIdentifier = "accountProperty_view"
        setupNotification()
        
        profileImageButton.layer.cornerRadius = profileImageButton.bounds.width / 2
        profileImageButton.layer.borderWidth = 1
        profileImageButton.layer.borderColor = UIColor.opaqueSeparator.cgColor
        profileImageButton.accessibilityIdentifier = "accountProperty_profileImage_button"
        
        mailTextField.layer.borderWidth = 1
        mailTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        mailTextField.layer.cornerRadius = 8
        mailTextField.delegate = self
        mailTextField.accessibilityIdentifier = "accountProperty_mail_textField"
        
        passwordTextField.layer.borderWidth = 1
        passwordTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        passwordTextField.layer.cornerRadius = 8
        passwordTextField.delegate = self
        passwordTextField.accessibilityIdentifier = "accountProperty_password_textField"
        
        usernameTextField.layer.borderWidth = 1
        usernameTextField.layer.borderColor = UIColor.opaqueSeparator.cgColor
        usernameTextField.layer.cornerRadius = 8
        usernameTextField.delegate = self
        usernameTextField.accessibilityIdentifier = "accountProperty_username_textField"
        
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.secondaryLabel, for: .highlighted)
        confirmButton.layer.cornerRadius = 8
        confirmButton.accessibilityIdentifier = "accountProperty_confirm_button"
        
        confirmButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        confirmButton.setTitleColor(.white, for: .normal)
        confirmButton.setTitleColor(.lightGray, for: .highlighted)
        
        logoutButton.accessibilityIdentifier = "accountProperty_logout_button"
        
        switch useCase {
        case .NewAccount:
            mailTextField.text = defaultData["mail"]
            passwordTextField.text = defaultData["password"]
            logoutButton.isHidden = true
        case .EditAccount:
            if let image = UIImage(contentsOfFile: CommonData.loginModel.userConfig.photoURL?.path ?? "") {
                profileImageButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
                profileImageButton.imageView?.contentMode = .scaleAspectFill
                profileImageButton.contentHorizontalAlignment = .fill
                profileImageButton.contentVerticalAlignment = .fill
                profileImageButton.clipsToBounds = true
            }
            
            mailTextField.text = CommonData.loginModel.userConfig.userID
            passwordTextField.text = CommonData.loginModel.userConfig.password
            usernameTextField.text = CommonData.loginModel.userConfig.displayName
            
            let closeButton = UIBarButtonItem(title: LStrings.close.value, style: .plain, target: self, action: #selector(close))
            navigationItem.leftBarButtonItem = closeButton
        }
        
        validation()
        setLocalizableString()
    }
    
    // MARK:- キーボード関連
    
    // 任意の箇所をタッチするとキーボードが閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        validation()
        view.endEditing(true)
    }
    
    private func setLocalizableString() {
        profileImageButton.setTitle(LStrings.profileImage.value, for: .normal)
        mailTitleLabel.text = LStrings.emailAddress.value
        passwordTitleLabel.text = LStrings.password.value
        usernameTitleLabel.text = LStrings.username.value
        confirmButton.setTitle(LStrings.enter.value, for: .normal)
        logoutButton.setTitle(LStrings.logout.value, for: .normal)
    }
    
    // キーボード開閉で呼び出すメソッドをNotificationCenterに追加する
    private func setupNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // キーボードが開いたときに呼ばれるメソッド
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        if !isChangedCurrentTestField { return }
        if let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue {
            let keyboardHeightFromViewBottom = keyboardFrame.height + view.safeAreaInsets.bottom
            let upRange = keyboardHeightFromViewBottom - currentTextFieldHeightFromViewBottom
            if upRange > 0 {
                print("up: \(upRange)")
                stackViewCenterY.constant = -upRange
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        print("hide")
        stackViewCenterY.constant = 0
    }
    
    @objc func close() {
        dismiss(animated: true)
    }
    
    /// 入力値が正しい場合のみ確定ボタンを有効にします。
    func validation() {
        let emailValidation = (mailTextField.text ?? "").isMail()
        
        // passwordの文字数が6~12に収まっているかどうか
        let isPasswordCount6To12 = (passwordTextField.text?.count ?? 0) >= 6 && (passwordTextField.text?.count ?? 0) <= 12
        // passwordの文字列が英数字のみかどうか
        let isPasswordAlphaNumeric = passwordTextField.text?.isAlphanumeric() ?? false
        
        let passwordValidation = isPasswordCount6To12 && isPasswordAlphaNumeric
        
        if emailValidation && passwordValidation && usernameTextField.text!.count > 0{
            confirmButton.isEnabled = true
            confirmButton.layer.backgroundColor = UIColor.systemIndigo.cgColor
        } else {
            confirmButton.isEnabled = false
            confirmButton.layer.backgroundColor = UIColor.lightGray.cgColor
        }
    }
    // MARK:- 画像保存
    // DocumentディレクトリのfileURLを取得
    func getDocumentsURL() -> NSURL {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as NSURL
        return documentsURL
    }
    // ディレクトリのパスにファイル名をつなげてファイルのフルパスを作る
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsURL().appendingPathComponent(filename)
        return fileURL!.path
    }
    //画像を保存するメソッド
    func saveImage (image: UIImage, path: String ) -> Bool {
        let jpgImageData = image.jpegData(compressionQuality:0.5)
        do {
            try jpgImageData!.write(to: URL(fileURLWithPath: path), options: .atomic)
        } catch {
            print(error)
            return false
        }
        return true
    }
    
    // MARK:- IBAction
    @IBAction func tappedProfileImageButton() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.view.accessibilityIdentifier = "imagePicker_view"
        self.present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func mailTextFieldTappedDone(_ sender: Any) {
        validation()
    }
    @IBAction func passwordTextFieldTappedDone(_ sender: Any) {
        validation()
    }
    @IBAction func usernameTextFieldTappedDone(_ sender: Any) {
        validation()
    }
    @IBAction func tappedConfirmButton(_ sender: Any) {
        CommonData.loginModel.userConfig.loginType = "mail"
        if let image = profileImageButton.imageView?.image {
            let photoUrl = fileInDocumentsDirectory(filename: "photoURL")
            if saveImage(image: image, path: photoUrl) {
                CommonData.loginModel.userConfig.photoURL = URL(fileURLWithPath: photoUrl)
            }
        }
        CommonData.loginModel.userConfig.userID = mailTextField.text
        CommonData.loginModel.userConfig.password = passwordTextField.text
        CommonData.loginModel.userConfig.displayName = usernameTextField.text
        CommonData.loginModel.userConfig.latestLoginDate = Date.current()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func tappedLogoutButton(_ sender: Any) {
        CommonData.loginModel.userConfig.removeUser()
        dismiss(animated: true)
    }
}


extension AccountPropertyViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editImage = info[.editedImage] as? UIImage {
            profileImageButton.setImage(editImage.withRenderingMode(.alwaysOriginal), for: .normal)
        } else if let originalImage = info[.originalImage] as? UIImage {
            profileImageButton.setImage(originalImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        profileImageButton.imageView?.contentMode = .scaleAspectFill
        profileImageButton.contentHorizontalAlignment = .fill
        profileImageButton.contentVerticalAlignment = .fill
        profileImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}

extension AccountPropertyViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // テキストフィールドのviewから見たyを算出
        let y = textField.superview!.frame.minY + textField.superview!.superview!.frame.minY + textField.superview!.superview!.superview!.frame.minY + textField.frame.height
        let h = view.frame.height
        // viewの高さからテキストフィールドのviewから見たyを引くと下からの高さが出る。
        // これがキーボードの高さより低い場合は位置を上げます。
        currentTextFieldHeightFromViewBottom = h - y
        isChangedCurrentTestField = true
    }
}
