//
//  DFAppDelegate.h
//  PKGModule
//
//  Created by 刘思源 on 2023/7/31.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DF_PKGManager.h"

@import UserNotifications;

NS_ASSUME_NONNULL_BEGIN

@interface DFAppDelegate : UIResponder <UIApplicationDelegate,DF_PKGDelegate>

@property (nonatomic, strong) UIWindow *window;

@end

NS_ASSUME_NONNULL_END
