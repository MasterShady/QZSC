//
//  DDDHMCloudBackGameViewFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDHMCloudBackGameViewFFF : UIView

@property(nonatomic,copy)dispatch_block_t closeGameBlock;

+(instancetype)backGameView;

-(void)showWith:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
