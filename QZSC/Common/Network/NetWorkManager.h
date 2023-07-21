//
//  NetWorkManager.h
//  DFSQ
//
//  Created by zhouc on 2023/4/3.
//

#import <Foundation/Foundation.h>
#import "NetWorkCommonObject.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^HttpsComplete)(NetWorkCommonObject *object);

@interface NetWorkManager : NSObject

+ (void)postWithUrlString:(nonnull NSString *)urlString
               parameters:(nullable NSDictionary *)paramers
                 complete:(HttpsComplete)complete;

@end

NS_ASSUME_NONNULL_END
