//
//  CouponCollectionViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/31.
//

import UIKit
import WebKit

class CouponCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var filmButton: UIButton!
    weak var delegate: SelectShopDelegate?
    var selectedRestaurant: Bool = false {
        didSet{
            filmButton.backgroundColor = selectedRestaurant ? .clear : .systemFill
        }
    }
    var restaurant: Restaurant? {
        didSet{
            if let url = URL(string: restaurant?.couponURL ?? "") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
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
