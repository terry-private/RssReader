//
//  CouponCollectionViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/31.
//

import UIKit
import Nuke

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var restaurantImage: UIImageView!
    @IBOutlet weak var filmButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    weak var delegate: SelectShopDelegate?
    var pageNumber = 0
    var selectedRestaurant: Bool = false {
        didSet{
            filmButton.backgroundColor = selectedRestaurant ? .clear : .black
        }
    }
    var restaurant: Restaurant? {
        didSet{
            Nuke.loadImage(with: URL(string: "https://www.hotpepper.jp/favicon.ico")!, into: headerImage)
            if let url = URL(string: restaurant?.photoURL ?? "") {
                Nuke.loadImage(with: url, into: restaurantImage)
            }
            nameLabel.text = restaurant?.name
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = 20
    }
    @IBAction func tappedCell(_ sender: Any) {
        delegate?.selectAt(restaurant: restaurant!)
    }
}
