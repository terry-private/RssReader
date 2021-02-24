//
//  Extension_Date.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation

extension TimeZone {
    static let gmt = TimeZone(secondsFromGMT: 0)!
    static let japan = TimeZone(identifier: "Asia/Tokyo")!
}

extension Locale {
    static let japan = Locale(identifier: "ja_JP")
}
extension DateFormatter {
    static func current(_ dateFormat: String) -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateFormat = dateFormat
        return df
    }
    static func longDateFormatter() -> DateFormatter  {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateStyle = .long
        return df
    }
    static func pubDateFormatter() -> DateFormatter {
        let df = DateFormatter()
        df.timeZone = TimeZone.gmt
        df.locale = Locale.japan
        df.dateFormat = "yyyy/MM/dd HH:mm:ss"
        return df
    }
}

private let longDateFormatter = DateFormatter.longDateFormatter()
private let pubDateFormatter = DateFormatter.pubDateFormatter()

extension Date {
    init() {
        self = Date(timeIntervalSinceNow: TimeInterval(TimeZone.japan.secondsFromGMT()))
    }
    init(string: String) {
        self = pubDateFormatter.date(from: string)!
    }
    
    func longDate() -> String{
        return longDateFormatter.string(from: self)
    }
}
