//
//  DDDHttpToolFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDHttpToolFFF.h"

@interface DDDHttpToolFFF()

@property(nonatomic,strong)NSDictionary * serverMaps;

@property(nonatomic,strong)AFHTTPSessionManager * _sessionManager;

@end
@implementation DDDHttpToolFFF


+(instancetype)defaultTool
{
    
    static dispatch_once_t onceToken;
    
    static DDDHttpToolFFF * instance;
    
    dispatch_once(&onceToken, ^{
        
        instance = [[DDDHttpToolFFF alloc] init];
        [instance config];
    });
    
    return instance;
}


-(void)config {
    
    NSDictionary * php = @{@(1):@"http://39.98.193.35:9596/",
                           @(2):@"http://10.10.24.178:9502/",
                           @(3):@"https://zhwapp.zuhaowan.com/"
    };
    NSDictionary * zt = @{@(1):@"http://10.10.45.170:30173/",
                          @(2):@"http://10.10.45.170:30173/",
                          @(3):@"https://bd-quickin.zuhaowan.cn/"
   };
    
    self.serverMaps = @{@(1):php,@(2):zt};
    self.api_env = MJHttpServerEnv_release;
    
    __sessionManager = [AFHTTPSessionManager manager];
    __sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
}


-(NSString *)getApiUrl:(DDDHttpServiceFFF*)service{
    
    NSDictionary * dic = self.serverMaps[@(service.apiType)];
    
    return  [NSString stringWithFormat:@"%@%@",dic[@(_api_env)],service.api];
}

-(NSDictionary *)httpHeader:(DDDHttpServiceFFF*)service{
    
    NSMutableDictionary * header = @{}.mutableCopy;
    header[@"os"] = @"iOS";
    header[@"Content-Type"] = @"application/json;charset=UTF-8";
    header[@"version"] = [DDDUtilsFFF getAppVersion];
    if (service.apiType == 1){
        
        header[@"channel"] = [DDDOtherInfoWrapFFF shared].appId;
        header[@"credential"] = [DDDOtherInfoWrapFFF shared].zhongtai_credential;
    }
    return  header;
}


-(NSDictionary *)httpParam:(DDDHttpServiceFFF*)service{
    
    if (service.apiType == 0){
        NSMutableDictionary * param = @{}.mutableCopy;
        
        param[@"auth_version"] = @"101";
        param[@"secure_version"] = @"101";
        param[@"app_channel"] = @"appstore";
        
        NSString * appversion = [DDDUtilsFFF getAppVersion];
        param[@"app_version_name"] = appversion;
        param[@"app_version_code"] = [appversion stringByReplacingOccurrencesOfString:@"." withString:@""];
        param[@"app_id"] = [DDDOtherInfoWrapFFF shared].appId;
        if ([DDDOtherInfoWrapFFF shared].shumei_id != nil && [DDDOtherInfoWrapFFF shared].shumei_id.length > 0){
            
            param[@"smanti_id"] = [DDDOtherInfoWrapFFF shared].shumei_id ;
        }
        if ([DDDOtherInfoWrapFFF shared].smid != nil && [DDDOtherInfoWrapFFF shared].smid.length > 0){
            
            param[@"smid"] = [DDDOtherInfoWrapFFF shared].smid ;
        }
        param[@"token"] = [DDDOtherInfoWrapFFF shared].token;
        param[@"auth_token"] = [DDDOtherInfoWrapFFF shared].token;
        param[@"device-ident"] = [DDDOtherInfoWrapFFF shared].uuid;
        
        
        [service.param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
           
            param[key] = obj;
        }];
        
        return param;
    }else{
        
        NSString * json_param = [service.param yy_modelToJSONString];
        
        NSString * aeskey = @"";
        
        if (_api_env == MJHttpServerEnv_test){
            
            aeskey  = @"WYdvTDlB/OOXQM5v9V6LwU/rUVQARIF1";
        }else {
            
            aeskey = @"gMmb8PXBCYyc9CPRx0BMvyPUqVD4ayqH";
        }
        
        NSString * encryptData = [DDDAESFFF AES256EncryptECB:json_param key:aeskey];
        
        NSDate * currentDate = [NSDate new];
        
        NSDateFormatter * dateformat = [[NSDateFormatter alloc] init];
        
        dateformat.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        
        dateformat.locale = NSLocale.systemLocale;
        
        NSString * formatDate_current = [dateformat stringFromDate:currentDate];
        
        NSDictionary * httpbody = @{@"request":formatDate_current,@"requestBody":encryptData,@"requestBizId":[DDDOtherInfoWrapFFF shared].zhongtai_bid};
        
        return  httpbody;
    }
}


