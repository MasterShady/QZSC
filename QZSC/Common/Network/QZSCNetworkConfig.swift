//
//  QZSCNetworkConfig.swift
//  QZSCBasicBizComponent
//
//  Created by sjc on 2021/6/9.
//

import Foundation

public class QZSCNetworkConfig {

    public static var shared = QZSCNetworkConfig()

    private init() {}

    public var dlTarget: DLTarget = DLTarget.init(baseURL: QZSCAppEnvironment.shared.serverApi)
}
