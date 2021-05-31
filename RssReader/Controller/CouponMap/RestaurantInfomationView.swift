//
//  RestaurantInfomationView.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/28.
//

import UIKit
import Nuke

class RestaurantInfomationView: UIView {
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var labelBackView: UIView!
    @IBOutlet weak var labelShadowView: UIView!
    var restaurant: Restaurant? {
        didSet {
            if let url = URL(string: restaurant?.photoURL ?? "") {
                Nuke.loadImage(with: url, into: photoImageView)
            }
            nameLabel.text = restaurant?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let radius = photoImageView.bounds.height/2
        photoImageView.layer.cornerRadius = radius
        photoImageView.layer.borderWidth = 1
        photoImageView.layer.borderColor = UIColor.gray.cgColor
        labelBackView.layer.cornerRadius = radius
        labelShadowView.layer.cornerRadius = radius
    }
}
