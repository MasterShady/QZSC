//
//  UIFont+DDDFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    FontAlispfRegular,
    FontAlispfMedium,
    FontAlispfLight,
    FontAlispfSemibold,
    FontAlishltRegular,
    FontAlishltMedium,
    FontAlishltBold,
    FontAlisdinRegular,
    FontAlisdinBold,
    FontAlisarialIMT
} FontAlis;

@interface UIFont (DDDFFF)

+(instancetype)fontWithSize:(CGFloat)size
                  withAlias:(FontAlis)alis;

@end

NS_ASSUME_NONNULL_END
