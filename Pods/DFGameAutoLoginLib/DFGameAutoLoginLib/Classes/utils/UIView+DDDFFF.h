//
//  UIView+DDDFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (DDDFFF)

-(void)gradientColorWithColors:(NSArray<UIColor *>*)colors
                withStartPoint:(CGPoint)start
                  withEndPoint:(CGPoint)end;
@end

NS_ASSUME_NONNULL_END
