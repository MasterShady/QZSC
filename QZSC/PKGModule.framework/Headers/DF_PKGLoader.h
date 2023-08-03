//
//  DF_PKGLoader.h
//  PKGModule
//
//  Created by 刘思源 on 2023/7/25.
//

#import <Foundation/Foundation.h>
#import "DF_PKGConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface DF_PKGLoader : NSObject

+ (instancetype)sharedInstance;

- (void)df_loadPKG:(DF_PKGConfig *)config;

@property (nonatomic, strong) void (^failHandler)(NSError *);

@property (nonatomic, strong) void (^successHandler)(NSString *unzipPath);

@property (nonatomic, strong) void (^loadProgressHandler)(CGFloat progress);

@end

NS_ASSUME_NONNULL_END
