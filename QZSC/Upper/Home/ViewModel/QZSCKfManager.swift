//
//  QZSCKfManager.swift
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

import Foundation

class QZSCKfManager {
    static let shared = QZSCKfManager()
    
    private var historyKey: String {
        return "QZSC_Kf_Message_"
    }
    
    var historyMessages: [String] {
        return QZSCCache.fetchObject(key: historyKey, to: [String].self) ?? []
    }
    
    init() {
    }
    
    func addNewHistoryMessage(message: String) {
        var list = QZSCCache.fetchObject(key: historyKey, to: [String].self) ?? []
        list.append(message)
        QZSCCache.cache(object: list, key: historyKey)
    }
    
    func clearAllHistoryTags() {
        QZSCCache.removeData(for: historyKey)
    }
}
