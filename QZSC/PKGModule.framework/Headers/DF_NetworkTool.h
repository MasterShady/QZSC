//
//  DF_NetworkTool.h
//  PKGModule
//
//  Created by 刘思源 on 2023/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DF_HTTPResult<Data> : NSObject

@property (nonatomic, assign) BOOL status;

@property (nonatomic, strong) NSString *message;

@property (nonatomic, strong) Data data;

@property (nonatomic, strong) NSURLSessionDataTask *task;

@end

@interface DF_NetworkTool : NSObject

+(void)GET:(NSString *)url params:(NSDictionary *)params success:(nullable void (^)(DF_HTTPResult *result))success
    failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))failureilure;

@end

NS_ASSUME_NONNULL_END
