//
//  DisplayModeTableViewCell.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/06.
//

import UIKit

class DisplayModeTableViewCell: UITableViewCell {
    @IBOutlet weak var displayModeSegmentedControl: UISegmentedControl!
    
    @IBAction func changedDisplayMode(_ sender: Any) {
        CommonData.filterModel.displayMode = DisplayMode.allCases[displayModeSegmentedControl.selectedSegmentIndex]
    }
}
