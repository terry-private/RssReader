//
//  Extension_AnyObserverConvertible.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/07/03.
//

import RxSwift
import RxRelay
import CoreMedia

protocol AnyObserverConvertible {
    associatedtype Element
    func accept(_: Element)
}

extension BehaviorRelay: AnyObserverConvertible {}
extension PublishRelay: AnyObserverConvertible {}

extension AnyObserverConvertible {
    func asObserver() -> AnyObserver<Element> {
        .init { event in
            guard case .next(let element) = event else { return }
            self.accept(element)
        }
    }
}
