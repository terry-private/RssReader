//
//  FacebookModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit

class FacebookModel: NSObject, SNSAuthenticateProtocol {
    static let sharedInstance = FacebookModel()
    var snsID = ""
    var snsToken = ""
    
    func authenticate(fromViewController: UIViewController) {
    }
    func fetchUserData() {
        
    }
}
