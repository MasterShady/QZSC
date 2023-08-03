//
//  DDDLoginGuideUtilFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import <Foundation/Foundation.h>
#import "DDDGuideInfoFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDLoginGuideUtilFFF : NSObject


-(void)showGuideWithInfo:(DDDGuideInfoFFF *)info
                withView:(UIView *)view
withCompletionBlock:(void(^)(void))block;


@end

@interface DDDMicroCheckUtilFFF :NSObject

+(void)checkMicroWithNext:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
