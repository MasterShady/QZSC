//
//  UIView+DDDFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/25.
//

#import "UIView+DDDFFF.h"

@implementation UIView (DDDFFF)


-(void)gradientColorWithColors:(NSArray<UIColor *>*)colors
                withStartPoint:(CGPoint)start
                  withEndPoint:(CGPoint)end{
    
    for (CALayer * sublayer in self.layer.sublayers) {
        
        if ([sublayer isKindOfClass:CAGradientLayer.class]){
            
            [sublayer removeFromSuperlayer];
        }
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;

    // 设置渐变的颜色
    
    NSMutableArray * cgcolors = @[].mutableCopy;
    
    [colors enumerateObjectsUsingBlock:^(UIColor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [cgcolors addObject:(__bridge id)obj.CGColor];
    }];
    
    gradientLayer.colors = cgcolors;

    // 设置渐变的方向
    gradientLayer.startPoint =start; // 渐变起点，默认值是 (0.5, 0.0)
    gradientLayer.endPoint = end; // 渐变终点，默认值是 (0.5, 1.0)

    // 添加渐变层到目标视图的层级关系中
    [self.layer insertSublayer:gradientLayer atIndex:0];
    
    self.backgroundColor = UIColor.clearColor;
    
    self.layer.masksToBounds = false;
}
@end
