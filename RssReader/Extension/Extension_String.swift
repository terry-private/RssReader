//
//  Extension_String.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/03/22.
//

import Foundation

extension String {
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}
