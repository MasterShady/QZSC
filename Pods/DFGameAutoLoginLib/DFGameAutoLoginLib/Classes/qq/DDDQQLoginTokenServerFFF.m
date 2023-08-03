//
//  DDDQQLoginTokenServerFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDQQLoginTokenServerFFF.h"

#import "DDDUtilsFFF.h"

#import "DDDHttpToolFFF.h"

#import "DDDConstFFF.h"

#import "DDDCriptsFFF.h"
@interface DDDQQLoginTokenServerFFF ()

@property(nonatomic,strong)dispatch_source_t checkTimer;

@end

@implementation DDDQQLoginTokenServerFFF


-(void)dealloc{
    
    [self cancel];
}

-(void)cancel{
   
    if(_checkTimer != nil){
        
        dispatch_source_cancel(_checkTimer);
        _checkTimer = nil;
    }
    
}

-(void)toTaskWithLoading:(id<DDDLoginGameLoadingViewProtocolFFF>)loading{
    
    _current_loading = loading;
    
    [_current_loading show];
    
    WeakObj(self);
    _checkTimer = DDDTimer(5, ^{
        
        [weakSelf getServerToken];
        
    });
    
    dispatch_resume(_checkTimer);
    
}

-(void)getServerToken{
    
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:self.quickModel.source forKey:@"source"];
    
    [param setValue:self.param.quick_info.order_login forKey:@"order_login"];
    
    [param setValue:@"5" forKey:@"quick_version"];
     
    [param setValue:self.param.order_info.orderid forKey:@"order_id"];
        
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:[DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_GETSERVERORDER_TOKEN withPhp:YES] withResponseDataClass:NSDictionary.class withSuccessBlock:^(DDDModelBaseFFF<NSDictionary *> * _Nullable model) {
        
        if(model == nil){return;}
        
        if (model.status == 1){return;}
        [self.current_loading hidden];
        [self cancel];
        
        if(model.status == 0){
            
            DDDToast(model.message);
            
            self.eventBlock(0, @"");
        }else if (model.status == 2){
            
            self.eventBlock(2, @"");
        }
        else if (model.status == 3){
            
            [self defaultTokenLoginGame:model.data[@"quick_token"] isreport:NO];
        }else{
            [self defaultTokenLoginGame:self.param.quick_info.quick_token isreport:NO];
        }
        
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
        [self.current_loading hidden];
        [self cancel];
        [self defaultTokenLoginGame:self.param.quick_info.quick_token isreport:YES];
    }];
}

