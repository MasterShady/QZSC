//
//  DDDQQLoginFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDAutoLoginPlatformBaseFFF.h"
#import "DDDQuickFaceModelFFF.h"
#import "DDDQuickLoginModelFFF.h"
#import "DDDQQLoginToken8xFFF.h"
#import "DDDQQLoginTokenServerFFF.h"
#import "DDDStackFFF.h"
#import "DDDQuickTypeModelFFF.h"
#import "DDDConstFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDQQLoginFFF : DDDAutoLoginPlatformBaseFFF

@property(nonatomic,strong)DDDQuickFaceModelFFF * face_verify_switch;
@property(nonatomic,strong)DDDQuickLoginModelFFF * qq_orderInfo;

@property(nonatomic,copy)void(^reloadBlock)(void);
@property(nonatomic,copy)void(^loginErrorBlock)(DDDErrorCode,NSString *);

@end

NS_ASSUME_NONNULL_END
