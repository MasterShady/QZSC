//
//  QZSCControllerManager.h
//  QZSC
//
//  Created by LN C on 2023/7/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QZSCControllerManager : NSObject
+ (UIWindow *)keyWindow;

+ (UIViewController *)currentVC;

+ (UINavigationController *)currentNavVC;

+ (UINavigationController *)getCurrentVCFrom:(UIViewController *)rootVC;
@end

NS_ASSUME_NONNULL_END
