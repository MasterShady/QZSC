//
//  DDDAutoLoginPlatformBaseFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDAutoLoginPlatformProtocolFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDAutoLoginPlatformBaseFFF : NSObject<DDDAutoLoginPlatformProtocolFFF>

@property(nonatomic,strong)id<DDDLoginGameLoadingViewProtocolFFF> loadingView;

@property(nonatomic,strong)DDDActInfoFFF * info;
@end

NS_ASSUME_NONNULL_END
