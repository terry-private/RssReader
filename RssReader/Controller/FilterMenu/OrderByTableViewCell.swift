//
//  OrderByTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/26.
//

import UIKit

class OrderByTableViewCell: UITableViewCell {
    @IBOutlet weak var orderBySegmentedControl: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // セグメント毎のタイトルをローカライズ
        for i in 0...1 {
            let title = i == 0 ? LStrings.descending.value : LStrings.ascending.value
            orderBySegmentedControl.setTitle(title, forSegmentAt: i)
        }
        orderBySegmentedControl.setTitleTextAttributes( [NSAttributedString.Key.foregroundColor:UIColor(named: "MainLabel")!], for: .normal)
    }
    @IBAction func orderByChanged(_ sender: Any) {
        CommonData.filterModel.orderByDesc = orderBySegmentedControl.selectedSegmentIndex == 0
    }
}
