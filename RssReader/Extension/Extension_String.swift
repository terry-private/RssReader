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
    /// mailアドレスとして正しいかどうか
    /// - Parameter mail: メールアドレス String型
    /// - Returns: Bool型で返します。
    func isMail() -> Bool {
        let mailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let mailPredicate = NSPredicate(format:"SELF MATCHES %@", mailFormat)
        return mailPredicate.evaluate(with: self)
    }
}
