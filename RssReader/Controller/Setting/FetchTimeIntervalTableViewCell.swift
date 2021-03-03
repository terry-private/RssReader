//
//  FetchTimeIntervalTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/03.
//

import UIKit

class FetchTimeIntervalTableViewCell: UITableViewCell {
    @IBOutlet weak var fetchTimeIntervalSegmentedControl: UISegmentedControl!
    private let timeIntervals = [1, 3, 5, 10]
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func ChangedFetchTimeInterval(_ sender: Any) {
        CommonData.filterModel.fetchTimeInterval = timeIntervals[fetchTimeIntervalSegmentedControl.selectedSegmentIndex]
    }
}
