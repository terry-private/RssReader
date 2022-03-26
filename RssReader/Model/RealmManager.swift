//
//  RealmManager.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/03/26.
//

import Foundation
import RealmSwift

enum RealmManager {
    static var realm: Realm {
        var config = Realm.Configuration()
        let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.terry.RssReader")
        config.fileURL = url?.appendingPathComponent("db.realm")
        let realm = try! Realm(configuration: config)
        return realm
    }
}
