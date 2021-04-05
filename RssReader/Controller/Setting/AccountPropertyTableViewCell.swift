//
//  AccountPropertyTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/17.
//

import UIKit
import Nuke

class AccountPropertyTableviewCell: UITableViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myDisplayNameLabel: UILabel!
    var userConfig: UserConfigProtocol? {
        didSet {
            if let url = userConfig?.photoURL {
                if userConfig?.loginType == "mail" {
                    myImageView.image = UIImage(contentsOfFile: CommonData.loginModel.userConfig.photoURL?.path ?? "")
                } else {
                    Nuke.loadImage(with: url, into: myImageView)
                }
            } else {
                myImageView.image = UIImage(systemName: "person")
            }
            myDisplayNameLabel.text = userConfig?.displayName
        }
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        myImageView.layer.cornerRadius = myImageView.bounds.width / 2
    }
    
}
