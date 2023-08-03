//
//  DDDLoadingDelegateFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import <Foundation/Foundation.h>

#import "DDDLoginGameLoadingViewProtocolFFF.h"
#import "DDDActInfoFFF.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDDLoadingProviderFFF : NSObject

@property(nonatomic,copy)void(^cancelBlock)(void);

-(void)setLoadingViewWithInfo:(DDDActInfoFFF *)info;

-(id<DDDLoginGameLoadingViewProtocolFFF>)getLoadingVieW;

-(id<DDDLoginGameLoadingViewProtocolFFF>)getHMCloudGamePageLoadingView;

@end

NS_ASSUME_NONNULL_END
