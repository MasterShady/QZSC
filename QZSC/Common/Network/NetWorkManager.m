//
//  NetWorkManager.m
//  DFSQ
//
//  Created by zhouc on 2023/4/3.
//

#import "NetWorkManager.h"
#import "AFNetworking.h"
#import "RC4Tool.h"
#import "NetWorkCommonObject.h"
#import "QZSC-Swift.h"
@implementation NetWorkManager

// 完整请求网址
+ (NSString *)getFullUrl:(NSString *)url {
    if ([url containsString:@"https://www.uhuhzl.cn"]) {
        return url;
    }
    return [NSString stringWithFormat:@"%@%@", @"https://www.uhuhzl.cn", url];
}

// 请求头
+ (NSDictionary *)getHttpHeader {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    return dic;
}

// RC4加密密钥
+ (NSString *)getRC4EncryKey {
    return @"package@dofun.cn";
}



+ (void)postWithUrlString:(nonnull NSString *)urlString
               parameters:(nullable NSDictionary *)paramers
                 complete:(nonnull HttpsComplete)complete {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    NSDictionary *headers = [NetWorkManager getHttpHeader];
    
    NSString *resultUrl = [NetWorkManager getFullUrl:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:resultUrl]];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:headers];
    
    // body加密
    NSString *uid = [QZSCLoginManager Uid];
    if (!kDictIsEmpty(paramers) || !kStringIsEmpty(uid)) {
        NSMutableDictionary *mutParams = [paramers mutableCopy];
        if (kDictIsEmpty(mutParams)) {
            mutParams = [NSMutableDictionary dictionary];
        }
        if (!kStringIsEmpty(uid)) {
            mutParams[@"uid"] = uid;
        }
        NSData *encryData = [NetWorkManager encryParams:mutParams];
        [request setHTTPBody:encryData];
    }
    
    NSURLSessionDataTask *task = [manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSString *urlString = response.URL.absoluteString;
        NSHTTPURLResponse *rep = (NSHTTPURLResponse *)response;
        NSInteger code = rep.statusCode;
        NetWorkCommonObject *object = [[NetWorkCommonObject alloc] init];
        if (error) {
            object.state = NetWork_Faliure;
            if (kStringIsEmpty(error.localizedDescription)) {
                object.msg = @"网络错误!";
            } else {
                object.msg = error.localizedDescription;
            }
            NSMutableDictionary *mutParams = [paramers mutableCopy];
            if (!kStringIsEmpty(uid)) {
                mutParams[@"uid"] = uid;
            }
            NSLog(@"POST请求接口URL: %@\n 请求头: %@ \n 参数:%@ \n HTTP状态码:%ld \n 返回结果:\n %@", urlString, headers, mutParams, code, error);
        } else {
            NSString *encryStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            NSString *resultStr = [RC4Tool rc4Decode:encryStr key:[NetWorkManager getRC4EncryKey]];
            NSData *result = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingMutableContainers error:nil];
            NSMutableDictionary *mutParams = [paramers mutableCopy];
            if (!kStringIsEmpty(uid)) {
                mutParams[@"uid"] = uid;
            }
            NSLog(@"POST请求接口URL: %@\n 请求头: %@ \n 参数:%@ \n HTTP状态码:%ld \n 返回结果:\n %@", urlString, headers, mutParams, code, dic);
            NSNumber *code = dic[@"code"];
            if ( code.intValue == 0) {
                object.state = NetWork_Success;
                object.data = dic[@"data"];
            } else {
                object.state = NetWork_Faliure;
                if (kStringIsEmpty(dic[@"msg"])) {
                    object.msg = @"网络错误!";
                } else {
                    object.msg = dic[@"msg"];
                }
            }
        }
        complete(object);
    }];
    [task resume];
}

+ (NSData *)encryParams:(NSDictionary *)params {
    NSData *data = [NSJSONSerialization dataWithJSONObject:params options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paramString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSString *encryParam = [RC4Tool rc4Encode:paramString key:[NetWorkManager getRC4EncryKey]];
    NSData *encryData = [encryParam dataUsingEncoding:NSUTF8StringEncoding];
    return encryData;
}

@end
