//
//  UIFont+DDDFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/25.
//

#import "UIFont+DDDFFF.h"

@implementation UIFont (DDDFFF)


+(instancetype)fontWithSize:(CGFloat)size
                  withAlias:(FontAlis)alis{
    
    CGFloat scale = CGRectGetWidth(UIScreen.mainScreen.bounds)/375 * size;
    NSString * fontname = @"";
    switch (alis) {
        
        case  FontAlispfRegular:
            fontname = @"PingFangSC-Regular";
            break;
        case    FontAlispfMedium:
            fontname = @"PingFangSC-Medium";
            break;
        case    FontAlispfLight:
            fontname = @"PingFangSC-Light";
            break;
        case    FontAlispfSemibold:
            fontname = @"PingFangSC-Semibold";
            break;
        case    FontAlishltRegular:
            fontname = @"HelveticaNeue";
            break;
        case    FontAlishltMedium:
            fontname = @"HelveticaNeue-Medium";
            break;
        case    FontAlishltBold:
            fontname = @"HelveticaNeue-Bold";
            break;
        case    FontAlisdinRegular:
            fontname = @"DIN Alternate";
            break;
        case    FontAlisdinBold:
            fontname = @"DINAlternate-Bold";
            break;
        case    FontAlisarialIMT:
            fontname = @"Arial-ItalicMT";
            break;
       
    }
    
    UIFont * font =  [UIFont fontWithName:fontname size:scale];
    
    if (font == nil){
        
        return  [UIFont systemFontOfSize:scale];
    }
    
    return font;
}
@end
