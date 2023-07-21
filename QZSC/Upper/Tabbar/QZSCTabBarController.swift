//
//  QZSCTabBarController.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import UIKit

@_exported import SnapKit
@_exported import RxCocoa
@_exported import RxSwift
@_exported import Kingfisher
@_exported import MJRefresh
import SwiftUI

class QZSCTabBarController: UITabBarController {
    
    private var tempIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().isHidden = true
        UITabBar.appearance().tintColor = COLOR000000
        UITabBar.appearance().unselectedItemTintColor = COLOR999999
        UITabBar.appearance().backgroundColor = .white
        
        tabBar.layer.shadowColor = UIColor(red: 0.54, green: 0.54, blue: 0.54, alpha: 0.07).cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 2)
        tabBar.layer.shadowOpacity = 1
        tabBar.layer.shadowRadius = 20
        
        delegate = self
        
        loadChildController()
        
//        MSZLoginCenter.shared.loginSuccessComplete = {
//            ICSControllerUtil.currentNavVC()?.popToRootViewController(animated: true)
//            if !MSZLoginCenter.shared.isLogin {
//                self.tempIndex = 0
//            }
//            self.setTab(with: self.tempIndex)
//        }
    }
    
    private func loadChildController() {
        let params = [(className: "QZSCHomeController", title: "首页", imageName: "home"),
                      (className: "QZSCOrderController", title: "订单", imageName: "order"),
                      (className: "QZSCCheckInController", title: "入住", imageName: "checkin"),
                      (className: "QZSCMyController", title: "我的", imageName: "my")]
        for item in params {
            if item.className == "QZSCMyController" {
                //MineUIView
                let vc = UIHostingController(rootView: MineUIView(userData: QZSCLoginManager.shared.userInfo))
                vc.title = item.title
                vc.tabBarItem.image = UIImage(named: "tabbar_\(item.imageName)_nor")?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = UIImage(named: "tabbar_\(item.imageName)_sel")?.withRenderingMode(.alwaysOriginal)
                addChild(vc)
                continue
            }
            
            if let vcClass = NSClassFromString("\(kNameSpace).\(item.className)") as? QZSCBaseController.Type {
                let vc = vcClass.init()
                vc.title = item.title
                vc.tabBarItem.image = UIImage(named: "tabbar_\(item.imageName)_nor")?.withRenderingMode(.alwaysOriginal)
                vc.tabBarItem.selectedImage = UIImage(named: "tabbar_\(item.imageName)_sel")?.withRenderingMode(.alwaysOriginal)
                addChild(vc)
            }
        }
    }
    
    private func setTab(with: Int)  {
        guard with < viewControllers?.count ?? 0 else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.selectedIndex = with
        }
    }
}

extension QZSCTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
//        let index = self.viewControllers?.firstIndex(of: viewController) ?? 0
//        switch index {
//        case 1,3: // 订单、我的, 需要验证登录
//            tempIndex = index
//            if !QZSCLoginManager.shared.isLogin { // 未登录
//                let ctl = QZSCLoginController()
//                ctl.fromMainTab = true
//                QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
//                return false
//            }
//        default :
//            break
//        }
        return true
    }
    
}
