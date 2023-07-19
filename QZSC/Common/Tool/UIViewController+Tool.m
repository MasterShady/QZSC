//
//  UIViewController+Tool.m
//  DFSQ
//
//  Created by zhouc on 2023/3/20.
//

#import "UIViewController+Tool.h"

@implementation UIViewController (Tool)

- (void)setIsPushed:(BOOL)isPushed {
    
}

- (BOOL)isPushed {
    if (self.navigationController == nil || self.navigationController.viewControllers.firstObject == nil) {
        return NO;
    }
    return YES;
}

- (void)setIsRootNavigation:(BOOL)isRootNavigation {
    
}

- (BOOL)isRootNavigation {
    if (self.parentViewController != nil) {
        UIViewController *parent = self.parentViewController;
        if (![parent isKindOfClass:[UINavigationController class]] && [parent.childViewControllers containsObject:self]) {
            return YES;
        }
    }
    return NO;
}


@end
