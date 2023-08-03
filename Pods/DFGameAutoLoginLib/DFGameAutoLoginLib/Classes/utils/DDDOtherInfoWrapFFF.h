//
//  DDDOtherInfoWrapFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <Foundation/Foundation.h>

#import "DDDLoginGameLoadingViewProtocolFFF.h"

#import "DDDLogFFF.h"
@interface DDDOtherInfoWrapFFF : NSObject


@property(nonatomic,copy)NSString * appversion;

@property(nonatomic,copy)NSString * token;

@property(nonatomic,copy)NSString * uuid;

@property(nonatomic)NSInteger channel; // 0 app 1 上号器

@property(nonatomic,copy)NSString * appId;

@property(nonatomic,copy)NSString * httpSignStr;

@property(nonatomic,copy)NSString * websocketSignStr;

@property(nonatomic,copy)NSString * zhongtai_credential;

@property(nonatomic,copy)NSString * zhongtai_bid;

@property(nonatomic,copy)NSString * shumei_id;

@property(nonatomic,copy)NSString * smid;

@property DDDLogLevel loglevel;

@property(nonatomic,weak) id<DDDLoginGameLoadingViewProtocolFFF> hmcloudLouadingView;



+(instancetype)shared;

@end


