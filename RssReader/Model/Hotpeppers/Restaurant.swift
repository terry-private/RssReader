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
    var couponURL: String
    var photoURL: String
    var latitude: Double
    var longitude: Double
    static func from(_ shop: Shop) -> Self{
        return Restaurant(
            id: shop.id,
            name: shop.name,
            couponURL:
                shop.coupon_urls.pc,
            photoURL: shop.photo.pc.l,
            latitude: shop.lat,
            longitude: shop.lng
        )
    }
}
struct RestaurantCodableObject: Codable {
    var results: Shops
}
struct Shops: Codable {
    var shop: [Shop]
}
struct Shop: Codable {
    var id: String
    var name: String
    var coupon_urls: CouponURL
    var photo: PhotoType
    var lat: Double
    var lng: Double
}
struct PhotoType: Codable {
    var pc: PhotoURL
}
struct PhotoURL: Codable {
    var l: String
}
struct CouponURL: Codable {
    var pc: String
}

func ==(lhs: Restaurant, rhs: Restaurant) -> Bool {
    return lhs.id == rhs.id
}
