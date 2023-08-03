//
//  DFEncyptTool.h
//  PKGModule-PKGModule
//
//  Created by 刘思源 on 2023/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DFEncyptTool : NSObject

+ (NSData *)AES256DecryptData:(NSData *)data withKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
