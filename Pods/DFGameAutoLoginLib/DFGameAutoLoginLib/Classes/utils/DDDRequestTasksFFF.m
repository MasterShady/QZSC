//
//  DDDRequestTasksFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDRequestTasksFFF.h"
#import "DDDHttpToolFFF.h"
#import "NSString+DDDFFF.h"
#import "DDDHttpServiceFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDConstFFF.h"

@implementation DDDRequestTasksFFF

+(void)sw_loginGame_checkDeviceUidWithuncode:(NSString *)lockcode
                                withCallBack:(void(^)(BOOL,NSString *))callback{
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"dh":lockcode} withApi:SW_API_LoginOaidCheck withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF<NSString *> * _Nullable model) {
        
        
        if (model == nil ){
            
            
            callback(NO,@"数据解析异常");
            return;
            
        }
        
        if (model.status == 1){
            
            callback(YES,@"");
        }else{
            
            callback(NO,model.message);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(NO,errorMsg);
    }];
    
}

+(void)sw_logingame_qq_getOrderInfoWithUncode:(NSString *)uncode
                                 withCallBack:(void(^)(NSInteger ,NSString * __nullable,DDDQuickLoginModelFFF* __nullable))callback{
    
    NSString * currentTime = [NSString timeIntervalChangeToTimeStr:[NSDate new].timeIntervalSince1970 withFormater:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *paramStr = [NSString stringWithFormat:@"QuickgetTokenByUncode%@3b133bd80074285c335ce57ae5cfd0a9", currentTime];
    
    NSString * sign = [paramStr MD5Encrypt];
    
    NSDictionary * param = @{@"api_token":sign,
                             @"uncode":uncode,
                             @"time":currentTime,
                             @"quick_version":@"7",
                             @"sm_verify_new":@"1"
    };
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_QQ_GetOrderInfo withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:DDDQuickLoginModelFFF.class withSuccessBlock:^(DDDModelBaseFFF<DDDQuickLoginModelFFF *> * __nullable model) {
        
        if (model == nil){
            
            callback(-1,nil,nil);
            return;
        }
        
        if (model.status == 1){
            
            callback(1,nil,model.data);
        }else{
            
            callback(model.status,model.message,nil);
        }
        
    } withFailBlock:^(NSString * _Nonnull errormsg) {
        
        callback(-2,nil,nil);
    }];
    
    
    
    
}

+(void)sw_logingame_wx_joinTokenQueueWithOrderId:(NSString *)orderId
                                    WithCallBack:(void(^)(NSInteger ))callback{
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"order_id":orderId,@"source":@"808"} withApi:SW_API_WX_QUICK_TOKEN_QUEUE withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if (model == nil){
            
            callback(-1);
        }else{
            
            callback(model.status);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-2);
    }];
}
+(void)sw_logingame_wx_joinResetQueueWithOrderId:(NSString *)orderId
                                    WithCallBack:(void(^)(NSInteger ))callback{
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"order_id":orderId,@"source":@"808"} withApi:SW_API_WX_QUICK_RESER_QUEUE withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if (model == nil){
            
            callback(-1);
        }else{
            
            callback(model.status);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-2);
    }];
}

+(void)sw_logingame_wx_getTokenWithOrderId:(NSString *)orderId
                              WithCallBack:(void(^)(NSInteger ,NSString*))callback{
    
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"order_id":orderId} withApi:SW_API_CHEK_WX_LOGIN_CODE withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:DDDWxLoginCodeModelFFF.class withSuccessBlock:^(DDDModelBaseFFF<DDDWxLoginCodeModelFFF*> * _Nullable model) {
        
        if (model == nil){
            
            callback(-1,@"");
            
            return;
        }
        
        if (model.status == 1){
            
            callback(1,model.data.token);
        }else{
            callback(model.status,model.message);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-2,@"");
    }];
}
+(void)sw_logingame_wx_resetDataWithOrderId:(NSString *)orderId
                              WithCallBack:(void(^)(NSInteger ,NSString*))callback{
    
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"order_id":orderId} withApi:SW_API_WX_RESET_CODE withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:DDDWxLoginCodeModelFFF.class withSuccessBlock:^(DDDModelBaseFFF<DDDWxLoginCodeModelFFF*> * _Nullable model) {
        
        if (model == nil){
            
            callback(-1,@"");
            
            return;
        }
        
        if (model.status == 1){
            
            callback(1,model.data.token);
        }else{
            callback(model.status,model.message);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-1,@"");
    }];
}


+(void)sw_logingame_qq_faceverify_reportWithChk:(NSInteger)chkId
                                       withMemo:(NSString *)memo
                                       Withface:(NSInteger)isface
                                       WithType:(NSInteger)type
                                   WithCallBack:(void(^)(NSInteger,NSString*))callback{
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"chk_id":@(chkId),@"chk_memo":memo,@"isface":@(isface),@"type":@(type)} withApi:SW_API_QQ_FACEVERIFYREPORT withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if (model == nil){
            
            callback(-1,@"数据解析异常");
        }else{
            
            callback(model.status,model.message);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-1,errorMsg);
    }];
}

+(void)sw_wx_login_reportwithQueue_id:(NSString *)queueId
                         withOrder_id:(NSString *)orderid
                           withUncode:(NSString *)uncode
                               withStatus:(NSString *)status
                           withRemark:(NSString *)remark
                     withQuickVersion:(NSString *)quickVerison
                                   WithCallBack:(void(^)(NSInteger,NSString*))callback{
    NSDictionary * param = @{@"queue_id":queueId,
                             @"order_id":orderid,
                             @"withUncode":uncode,
                             @"status":status,
                             @"remark":remark,
                             @"quick_version":quickVerison
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_WxReport withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if (model == nil){
            
            callback(-1,@"");
        }else{
            
            callback(model.status,model.message);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        callback(-2,@"");
    }];
}


+(void)sw_zht_login_requestWithBusniss:(NSString *)businessType
                          WithOpenMode:(NSString *)openmode
                                withpt:(NSString *)pt
                      withbusinessData:(NSString *)businessData
                          withsuccessBack:(void(^)(DDDModelBaseFFF*))successBack
                         withErrorBack:(void(^)(NSString *))failBack{
    
    
    NSMutableDictionary * param = @{@"businessType":businessType,
                             @"openMode":openmode,
                             @"pt":pt
    }.mutableCopy;
    
    if (businessData.length > 0){
        
        param[@"businessData"] = businessData;
    }
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_LoginRequest withPhp:NO];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:successBack withFailBlock:failBack];
    
}
@end



