//
//  Extensions.swift
//  LocalizationTools
//
//  Created by Cihan Kisakurek on 11.05.22.
//

import Foundation

extension Array where Element: Hashable {
    var isUnique: Bool {
        var seen = Set<Int>()
        return allSatisfy { seen.insert($0.hashValue).inserted }
    }
}

extension String {
    func count(of needle: Character) -> Int {
        return reduce(0) {
            $1 == needle ? $0 + 1 : $0
        }
    }
}
