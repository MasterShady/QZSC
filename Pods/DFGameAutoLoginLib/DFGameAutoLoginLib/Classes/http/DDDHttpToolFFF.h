//
//  DDDHttpToolFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDHttpServiceFFF.h"
#import <AFNetworking/AFNetworking.h>
#import "DDDUtilsFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import "DDDModelBaseFFF.h"
#import <YYModel/YYModel.h>
#import "DDDCriptsFFF.h"
NS_ASSUME_NONNULL_BEGIN



typedef enum : NSUInteger {
    MJHttpServerEnv_test = 1,
    MJHttpServerEnv_pre = 2,
    MJHttpServerEnv_release = 3,
} MJHttpServerEnv;




@interface DDDHttpToolFFF : NSObject


+(instancetype)defaultTool;

@property (nonatomic) MJHttpServerEnv api_env;

-(void)httpTaskWithService:(DDDHttpServiceFFF *)service
     withResponseDataClass:(Class)responseClass
           withSuccessBlock:(void(^)(DDDModelBaseFFF* __nullable))SuccessBlock
          withFailBlock:(void(^)(NSString*))FailBlock;

@end


@interface DDDQueueHttpTaskFFF : NSObject

@property(nonatomic,strong)DDDHttpServiceFFF * service;

@property Class responseClass;

@property(nonatomic,strong)dispatch_source_t _timer;

@property(nonatomic,copy)void(^queue_resultBlock)( DDDModelBaseFFF * __nullable model , NSString * __nullable errorMsg );

@property BOOL running;


-(void)taskDo;

-(void)taskEnd;

-(instancetype)initWithBlock:(void(^)(DDDModelBaseFFF * _Nonnull model , NSString * _Nonnull errorMsg))block;


@end


@interface NSURLRequest (fromTxdata)

+(instancetype)urlRequestFromTxdata:(NSString *)base64Str;

@end

NS_ASSUME_NONNULL_END
