//
//  QZSCControllerManager.m
//  QZSC
//
//  Created by lsy on 2023/7/19.
//

#import "QZSCControllerManager.h"

@implementation QZSCControllerManager

+ (UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        NSArray *scenes = [[UIApplication sharedApplication] connectedScenes];
        for (UIWindowScene *windowScene in scenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.keyWindow) {
                        return window;
                    }
                }
            }
        }
        for (UIWindowScene *windowScene in scenes) {
            for (UIWindow *window in windowScene.windows) {
                return window;
            }
        }
    }
    return [UIApplication sharedApplication].keyWindow;
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)currentVC {
    //获取根控制器
    UIViewController *rootVC = [QZSCControllerManager keyWindow].rootViewController;
   
    UIViewController *parent = rootVC;
    //遍历 如果是presentViewController
    while ((parent = rootVC.presentedViewController) != nil ) {
        rootVC = parent;
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)rootVC;
        if ([tabbarVC selectedViewController] != nil) {
            rootVC = tabbarVC.selectedViewController;
        }
    }
  
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    return rootVC;
}

+ (UINavigationController *)currentNavVC {
    UIViewController *rootVC = [QZSCControllerManager keyWindow].rootViewController;
    return [QZSCControllerManager getCurrentVCFrom:rootVC];
}

 
+ (UINavigationController *)getCurrentVCFrom:(UIViewController *)rootVC {
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbarVC = (UITabBarController *)rootVC;
        if ([tabbarVC selectedViewController]) {
            return [QZSCControllerManager getCurrentVCFrom:tabbarVC.selectedViewController];
        }
    } else if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navVC = (UINavigationController *)rootVC;
        UIViewController *topVC = navVC.topViewController;
        if ([topVC presentedViewController]) {
            return [QZSCControllerManager getCurrentVCFrom:topVC.presentedViewController];
        }
        return [QZSCControllerManager getCurrentVCFrom:topVC];
    } else {
        if ([rootVC presentedViewController]) {
            return [QZSCControllerManager getCurrentVCFrom:rootVC.presentedViewController];
        }
    }
    return rootVC.navigationController;
}

@end
