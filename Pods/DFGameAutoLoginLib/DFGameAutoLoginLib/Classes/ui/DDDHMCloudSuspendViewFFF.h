//
//  DDDHMCloudSuspendViewFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDHMCloudSuspendViewFFF : UIView

@property(nonatomic,copy)dispatch_block_t clickCallBack;

+(instancetype)suspendViewWith:(UIView *)superView;

@end

NS_ASSUME_NONNULL_END
