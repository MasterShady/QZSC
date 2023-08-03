//
//  NSString+DDDFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import "NSString+DDDFFF.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSString (DDDFFF)

+(NSString*)timeIntervalChangeToTimeStr:(NSTimeInterval)timeInterval
                           withFormater:(NSString *)formater{
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter * AA = [[NSDateFormatter alloc] init];
    
    AA.dateFormat  = formater;
    
    return [AA stringFromDate:date];
}

-(NSString *)MD5Encrypt{
    
    //要进行UTF8的转码
    const char* input = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }

    return digest;
}
@end
