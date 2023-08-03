//
//  DDDImageGuideViewFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <UIKit/UIKit.h>
#import "DDDGuideInfoFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDImageGuideViewFFF : UIView

+(instancetype)popWidgetWith:(DDDGuideInfoFFF *)info;

@property(nonatomic,copy)void(^completionBlock)(void);

-(void)showWith:(UIView *)containerView;

@end

NS_ASSUME_NONNULL_END
