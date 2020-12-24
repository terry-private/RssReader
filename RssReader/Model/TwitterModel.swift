//
//  TwitterModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit
import OAuthSwift

class TwitterModel: NSObject, SNSAuthenticateProtocol {
    static let sharedInstance = TwitterModel()
    var snsID = ""
    var snsToken = ""
    
    let consumerKey = "5j6ab3gJeJch85KaalvjuKMWk"
    let consumerSecret = "PdKpudhLDkuZxtI7jXzShiBQ0Farl93UMkxERSh29LbL2HAyDP"
    
    func authenticate(fromViewController: UIViewController) {
    }
    func fetchUserData() {
        
    }
    
}