-(void)httpTaskWithService:(DDDHttpServiceFFF *)service
     withResponseDataClass:(Class)responseClass
           withSuccessBlock:(void(^)(DDDModelBaseFFF* __nullable))SuccessBlock
          withFailBlock:(void(^)(NSString*))FailBlock{
    
    
    NSString * url = [self getApiUrl:service];
    
    NSDictionary * headers = [self httpHeader:service];
    
    NSDictionary * httpbody = [self httpParam:service];
    
    if (service.apiType == 0){
        
        __sessionManager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    }else{
        
        __sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
#ifdef DEBUG
    NSMutableArray *arr = [NSMutableArray array];
    [httpbody.copy enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str = [NSString stringWithFormat:@"%@=%@", key, obj];
        [arr addObject:str];
    }];
    NSLog(@"methon() ==> %@?%@",url, [arr componentsJoinedByString:@"&"]);
#endif
    
    
    
    
    void(^ successBlock)(NSURLSessionDataTask * _Nonnull , id  _Nullable ) = ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject != nil) {
            NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            DDDModelBaseFFF * model = [DDDModelBaseFFF modelWithDataClass:responseClass withjson:result];
            
            SuccessBlock(model);
        }else{
            FailBlock(@"接口返回数据为空");
        }
    };
    
    void(^ failBlock)(NSURLSessionDataTask * _Nonnull , NSError * _Nonnull ) = ^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        
        
        NSString *errorMsg;
        
        if (error) {
            if ([error.localizedDescription isEqualToString:@"The request timed out."]) {
                errorMsg = @"请求超时，请稍后再试";
            }
            else if ([error.localizedDescription isEqualToString:@"The Internet connection appears to be offline."]){
                errorMsg = @"网络断开，请检查您的网络连接";
            }
            else if ([error.localizedDescription isEqualToString:@"The data couldn’t be read because it isn’t in the correct format."]){
                errorMsg = @"数据无法读取,不是正确的格式。";
            }
            else if ([error.localizedDescription isEqualToString:@"The network connection was lost."]){
                errorMsg = @"网络连接错误";
            }
            else {
                errorMsg = error.localizedDescription;
            }
        }
        FailBlock(errorMsg);
    };
    if (service.httpmethod == 0){
        
        [__sessionManager GET:url parameters:httpbody headers:headers progress:nil success:successBlock failure:failBlock];
        
    }else{
        
        [__sessionManager POST:url parameters:httpbody headers:headers progress:nil success:successBlock failure:failBlock];
    }
    
}



@end


@implementation DDDQueueHttpTaskFFF



-(instancetype)initWithBlock:(void(^)(DDDModelBaseFFF * _Nonnull model , NSString * _Nonnull errorMsg))block{
    
    self = [super init];
    
    if (self){
        
        self.queue_resultBlock = block ;
    }
    
    return  self;
    
}

-(void)taskDo{
    
    if (_running == YES){return;}
    
    _running = YES;
    
   __block int count = 360;
    
    __timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    // 设置定时器的事件处理程序
    dispatch_source_set_timer(self._timer, dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), dispatch_time(DISPATCH_TIME_NOW, NSEC_PER_SEC * 1), 0);
    
    // 绑定定时器到主队列
    
    __weak DDDQueueHttpTaskFFF* weakSelf = self;
    dispatch_source_set_event_handler(self._timer, ^{
        // 在这里编写定时器触发时需要执行的操作
        
        __strong DDDQueueHttpTaskFFF * strongSelf = weakSelf;
        if (count > 0){
            
            [strongSelf _http];
        }else{
            
            [strongSelf taskEnd];
        }
        count -= 1;
    });
    
    // 启动定时器
    dispatch_resume(self._timer);
}

-(void)taskEnd{
    
    _running = NO;
    
    dispatch_source_cancel(__timer);
    
    __timer = nil;
}


-(void)_http{
    
    
    if (_running == NO){return;}
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:_service withResponseDataClass:_responseClass withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if (self.running == NO){ return;}
    
        self.queue_resultBlock(model,nil);
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
        self.queue_resultBlock(nil, error);
    }];
}

@end


@implementation  NSURLRequest (fromTxdata)

+(instancetype)urlRequestFromTxdata:(NSString *)base64Str{
    
    NSString *de_tx_str = [DDDUtilsFFF base64Decode:base64Str];
    
    NSData *jsonData = [de_tx_str dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *tx_dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    if (error != nil){
        
        return  nil;
    }
    

    //后续逻辑待处理 -- 解析之后请求腾讯接口，返回token数据，并将token数据返回给中台
    //获取请求腾讯的地址
    NSString *url_str = tx_dic[@"reqAddr"];
    //对 url_str 进行base64 解码获取到地址
    NSString *url = [DDDUtilsFFF base64Decode:url_str];
    //请求body
    NSString *body_str = tx_dic[@"reqData"];
    //对body 进行base64 编码 转data
    NSData *body_data = [[NSData alloc] initWithBase64EncodedString:body_str options:0];
    
    //请求header
    NSString *header_str = tx_dic[@"reqHeader"];
    
    //对 header_str base64 解码
    NSString *header = [DDDUtilsFFF base64Decode:header_str];
    
    NSArray<NSString *> * headers = [header componentsSeparatedByString:@"\r\n"];
    
    
    
    NSString *cookie_Str = tx_dic[@"reqCookie"]; //请求cookie，如果有值就传入
    
    NSString *cookie = [DDDUtilsFFF base64Decode:cookie_Str];
    
    //向腾讯发起请求 - POST
    NSURL *request_url = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:request_url];
    
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:body_data];
    if (cookie.length > 0) {
        [request setValue:cookie forKey:@"Cookie"];
    }
    [headers enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSArray * array = [obj componentsSeparatedByString:@": "];
        
        if (array.count == 2){
            
            [request addValue:array[1] forHTTPHeaderField:array[0]];
        }
    }];
    
    return  request;
    
}


@end
