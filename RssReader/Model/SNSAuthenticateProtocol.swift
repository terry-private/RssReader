//
//  SNSAuthenticateProtocol.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit

protocol SNSAuthenticateProtocol {
    // 各 SNS 固有の uid を保持する
    var snsID: String { get }
    
    // 各 SNS の認証で取得した token を保持する
    var snsToken: String { get }
    
    // 各 SNS サービスの認証結果を処理する
    func authenticate(fromViewController: UIViewController)
    
    // 各 SNS サービスのユーザー情報を取得する
    func fetchUserData()
}
