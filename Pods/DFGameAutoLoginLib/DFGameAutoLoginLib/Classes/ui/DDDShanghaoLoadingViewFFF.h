//
//  DDDShanghaoLoadingView.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <UIKit/UIKit.h>
#import "DDDLoginGameLoadingViewProtocolFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDShanghaoLoadingViewFFF : UIView<DDDLoginGameLoadingViewProtocolFFF>

@property(nonatomic,strong)NSArray<NSString *> * msgArray;

@property(nonatomic,copy)NSString * show_text;

@property(nonatomic,weak)UIView * targetView;

@property(nonatomic,copy)void(^closeBlock)(void);

+(instancetype)loadingView;

@end

NS_ASSUME_NONNULL_END
