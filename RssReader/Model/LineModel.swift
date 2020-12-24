//
//  LineModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/23.
//

import UIKit

class LineModel: NSObject, SNSAuthenticateProtocol {
    
    static let sharedInstance = LineModel()
    var snsID = ""
    var snsToken = ""
    
    func authenticate(fromViewController: UIViewController) {
    }
    func fetchUserData() {
        
    }

}
