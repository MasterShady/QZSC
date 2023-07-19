//
//  UIViewController+Tool.h
//  DFSQ
//
//  Created by zhouc on 2023/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Tool)

@property(nonatomic, assign) BOOL isPushed;
@property(nonatomic, assign) BOOL isRootNavigation;

@end

NS_ASSUME_NONNULL_END
