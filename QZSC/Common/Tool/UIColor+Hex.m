//
//  UIColor+Hex.m
//  DFSQ
//
//  Created by zhouc on 2023/3/20.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha {
    // 删除字符串中的空格
    NSString * colorStr = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
      
    // String should be 6 or 8 characters
    if ([colorStr length] < 6) {
        return [UIColor clearColor];
    }
      
    // strip 0X if it appears
    // 如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"0X"]) {
        colorStr = [colorStr substringFromIndex:2];
    }
      
    // 如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([colorStr hasPrefix:@"#"]) {
        colorStr = [colorStr substringFromIndex:1];
    }
      
    // 除去所有开头字符后 再判断字符串长度
    if ([colorStr length] != 6) {
        return [UIColor clearColor];
    }
      
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //red
    NSString * redStr = [colorStr substringWithRange:range];
    //green
    range.location = 2;
    NSString * greenStr = [colorStr substringWithRange:range];
    //blue
    range.location = 4;
    NSString * blueStr = [colorStr substringWithRange:range];
      
    // Scan values 将十六进制转换成二进制
    unsigned int r, g, b;
    [[NSScanner scannerWithString:redStr] scanHexInt:&r];
    [[NSScanner scannerWithString:greenStr] scanHexInt:&g];
    [[NSScanner scannerWithString:blueStr] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}
 
+ (UIColor *)colorWithHexString:(NSString *)color {
    return [self colorWithHexString:color alpha:1.0f];
}
@end
