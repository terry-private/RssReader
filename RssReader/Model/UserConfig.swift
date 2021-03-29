//
//  UserConfig.swift
//  RssReader
//
//  Created by 若江照仁 on 2020/12/26.
//

import Foundation
import KeychainAccess

protocol UserConfigProtocol {
    var loginType: String? { get set }
    var userID: String? {get set}
    var password: String? {get set}
    var photoURL: URL? {get set}
    var displayName: String? {get set}
    var latestLoginDate: Date? {get set}
    func removeUser()
}

class UserConfig: UserConfigProtocol {
    let keyChain = Keychain()
    var loginType: String? {
        get {
            return keyChain["loginType"]
        }
        set {
            keyChain["loginType"] = newValue
        }
    }
    var password: String? {
        get {
            return keyChain["password"]
        }
        set {
            keyChain["password"] = newValue
        }
    }
    var userID: String? {
        get {
            return keyChain["userID"]
        }
        set {
            keyChain["userID"] = newValue
        }
    }
    var photoURL: URL? {
        get {
            if loginType == "mail" {
                return URL(fileURLWithPath: keyChain["photoURL"] ?? "")
            }
            return URL(string: keyChain["photoURL"] ?? "")
        }
        set {
            if loginType == "mail" {
                keyChain["photoURL"] = newValue?.path
            } else {
                keyChain["photoURL"] = newValue?.description
            }
            
        }
    }
    var displayName: String? {
        get {
            return keyChain["displayName"]
        }
        set {
            keyChain["displayName"] = newValue
        }
    }
    var latestLoginDate: Date? {
        get {
            return Date(japan: keyChain["latestLoginDate"] ?? "")
        }
        set {
            keyChain["latestLoginDate"] = newValue?.longDate()
        }
    }
    func removeUser() {
        keyChain["loginType"] = nil
        keyChain["userID"] = nil
        keyChain["password"] = nil
        keyChain["photoURL"] = nil
        keyChain["displayName"] = nil
        keyChain["latestLoginDate"] = nil
    }
}
