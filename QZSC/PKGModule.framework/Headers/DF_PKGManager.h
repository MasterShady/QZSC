//
//  DF_PKGManager.h
//  PKGModule-PKGModule
//
//  Created by 刘思源 on 2023/7/25.
//

#import <Foundation/Foundation.h>
#import "DF_PKGConfig.h"
#import "OfflinePackageController.h"
#import "DF_Const.h"

NS_ASSUME_NONNULL_BEGIN
@protocol DF_PKGInitThird <NSObject>

+ (void)df_initThirdWithConfig:(DF_PKGConfig *)config;

@end

@protocol DF_PKGDelegate

- (void)df_initPush;
- (void)df_endLoadingWithError:(NSError *)error;

//以下方法在DFAppdelegate中都有默认实现, 只需保证项目的AppDelegate继承自DFAppdelegate即可.
- (void)df_controllerReady:(OfflinePackageController *)controller;
- (void)df_userLoginSuccess:(NSDictionary *)info;
- (void)df_userLogout;
- (void)df_requestNotificationWithStatus:(void(^)(BOOL notificationAvaliable))hander;
- (void)df_onLoadProgress:(CGFloat)progress;


@end


@interface DF_AppInfo : NSObject

@property (nonatomic, assign) BOOL notificationAvaliable;

@property (nonatomic, strong) NSString *idfa;

@property (nonatomic, strong) NSString *shumeiId;

@property (nonatomic, assign) UIInterfaceOrientationMask orientation;

@end


@interface DF_PKGManager : NSObject

+ (void)df_preparePKG:(DF_PKGConfig *)config delegate:(id <DF_PKGDelegate>)delegate;

@property (class) DF_PKGConfig *df_config;
@property (class) NSString *df_token;
@property (class, readonly) DF_AppInfo *appInfo;
@property (class) UIInterfaceOrientationMask orientation;
@property (class, readonly) BOOL df_isLoadedBefore;

+ (void)df_pageLoadCompleted;

+ (UIViewController *)df_launchViewControllerWithImage:(UIImage * _Nullable)image;

#pragma mark - AppDelegate Method

+ (void)applicationWillEnterForeground:(UIApplication *)application;

+ (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window;


#pragma mark - 业务相关
+ (void)userLoginSuccess:(NSDictionary *)info;
//
+ (void)userLogout;

+ (void)df_reportIDFA:(NSString *)idfa;

+ (void)df_reportShumeiId:(NSString *)shumeiId;

+ (void)df_initPush;

+ (void)df_faceVerifyErrorWithMsg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
