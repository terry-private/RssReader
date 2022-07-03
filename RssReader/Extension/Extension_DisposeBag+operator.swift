//
//  Extension_DisposeBag+operator.swift
//  RssReader
//
//  Created by 若江照仁 on 2022/07/03.
//

import RxSwift

/// ~> を優先して計算させたいから必須
/// 例 a ~ b ~> c の場合 a ~ ( b~> c ) と同じ計算順序になる
precedencegroup DisposePrecedence {
    associativity: left
    lowerThan: DefaultPrecedence
}

infix operator ~ : DisposePrecedence

extension DisposeBag {
    
    @discardableResult
    static func ~ (disposeBag: DisposeBag, disposable: Disposable) -> DisposeBag {
        disposable.disposed(by: disposeBag)
        return disposeBag
    }
}

extension Array where Element == Disposable {
    
    public static func ~ (disposables: Array, disposeBag: DisposeBag) {
        disposables.forEach { $0.disposed(by: disposeBag) }
    }
    
    public static func ~ (disposeBag: DisposeBag, disposables: Array) {
        disposables.forEach { $0.disposed(by: disposeBag) }
    }
    
    public static func ~ (disposables: Array, disposable: Disposable) -> [Disposable] {
        return disposables + [disposable]
    }
    
    public static func ~ (disposables1: Array, disposables2: Array) -> [Disposable] {
        return disposables1 + disposables2
    }
    
}

func ~ (disposable1: Disposable, disposable2: Disposable) -> [Disposable] {
    return Array(arrayLiteral: disposable1, disposable2)
}