- (void)defaultTokenLoginGame:(NSString *)quick_token isreport:(BOOL)isreport {
    
    //转为大写
    NSString *token = [quick_token uppercaseString];
    
    if (token.length <= 0) {
        [self blockAction:0 msg:@"qq_order token nil"];
        
        return;
    }
    
    //对token进行rc4解密
    NSString *decryptStr = [DDDZSRc4FFF swRc4DecryptWithSource:token rc4Key: game_auth_key];
    
    if (decryptStr == nil || decryptStr.length <= 0) {
        
        [self blockAction:0 msg:@"qq_order token decrypt error"];
        
        return;
        
    }
    
    //将解密后的 decryptStr 转成字典
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[decryptStr dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    
    
    
    if (dic == nil) {
        
        [self blockAction:0 msg:@"qq_order token json error"];
        
        return;
        
    }
    
    /**
     如果dic中包含 plist 字段，则直接使用服务端返回的url，拉起游戏
     否则还是走本地plist归档数据
     */
    NSString *plist_str = dic[@"plist"] == nil ? @"" : dic[@"plist"];
    
    //定义启动游戏url
    NSString *openUrl = @"";
    
    if (plist_str != nil && plist_str.length > 0) {
        
        //服务端处理plist文件，直接返回了启动游戏的url
        openUrl = plist_str;
        
    }else {
        if (self.param.quick_info.game_info.package_ios_qq == nil || self.param.quick_info.game_info.package_ios_qq.length <= 0) {
            
            [self blockAction:0 msg:@"game scheme is nil"];
            
           
            return;
        }
        
        //从解析出来的 dic 中获取到上号需要的参数
        NSString *openid = [dic objectForKey:@"openid"];
        
        NSString *atoken = [dic objectForKey:@"atoken"];
        
        NSString *ptoken = [dic objectForKey:@"ptoken"];
        
        NSString *pplatform = [dic objectForKey:@"platform"];
        
        NSString *current_uin = [dic objectForKey:@"current_uin"];
        
        /**
         上号新增参数 encry_token 如果存在 则进行 plist文件相关操作上号 ==> 1.3
         */
        if ([dic objectForKey:@"encry_token"] != nil) {
            
            NSString *encry_token = [dic objectForKey:@"encry_token"];
            
            NSString *pfkey = [dic objectForKey:@"pfkey"];
            
            NSString *pf = [dic objectForKey:@"pf"];

            NSString *expires_in = [dic objectForKey:@"expires_in"];
            
            //获取 plist 模板路径
            NSURL *bundleUrl = [[[NSBundle mainBundle] URLForResource:@"QuickLoginBundle" withExtension:@"bundle" subdirectory:nil] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", @"template"]];
            
            NSData *rawdata = [NSData dataWithContentsOfFile:bundleUrl.path];
            
            //将 rawdata 反归档
            NSMutableDictionary *json = [[NSKeyedUnarchiver unarchiveObjectWithData:rawdata] mutableCopy];
            
            
            
            [json setValue:@([expires_in intValue]) forKey:@"expires_in"];
            
            [json setValue:encry_token forKey:@"encrytoken"];
            
            [json setValue:openid forKey:@"openid"];
            
            [json setValue:pf forKey:@"pf"];
            
            [json setValue:pfkey forKey:@"pfkey"];
            
            [json setValue:ptoken forKey:@"pay_token"];
            
            [json setValue:atoken forKey:@"access_token"];
            
            
            
            //将 json 进行归档操作
            NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:json requiringSecureCoding:YES error:nil];
            
            //对 data1 进行 base64 编码
            NSString *base64 = [data1 base64EncodedStringWithOptions:0];
            
            openUrl = [NSString stringWithFormat:@"%@qzapp/mqzone/0?objectlocation=url&pasteboard=%@", self.param.quick_info.game_info.package_ios_qq, base64];
            
            if (isreport) {
                
                //将上号数据上包给服务端
                
                [self reportToken:dic];
            }
            
        }else {
            
            //不存在新增参数时 按照正常逻辑，不执行 plist 文件操作步骤
            if ([self.game_id integerValue] == 698 || [self.game_id integerValue] == 1078) {
                
                openUrl = [NSString stringWithFormat:@"%@?platform=%@&user_openid=%@&openid=%@&launchfrom=sq_gamecenter&gamedata=&platformdata=&atoken=%@&ptoken=%@&huashan_com_sid=biz_src_zf_games", self.param.quick_info.game_info.package_ios_qq, pplatform, openid, openid, atoken, ptoken];
                
            }else {
                
                openUrl = [NSString stringWithFormat:@"%@startapp?atoken=%@&openid=%@&ptoken=%@&platform=%@&current_uin=%@&launchfrom=sq_gamecenter", self.param.quick_info.game_info.package_ios_qq, atoken, openid, ptoken, pplatform, current_uin];
                
            }
            
        }
    }
    
    //回调 拉起游戏的url
    [self blockAction:1 msg:openUrl];
    
}

- (void)blockAction:(NSInteger)code msg:(NSString *)msg {
    
    if (self.eventBlock) {
        
        self.eventBlock(code, msg);
        
    }
}

- (void)reportToken:(NSDictionary *)dic{
    
    
    //字典转化为 json 字符串
    NSString *json_dic = [dic yy_modelToJSONString];
    
    //对 json_dic 进行 rc4 加密
    NSString *rc4Str = [DDDZSRc4FFF swRc4EncryptWithSource:json_dic rc4Key:game_auth_key];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    
    [param setValue:self.param.quick_info.hid forKey:@"hid"];
    
    [param setValue:self.param.order_info.orderid forKey:@"order_id"];
    
    [param setValue:rc4Str forKey:@"login_token"];
    
    [param setValue:self.param.default_source forKey:@"source"];
    
    [param setValue:self.param.quick_info.order_login forKey:@"order_login"];
    
    [param setValue:@"5" forKey:@"quick_version"];
    
    [param setValue:@"plist上号成功" forKey:@"remark"];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:[DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SETTOKENSOFT withPhp:YES] withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
    }];
}
@end
