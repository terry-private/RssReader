//
//  Either.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/05/21.
//

import Foundation

/// 型 A か型 B のどちらかのオブジェクトを表す型。
/// たとえば、Either<String, Int> は文字列か整数のどちらかを意味する。
/// なお、慣例的にどちらの型かを左右で表現することが多い。
enum Either<Left, Right> {
    /// Eigher<A, B> の A の方の型。
    case left(Left)

    /// Eigher<A, B> の B の方の型。
    case right(Right)


    /// もし、左側の型ならその値を、右側の型なら nil を返す。
    var left: Left? {
        switch self {
        case let .left(x):
            return x

        case .right:
            return nil
        }
    }

    /// もし、右側の型ならその値を、左側の型なら nil を返す。
    var right: Right? {
        switch self {
        case .left:
            return nil

        case let .right(x):
            return x
        }
    }
}
