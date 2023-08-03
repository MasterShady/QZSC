//
//  DDDFaceCheckFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDFaceCheckFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDRequestTasksFFF.h"
@interface DDDFaceCheckFFF()
{
    NSString * session_id;
    NSString * channel_id ;
}


@end


@implementation DDDFaceCheckFFF


//人脸检测新流程
- (void)skeyGetSessionId {
    
    NSString *str = @"https://open.mp.qq.com/connect/oauth2/authorize?appid=201023853&redirect_uri=https://jz.game.qq.com/php/tgclub/v2/jzwechat_v10_login/h5qqLogin?redirectUrl=aHR0cHM6Ly9qaWF6aGFuZy5xcS5jb20vd2FwL3NlbGZNYW5hZ2UvZGlzdC9zdHVkZW50L2luZGV4Lmh0bWw/dWZsYWc9MTYxMDAxMTM1Nzc3MSMvSW5kZXg=&response_type=code&scope=snsapi_base&state=STATE";
    
    NSURL *url = [NSURL URLWithString:str];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"GET"];
    
    [request setValue:self.faceModel.cookie forKey:@"Cookie"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        
        for (NSHTTPCookie *cookie in [cookieJar cookiesForURL:request.URL]) {
            
            
            if ([cookie.name isEqualToString:@"session_id"]) {
                self->session_id = cookie.value;
            }
            if ([cookie.name isEqualToString:@"channel_id"]) {
                self->channel_id = cookie.value;
            }
        }
        
        //获取token成功 -- 检测人脸
        if (self->session_id.length != 0) {
            self->channel_id = self->channel_id.length == 0 ? @"4" : self->channel_id;
            
            [self oldInterfaceCheckFace];
            
        }
        
    }];
    
    [task resume];
}


/**
 老登录流程只进行
 人脸检测老流程
 */
- (void)oldLogDoOldInterfaceCheck {
    
    NSDictionary *jsonDic = @{@"accountId":self.faceModel.qq, @"hopeToken":self.faceModel.hopeToken};
    
    NSString *jsonStr = [self convertToJsonData:jsonDic];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.faceModel.url]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"https://jiazhang.qq.com" forHTTPHeaderField:@"origin"];
    
    [request setValue:@"application/x-www-from-urlencoded;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        
        
        if (!dic) {
            return;
        }
        
        //上报人脸结果
        WeakObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
          
            
            
            [DDDRequestTasksFFF sw_logingame_qq_faceverify_reportWithChk:[weakSelf.faceModel.chk_id intValue] withMemo:dic[@"msg"] Withface:[dic[@"faceResult"] intValue] WithType:0 WithCallBack:^(NSInteger code, NSString * _Nonnull msg) {
                
                
                if(code != 1){
                    
                    weakSelf.faceCheckFail(msg);
                    
                    
                }
                else{
                    
                    weakSelf.faceCheckSucess(0);
                }
               
            }];
            
        });
        
    }];
    
    [task resume];
}


#pragma mark - oldInterfaceCheckFace  ==> 老接口检测人脸

- (void)oldInterfaceCheckFace {
    
    NSDictionary *param = @{@"accountId":self.faceModel.qq, @"hopeToken":self.faceModel.hopeToken};
    
    NSString *jsonParam = [self convertToJsonData:param];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.faceModel.url]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:@"https://jiazhang.qq.com" forHTTPHeaderField:@"origin"];
    
    [request setValue:@"application/x-www-from-urlencoded;charset=UTF-8" forHTTPHeaderField:@"content-type"];
    
    [request setHTTPBody:[jsonParam dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
       
        
        NSInteger  ret = [dic[@"ret"] intValue];
        
        NSInteger faceResult = [dic[@"faceResult"] intValue];
        
        /*
         ret == 0 && faceResult == 1  有人脸
         ret == 0 && faceResult == 0 无人脸 -- 上报结果，启动游戏
         其他 查询失败 -- 上报结果按照无人脸启动游戏
         */
        
        if (ret  == 0 && faceResult  == 1 && [self.faceModel.Switch integerValue] == 1) {
            
            //有人脸 且 新接口检测开关开启 -- 用新接口进行检测
            
            [self newInterfaceCheckFace];
            
            
        }else {
            
            //上报人脸结果
            WeakObj(self);
            dispatch_async(dispatch_get_main_queue(), ^{
              
                
                [DDDRequestTasksFFF sw_logingame_qq_faceverify_reportWithChk:[weakSelf.faceModel.chk_id intValue] withMemo:dic[@"ret"] Withface:faceResult WithType:0 WithCallBack:^(NSInteger code, NSString * _Nonnull msg) {
                    
                    if(code == -1){
                        
                        weakSelf.faceCheckFail(msg);
                        
                        
                    }
                    else if (code == 1){
                        weakSelf.faceCheckSucess(1);
                    }
                    else{
                        
                        weakSelf.reloadTip(msg);
                    }
                }];
            });
            
        }
        
        
    }];
    
    [task resume];
    
}

#pragma mark - newInterfaceCheckFace ==> 新接口检测人脸

- (void)newInterfaceCheckFace {
    
    NSString *currentTime = [self getNowTimeTimestamp];
    
    NSString *urlStr = [NSString stringWithFormat:@"https://jz.game.qq.com/php/tgclub/v2/jzwechat_v10_facediscern/getRemainTimes?channel_id=4&source=h5&_0=%@&callback=", currentTime];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    [request setHTTPMethod:@"POST"];
    
    [request setValue:[NSString stringWithFormat:@"session_id=%@; channel_id=%@", session_id, channel_id] forHTTPHeaderField:@"cookie"];
    
    [request setValue:@"https://jiazhang.qq.com/wap/com/v1/dist/face_discern_qq.html?" forHTTPHeaderField:@"referer"];
    
    [request setValue:@"com.tencent.mobileqq" forHTTPHeaderField:@"x-requested-with"];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        NSData *jsonData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        
        
        
        /*
         error_code=0 && ret=0 触发
         error_code=0 && ret=1 未触发
         其他获取失败
         上报人脸结果
         */
        
        NSNumber *err_code = dic[@"err_code"];
        
        NSString *err_msg = dic[@"err_msg"];
        
        if ([err_code integerValue] == 0) {
            
            NSNumber *ret = dic[@"data"][@"ret"];
            
            if ([ret integerValue] == 0) {
                err_code = @(1);
            }
            
            if ([ret integerValue] == 1) {
                err_code = @(0);
            }
            
            err_msg = dic[@"data"][@"msg"];
            
        }else {
            
            err_code = @(1);
            
        }
        
        //上报人脸结果
        WeakObj(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            [DDDRequestTasksFFF sw_logingame_qq_faceverify_reportWithChk:[weakSelf.faceModel.chk_id intValue] withMemo:[NSString stringWithFormat:@"newapi%@", err_msg] Withface:[err_code intValue] WithType:1 WithCallBack:^(NSInteger code, NSString * _Nonnull msg) {
                
                if(code == -1){
                    
                    weakSelf.faceCheckFail(msg);
                    
                    
                }
                else if (code == 1){
                    weakSelf.faceCheckSucess(1);
                }
                else{
                    
                    weakSelf.reloadTip(msg);
                }
            }];
            
        });
        
    }];
    
    [task resume];
}


#pragma mark - 字典转json

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
       
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
}


#pragma mark - 获取当前时间戳(以秒为单位)
- (NSString *)getNowTimeTimestamp
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    return timeSp;
}

@end
