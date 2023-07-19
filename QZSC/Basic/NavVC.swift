//
//  NavVC.swift
//  gerental
//
//  Created by 刘思源 on 2022/12/14.
//

import UIKit

class NavVC: UINavigationController, UINavigationControllerDelegate {
    static let navBarDefault: Void = {
        let appearance = emptyAppearance
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        if #available(iOS 15.0, *) {
            UINavigationBar.appearance().compactScrollEdgeAppearance = appearance
        }
    }()
    
    
    static let themeAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = UIColor(hexString:"#4765F3")
        return appearance
    }()
    
    static let emptyAppearance: UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = .clear
        appearance.shadowImage = nil
        appearance.backgroundColor = .white
        return appearance
    }()
    
    private let initializer: Void = NavVC.navBarDefault
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.delegate = self

    }
    
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if (self.viewControllers.count > 0){
            viewController.hidesBottomBarWhenPushed = true;
//            if let baseVc = viewController as? BaseVC{
//                baseVc.setBackTitle(baseVc.backTitle ?? "")
//            }
        }
        super.pushViewController(viewController, animated: animated)
    }

    

}
