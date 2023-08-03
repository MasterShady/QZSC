//
//  DDDAutoLoginPlatformProtocolFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDActInfoFFF.h"
#import "DDDLoginGameLoadingViewProtocolFFF.h"

NS_ASSUME_NONNULL_BEGIN

@protocol DDDAutoLoginPlatformProtocolFFF <NSObject>

-(void)loginWithInfo:(DDDActInfoFFF*)info;

-(void)openAppWithUrl:(NSString*)url
          withHandler:(void(^)(BOOL))handler;
-(void)taskCancel;

@property(nonatomic,strong)id<DDDLoginGameLoadingViewProtocolFFF>loadingView;

@end

NS_ASSUME_NONNULL_END
