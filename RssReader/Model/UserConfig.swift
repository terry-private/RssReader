//
//  UserConfig.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation

protocol UserConfigProtocol {
    var userID: String? {get set}
    var photoURL: URL? {get set}
    var displayName: String? {get set}
    var latestLoginDate: Date? {get set}
    func removeUser()
}

class UserConfig: UserConfigProtocol {
    var userID: String? {
        get {
            return UserDefaults.standard.string(forKey: "userID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userID")
        }
    }
    var photoURL: URL? {
        get {
            return UserDefaults.standard.url(forKey: "photoURL")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "photoURL")
        }
    }
    var displayName: String? {
        get {
            return UserDefaults.standard.string(forKey: "displayName")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "displayName")
        }
    }
    var latestLoginDate: Date? {
        get {
            return UserDefaults.standard.object(forKey: "latestLoginDate") as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "latestLoginDate")
        }
    }
    func removeUser() {
        UserDefaults.standard.removeObject(forKey: "userID")
        UserDefaults.standard.removeObject(forKey: "photoURL")
        UserDefaults.standard.removeObject(forKey: "displayName")
        UserDefaults.standard.removeObject(forKey: "latestLoginDate")
    }
}
