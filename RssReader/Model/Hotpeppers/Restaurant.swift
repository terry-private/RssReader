//
//  Restaurant.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/27.
//

import Foundation

struct Restaurant: Equatable {

    var id: String
    var name: String
    var couponUrl: String
    var imageURL: String
    var latitude: Double
    var longitude: Double
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id
}
