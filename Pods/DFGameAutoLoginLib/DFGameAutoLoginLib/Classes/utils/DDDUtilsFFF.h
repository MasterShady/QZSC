//
//  DDDUtilsFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern inline dispatch_source_t DDDTimer(NSInteger step,void(^block)(void));

FOUNDATION_EXTERN_INLINE UIImage * DDDGetImageFFF(NSString * name,BOOL adjust);

FOUNDATION_EXTERN_INLINE CGFloat DDDScale_Height(CGFloat height);

FOUNDATION_EXTERN_INLINE CGFloat DDDScale_Width(CGFloat width);

FOUNDATION_EXTERN_INLINE void DDDToast(NSString * message);

#define DDDScreenWidth CGRectGetWidth(UIScreen.mainScreen.bounds)

#define DDDScreenHeight CGRectGetHeight(UIScreen.mainScreen.bounds)

#define DDDSTATUSBAR_HEIGHT  CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)

#define DDDBOTTOM_HEIGHT (DDDSTATUSBAR_HEIGHT > 20 ? 34 : 0)

#define DDDTabbarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height > 20 ? 83:49)

#define WeakObj(o)  __weak typeof(o) weakSelf = o;

#define StrongObj(o)  __strong typeof(o) strongSelf = o;


@interface DDDUtilsFFF : NSObject

+(NSDictionary *)dicFRomJson:(NSString *)json;

+(NSString *)jsonFromDic:(NSDictionary *)dic;

+ (NSString *)getNowTimeTimestamp;

+(NSString *)zhongtai_aesKey;

+(id)zhongTai_dataWith:(NSString *)data
        withModelClass:(Class)modelClass;

+ (UIViewController *)getCurrentViewController ;

+(NSString *)getAppVersion;

+ (NSString*)base64Decode:(NSString*)str;

+(NSDictionary *)httpSign:(NSDictionary *)datas
                  withkey:(NSString *)key;


/**
 生成十六进制AES 秘钥
 */
+ (NSString *)random128BitAESKey;

/**
 data转换为十六进制的string
 */
+ (NSString *)hexStringFromData:(NSData *)myD;

/**
 16进制字符串转data
 */
+  (NSData *)convertHexStrToData:(NSString *)str;


+ (NSBundle *)getCurrentBundle;

/**
 先对加密后生成的byte数组加密，加密后转成16进制字符串
 */
+  (NSString *)md5ForBytesToLower32Bate:(NSString *)str;


+ (NSDictionary *)turnStringToDictionary:(NSString *)turnString;

+ (NSString *)getParamByName:(NSString *)name URLString:(NSString *)url;

+ (NSString *)hmcloud_generateCToken:(NSString * )pkgName
                          withUserId:(NSString *)userId
                          withUserToken:(NSString *)userToken
                     withAccessKey:(NSString *)accessKey
                          withAccessKeyId:(NSString *)accessKeyId
                       withChannelId:(NSString *)channelId;

+(NSString *)hexTobyte:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
