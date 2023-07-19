//
//  UIColor+Hex.h
//  DFSQ
//
//  Created by zhouc on 2023/3/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHexString:(NSString *)color;
 
@end

NS_ASSUME_NONNULL_END
