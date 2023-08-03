//
//  NSString+DDDFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DDDFFF)
+(NSString*)timeIntervalChangeToTimeStr:(NSTimeInterval)timeInterval
withFormater:(NSString *)formater;

-(NSString *)MD5Encrypt;
@end

NS_ASSUME_NONNULL_END
