//
//  DDDHMCloudGameLoginFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDAutoLoginPlatformBaseFFF.h"






NS_ASSUME_NONNULL_BEGIN

@protocol DDDHMCloudGameLoginProtocolFFF <NSObject>

-(void)SWHMCloudGameLoginTaskError:(NSError * )error;
-(void)SWHMCloudGamePageDidPresent:(UIViewController *)vc;
-(void)SWHMCloudGameLoginSuccess;
-(void)SWHMCloudGameOrderEnd;
-(void)SWHMCloudGameOrderAutoTs;
-(void)SWHMCloudGameCloseDidGame;

@end

@interface DDDHMCloudGameLoginFFF : DDDAutoLoginPlatformBaseFFF

@property(nonatomic,strong)UIViewController * currentViewController;
@property(nonatomic,weak)id<DDDHMCloudGameLoginProtocolFFF>delegate;

@end

NS_ASSUME_NONNULL_END
