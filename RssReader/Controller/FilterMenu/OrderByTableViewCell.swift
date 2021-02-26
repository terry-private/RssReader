//
//  OrderByTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class OrderByTableViewCell: UITableViewCell {
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func orderByChanged(_ sender: Any) {
        CommonData.filterModel.orderByDesc = orderBySegmentedControl.selectedSegmentIndex == 0
    }
}
