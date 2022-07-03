//
//  Extension_ObservableType+operator.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/07/03.
//

import RxSwift

infix operator ~> : DefaultPrecedence

extension ObservableType {
    static func ~> <O>(observable: Self, observer: O) -> Disposable where O: ObserverType, O.Element == Element {
        return observable.bind(to: observer)
    }
    static func ~> <O>(observable: Self, observer: O) -> Disposable where O: ObserverType, O.Element == Element? {
        return observable.bind(to: observer)
    }
}
