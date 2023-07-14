//
//  QZSCServiceObject.swift
//  QZSCUpperBizComponent
//
//  Created by zx on 2021/8/6.
//

import UIKit

public enum QZSCResponseType: Int {
    case Response_Fail = 0
    case Response_Succ
    case Response_Error
    case Response_Timeout
    case Response_NoNet
}

public class QZSCServiceObject {
    public var state: QZSCResponseType?
    public var data: Any?
    public var errorCode: String?
    public var msg: String?
    
    public init() {
    }
    
    public class func objectWith(state: QZSCResponseType, data: Any, msg: String) -> QZSCServiceObject {
        let obj = QZSCServiceObject()
        obj.state = state
        obj.data = data
        obj.msg = msg
        return obj
    }
}
