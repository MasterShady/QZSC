//
//  DDDRequestTasksFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDQuickLoginModelFFF.h"
#import "DDDWxLoginCodeModelFFF.h"

#import "DDDModelBaseFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDRequestTasksFFF : NSObject

+(void)sw_loginGame_checkDeviceUidWithuncode:(NSString *)lockcode
                                withCallBack:(void(^)(BOOL,NSString *))callback;
/// QQ 上号获取上号信息
/// - Parameters:
///   - uncode: 解锁码
///   - callback: 数据回调
///
///
+(void)sw_logingame_qq_getOrderInfoWithUncode:(NSString *)uncode
                                 withCallBack:(void(^)(NSInteger,NSString * __nullable,DDDQuickLoginModelFFF* __nullable))callback;



+(void)sw_logingame_wx_joinTokenQueueWithOrderId:(NSString *)orderId
                                    WithCallBack:(void(^)(NSInteger ))callback;

+(void)sw_logingame_wx_resetDataWithOrderId:(NSString *)orderId
                               WithCallBack:(void(^)(NSInteger ,NSString*))callback;

+(void)sw_logingame_wx_joinResetQueueWithOrderId:(NSString *)orderId
                                    WithCallBack:(void(^)(NSInteger ))callback;

+(void)sw_logingame_wx_getTokenWithOrderId:(NSString *)orderId
                              WithCallBack:(void(^)(NSInteger ,NSString*))callback;



+(void)sw_logingame_qq_faceverify_reportWithChk:(NSInteger)chkId
                                       withMemo:(NSString *)memo
                                       Withface:(NSInteger)isface
                                       WithType:(NSInteger)type
                                   WithCallBack:(void(^)(NSInteger,NSString*))callback;

+(void)sw_wx_login_reportwithQueue_id:(NSString *)queueId
                         withOrder_id:(NSString *)orderid
                           withUncode:(NSString *)uncode
                               withStatus:(NSString *)status
                           withRemark:(NSString *)remark
                     withQuickVersion:(NSString *)quickVerison
                         WithCallBack:(void(^)(NSInteger,NSString*))callback;

+(void)sw_zht_login_requestWithBusniss:(NSString *)businessType
                          WithOpenMode:(NSString *)openmode
                                withpt:(NSString *)pt
                      withbusinessData:(NSString *)businessData
                          withsuccessBack:(void(^)(DDDModelBaseFFF*))successBack
                         withErrorBack:(void(^)(NSString *))failBack;
@end




NS_ASSUME_NONNULL_END
