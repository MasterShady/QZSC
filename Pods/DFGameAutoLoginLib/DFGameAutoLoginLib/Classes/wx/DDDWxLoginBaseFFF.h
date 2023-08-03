//
//  DDDWxLoginFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import <DDDAutoLoginPlatformBaseFFF.h>
#import "DDDQuickLoginInfoModelFFF.h"
#import "DDDConstFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDWxLoginBaseFFF : DDDAutoLoginPlatformBaseFFF

+(instancetype)wechatLoginWith:(DDDQuickLoginInfoModelFFF*__nullable)infoModel;

@property(nonatomic,copy)void(^loginErrorBlock)(DDDErrorCode,NSString*__nullable);

@property(nonatomic,copy)void(^reloadBlock)(NSString *__nullable);

@property(nonatomic,strong)DDDQuickLoginInfoModelFFF *quickModel;

@property(nonatomic,copy)NSString *wx_package_openScheme;

-(NSString * __nullable)tokenDecrypt:(NSString *)withToken;


@end

NS_ASSUME_NONNULL_END
