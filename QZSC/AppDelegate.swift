//
//  AppDelegate.swift
//  QZSC
//
//  Created by zzk on 2023/7/13.
//

import UIKit
import IQKeyboardManagerSwift
import PKGModule

@main
class AppDelegate: DFAppDelegate {
    
    
    
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //let apiEnv = DF_APIEnv.df_test(withPort: 9799)
        
#if DEBUG
        let apiEnv = DF_APIEnv.df_test(withPort: 9799)
#else
        let apiEnv = DF_APIEnv.df_release()
#endif
        
        
        let config = DF_PKGConfig.df_config(withAppId: "500180022", appVersion: "1.0.0.0", appChannel: "appstore_qzsc", appURLScheme: "com.ToyMegaMart", httpSignKey: "ONTBrfPDaig20vE6", websocketSignKey: "OyKL5OMjDuGvcBsW", txLisence: "", apiEvn: apiEnv)
#if DEBUG
        
        config.df_checkVersion = false
#else
        let dateString = "2023-08-05"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString)!
        config.df_geDate = date
#endif
        
        DF_PKGManager.df_preparePKG(config, delegate: self)
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        if (!DF_PKGManager.df_isLoadedBefore){
            window.rootViewController = DF_PKGManager.df_launchViewController(with: nil)
        }else{
            window.rootViewController = UINavigationController(rootViewController: QZSCTabBarController())
        }
        
        return true
    }
    
    override func df_initPush() {
        let entity = JPUSHRegisterEntity()
        entity.types = Int(JPAuthorizationOptions.init([.alert,.badge,.sound]).rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        JPUSHService.setup(withOption: nil, appKey: "67a1f296ee27d6556d580112", channel: "appstore", apsForProduction: false)
    }
    
    override func df_endLoadingWithError(_ error: Error) {
        if window.rootViewController == DF_PKGManager.df_launchViewController(with: nil){
            window.rootViewController = UINavigationController(rootViewController: QZSCTabBarController())
        }
    }
    
}

extension AppDelegate : JPUSHRegisterDelegate {
    
    // MARK: JPush Delegate
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: ((Int) -> Void)) {
        
        let dic = notification.request.content.userInfo
        
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            
            JPUSHService.handleRemoteNotification(dic)
        }
        
        var options:[UNNotificationPresentationOptions] = []
        
        if UIApplication.shared.applicationState != .active {
            options = [.alert,.sound,.badge]
        }
        
        if UIApplication.shared.applicationState == .active {
            options = [.alert,.sound]
        }
        
        
        completionHandler(Int(UNNotificationPresentationOptions.init(options).rawValue))
        
        
    }
    //app 进程活跃的情况下会走此方法（前台或者后台）
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: (() -> Void)) {
        
        
        let dic = response.notification.request.content.userInfo
        
        if let trigger = response.notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            
            JPUSHService.handleRemoteNotification(dic)
        }
        //
        //dataProcessing(dic: dic)
        
        
        completionHandler()
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification) {
        if let trigger = notification.request.trigger, trigger.isKind(of: UNPushNotificationTrigger.self)   {
            print("从通知界面直接进入应用")
        }else{
            print("从通知界面直接进入应用")
        }
    }
    
    func jpushNotificationAuthorization(_ status: JPAuthorizationStatus, withInfo info: [AnyHashable : Any]?) {
        
    }
    
}
