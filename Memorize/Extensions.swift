//
//  Utils.swift
//  Memorize
//
//  Created by Sanjay Katta on 20/02/22.
//

import Foundation

extension String {
    /// `toStringArray` create an array of strings
    ///  print("String".toStringArray())
    ///  // prints ["S", "t", "r", "i", "n", "g"]
    /// - Returns: Array<String>
    func toStringArray() -> [String] {
        Array(self).map(String.init)
    }
}

extension Array {
    var oneAndOnly: Element? {
        self.count == 1 ? self.first : nil
    }
}
