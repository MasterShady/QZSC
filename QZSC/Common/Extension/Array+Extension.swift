//
//  Array+Extension.swift
//  UmerChat
//
//  Created by zx on 2022/7/5.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import Foundation

extension Array {
    mutating func safeAppend(_ object: Iterator.Element?) {
        if let o = object {
            self.append(o)
        } else {
            printLog("Warning! Array:\(self) add an nil element")
        }
    }
    
    subscript (safety index: Index) -> Iterator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
    
    // 数组去重复
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
               result.append(value)
            }
        }
        return result
   }
}
