//
//  DF_PKGConfig.h
//  PKGModule-PKGModule
//
//  Created by 刘思源 on 2023/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DF_PKGInfo : NSObject

@property (nonatomic, strong) NSString *downUrl;

@property (nonatomic, strong) NSString *version;

@property (nonatomic, strong) NSString *md5;

@property (nonatomic, strong) NSString *appVersion;

- (BOOL)df_checkInstalled;

- (NSString *)downloadPath;

- (NSString *)downloadFolderPath;

- (NSString *)unzipPath;



@end


@interface DF_APIEnv : NSObject

+ (instancetype)df_testEnvWithPort:(int)port;

+ (instancetype)df_releaseEnv;

+ (instancetype)df_prereleaseEnv;

// 和 MJHttpServerEnv 一致
@property (nonatomic, assign) int envType;


@property (nonatomic, readonly) NSString *apiHost;

- (BOOL)isProductEnv;

@end


@interface DF_PKGConfig : NSObject

@property (nonatomic, strong) NSString *df_appId;
//app版本
@property (nonatomic, strong) NSString *df_appVersion;

//本地包的路径
@property (nonatomic, strong) NSString *df_localPKGName;

//服务器环境
@property (nonatomic, strong) DF_APIEnv *df_apiEnv;

@property (nonatomic, strong) NSString *df_httpSignKey;

@property (nonatomic, strong) NSString *df_websocketSignKey;

@property (nonatomic, strong) NSString *df_appURLScheme;
//是否检查版本
@property (nonatomic, assign) BOOL df_checkVersion;
//腾讯人脸
@property (nonatomic, strong) NSString *df_txLisence;
//审核日期
@property (nonatomic, strong) NSDate *df_geDate;
//appChannel 上报用
@property (nonatomic, strong) NSString *df_appChannel;

@property (nonatomic, assign) BOOL df_enableWhenNoSimCard;
//前端版本
@property (nonatomic, strong) NSString *df_appVersionCode;



+ (instancetype)df_configWithAppId:(NSString *)appId appVersion:(NSString *)appVersion appChannel:(NSString *)appChannel appURLScheme:(NSString *)urlScheme httpSignKey:(NSString *)httpSignKey websocketSignKey:(NSString *)websocketSignKey txLisence:(NSString *)txLisence apiEvn:(DF_APIEnv *)apiEvn;

- (NSString *)df_wholeUrl:(NSString *)part;

@end

@interface NSString (Trans)

- (NSString *)df_aes256Decode;

@end


NS_ASSUME_NONNULL_END
