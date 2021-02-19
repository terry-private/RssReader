//
//  Extension_Dictionary.swift
//  RssReader
//
//  Created by 若江照仁 on 2021/02/15.
//

extension Dictionary {
    public func union(_ other: Dictionary) -> Dictionary {
        var tmp = self
        other.forEach { tmp[$0.0] = $0.1 }
        return tmp
    }
}

public func +<K, V>(_ lhs: Dictionary<K, V>, _ rhs: Dictionary<K, V>) -> Dictionary<K, V> {
    return lhs.union(rhs)
}

public func +=<K, V>(lhs: inout Dictionary<K, V>, rhs: Dictionary<K, V>) {
    lhs = lhs + rhs
}
