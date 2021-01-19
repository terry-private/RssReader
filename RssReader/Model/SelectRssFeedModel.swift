//
//  SelectRssFeedModel.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/01/03.
//

import Foundation

protocol SelectRssFeedModelProtocol {
    var rssFeedList: [String] {get set}
    var selectedRssFeedList: Set<String> {get set}
}


class SelectRssFeedModel: SelectRssFeedModelProtocol {
    var rssFeedList: [String]
    var selectedRssFeedList: Set<String>
    init() {
        rssFeedList = ["test1", "test2"]
        selectedRssFeedList = Set<String>()
    }
    
}
