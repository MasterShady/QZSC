//
//  DDDQQLoginFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDQQLoginFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDRequestTasksFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDFaceCheckModelFFF.h"
#import "DDDFaceCheckFFF.h"
@interface DDDQQLoginFFF()


@property(nonatomic,strong)DDDStackFFF * loginStack;

@property(nonatomic,strong)DDDQQLoginToken8xFFF * token8x;

@property(nonatomic,strong)DDDQQLoginTokenServerFFF * tokenserver;

@property(nonatomic,strong)DDDQuickTypeModelFFF * serverQuickType;
@end

@implementation DDDQQLoginFFF




-(void)loginWithInfo:(DDDActInfoFFF *)info{
    
    [super loginWithInfo:info];
    
    [self.loadingView show];
    
    [DDDRequestTasksFFF sw_logingame_qq_getOrderInfoWithUncode:self.info.unlock_code withCallBack:^(NSInteger code , NSString * _Nullable message, DDDQuickLoginModelFFF * _Nullable model) {
       
        if(code == 1){
            
            if(model == nil){
                
                DDDLog(@"QQ 上号获取上号信息 返回数据为空");
                self.loginErrorBlock(LGECode_Request_DataNull, @"QQ 上号获取上号信息 返回数据为空");
                return;
            }
            
            self.qq_orderInfo = model;
            
            self.face_verify_switch = model.face_verify_switch;
            
            self.loginStack = [[DDDStackFFF alloc] initWith:model.quick_info.quick_type];
            
            [self qqlogin];
            
        }
        else if (code == -2){
            
            self.loginErrorBlock(LGECode_Request_Net, @"数据返回异常code==-2");
        }
        else if (code == -1){
            
            self.loginErrorBlock(LGECode_Json_error, @"数据返回异常code==-1");
        }
        else{
            self.loginErrorBlock(LGECode_Request_CodeError,message != nil ? message : [NSString stringWithFormat:@"异常状态码%ld",(long)code]);
        }
    }];
}


-(void)qqlogin{
    
    DDDQuickTypeModelFFF * quickTypeModel = [self.loginStack current];
    
    if(quickTypeModel == nil){
        
        
        [self server_1];
        return;
    }else{
        
        if([quickTypeModel.name containsString:@"88"]){
            DDDLog(@"即将88上号");
            [self _8xWith:quickTypeModel];
        }
        else if ([quickTypeModel.name containsString:@"server"]){
            DDDLog(@"即将Server上号");
            [self _serverPre:quickTypeModel];
        }else{
            
            DDDLog([NSString stringWithFormat:@"客户端暂不支持此上号方式%@",quickTypeModel.name]);
            
            self.loginErrorBlock(LGECode_Fail_Error, [NSString stringWithFormat:@"客户端暂不支持此上号方式%@",quickTypeModel.name]);
        }
    }
    
}

-(void)server{
    
    _tokenserver = [[DDDQQLoginTokenServerFFF alloc] init];
    _tokenserver.param = _qq_orderInfo;
    _tokenserver.game_id = self.info.game_id;
    _tokenserver.quickModel = _serverQuickType;
    
    WeakObj(self);
    [_tokenserver setEventBlock:^(NSInteger code, NSString * _Nonnull msg) {
        
        if(code == 0){
            
            [weakSelf.loginStack pop];
            
            [weakSelf qqlogin];
        }
        
        if (code == 1 && msg != nil){
            
            [weakSelf gameLaunchWithUrl:msg];
        }
        
        if (code == 2){
            
            weakSelf.reloadBlock();
        }
    }];
    
    [_tokenserver toTaskWithLoading:self.loadingView];
}

-(void)server_1{
    
    
    _tokenserver = [[DDDQQLoginTokenServerFFF alloc] init];
    _tokenserver.param = _qq_orderInfo;
    _tokenserver.game_id = self.info.game_id;
    _tokenserver.quickModel = _serverQuickType;
    
    WeakObj(self);
    [_tokenserver setEventBlock:^(NSInteger code, NSString * _Nonnull msg) {
        
       
        
        if (code == 1 && msg != nil){
            
            [weakSelf gameLaunchWithUrl:msg];
        }
        
       else{
            
           weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"上号失败10004");
        }
    }];
    
    [_tokenserver defaultTokenLoginGame:_qq_orderInfo.quick_info.quick_token isreport:YES];
}
-(void)_8xWith:(DDDQuickTypeModelFFF*)model{
    
    _token8x = [[DDDQQLoginToken8xFFF alloc] init];
    _token8x.game_id = self.info.game_id;
    _token8x.quickModel = model;
    WeakObj(self);
    [_token8x setEventblock:^(NSInteger status, id obj) {
        
        if(status == 0){
            NSString * message = obj;
            [weakSelf.loadingView hidden];
            
            UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            
            [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                weakSelf.reloadBlock();
            }]];
            [[DDDUtilsFFF getCurrentViewController] presentViewController:alertView animated:YES completion:nil];
        }
        else if (status == 1){
            
            [weakSelf.loadingView hidden];
            
            NSString * tokenstr = obj;
            
            NSArray * tokenArr = [tokenstr componentsSeparatedByString:@"_"];
            
            if(tokenArr.count > 0){
                
                NSString * url = [weakSelf createLaunchUrl:tokenArr[0] openid:tokenArr[1] ptoken:tokenArr[2]];
                
                [weakSelf gameLaunchWithUrl:url];
            }
        }
        else if (status == 2){
            
            [weakSelf.loginStack pop];
            
            [weakSelf qqlogin];
        }
        else if (status == 3){
            
            [weakSelf.loadingView hidden];
            
            NSDictionary *info = (NSDictionary *)obj;
            //获取模板数据
            //获取 plist 模板路径
            NSString *templatePath = [[[DDDUtilsFFF getCurrentBundle] bundlePath] stringByAppendingString:@"/template.plist"];
            
            NSData *rawdata = [NSData dataWithContentsOfFile:templatePath];
            
            //将 rawdata 反归档
            NSMutableDictionary *json = [[NSKeyedUnarchiver unarchiveObjectWithData:rawdata] mutableCopy];
            
           
            NSInteger expires_in = [info[@"expires_in"] integerValue];
            NSString *encry_token = info[@"encrytoken"];
            NSString *openid = info[@"openid"];
            NSString *pf = info[@"pf"];
            NSString *pfkey = info[@"pfkey"];
            NSString *ptoken = info[@"pay_token"];
            NSString *atoken = info[@"access_token"];
            
            [json setValue:@(expires_in) forKey:@"expires_in"];
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
            
            NSString *openUrl = [NSString stringWithFormat:@"%@qzapp/mqzone/0?objectlocation=url&pasteboard=%@", weakSelf.qq_orderInfo.quick_info.game_info.package_ios_qq, base64];
            
            
            [weakSelf gameLaunchWithUrl:openUrl];
        }
    }];
    
    _token8x.param = _qq_orderInfo;
    [_token8x queryToken];
    
    
}
-(void)_serverPre:(DDDQuickTypeModelFFF*)model{
    
    _serverQuickType = model;
    
    [self.loadingView hidden];
    
    if(self.face_verify_switch != nil&& self.face_verify_switch.switch1){
        
        //触发人脸检测
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        
        [dic setValue:self.qq_orderInfo.qq forKey:@"qq"];
        
        [dic setValue:self.qq_orderInfo.face_verify_switch.hopetoken forKey:@"hopeToken"];
        
        [dic setValue:self.qq_orderInfo.face_verify_switch.url forKey:@"url"];
        
        [dic setValue:self.qq_orderInfo.face_verify_switch.switch2 forKey:@"Switch"];
        
        [dic setValue:self.qq_orderInfo.face_verify_switch.chk_id forKey:@"chk_id"];
        
        [dic setValue:@"" forKey:@"access_token"];
        
        [dic setValue:@"" forKey:@"openid"];
        
        [dic setValue:@"" forKey:@"ptoken"];
        
        [dic setValue:@"" forKey:@"cookie"];
        
        DDDFaceCheckModelFFF *face = [DDDFaceCheckModelFFF yy_modelWithDictionary:dic];
        
        [self faceCheck:NO model:face];
    }
}


- (void)faceCheck:(BOOL)isNew model:(DDDFaceCheckModelFFF *)model {
    
    DDDFaceCheckFFF *faceCheck = [DDDFaceCheckFFF new];
    
    faceCheck.faceModel = model;
    
    //检测成功
    WeakObj(self);
    faceCheck.faceCheckSucess = ^(NSInteger type) {
        
        if (type == 0) {
            
          
            [weakSelf server];
        }else {
            
            NSString * url = [self createLaunchUrl:model.access_token openid:model.openid ptoken:model.ptoken];
            if(url.length > 0){
                [self gameLaunchWithUrl:url];
            }
            
            
        }
        
    };
    
    //检测失败
    faceCheck.faceCheckFail = ^(NSString * _Nonnull msg) {
        
        self.loginErrorBlock(LGECode_FaceVerify_Error, msg);
    };
    
    //检测失败 -- 刷新订单
    faceCheck.reloadTip = ^(NSString * _Nonnull msg) {
      
        
        UIAlertController * alertView = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
        
        [alertView addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            weakSelf.reloadBlock();
        }]];
        [[DDDUtilsFFF getCurrentViewController] presentViewController:alertView animated:YES completion:nil];
    };
    
    
    if (isNew) {
        
        //人脸检测新流程
        [faceCheck skeyGetSessionId];
        
    }else {
        
        //人脸检测老流程
        [faceCheck oldLogDoOldInterfaceCheck];
    }
}


- (NSString *)createLaunchUrl:(NSString *)accessToken openid:(NSString *)openid ptoken:(NSString *)ptoken {
    
    NSString *openUrl = @"";
    
    if ([self.qq_orderInfo.order_info.gameid integerValue] == 698 || [self.qq_orderInfo.order_info.gameid integerValue] == 1078) {
        
        openUrl = [NSString stringWithFormat:@"%@?platform=qq_m&user_openid=%@&openid=%@&launchfrom=sq_gamecenter&gamedata=&platformdata=&atoken=%@&ptoken=%@&huashan_com_sid=biz_src_zf_games", self.qq_orderInfo.quick_info.game_info.package_ios_qq, openid, openid, accessToken, ptoken];
        
    }else {
        
        openUrl = [NSString stringWithFormat:@"%@startapp?atoken=%@&openid=%@&ptoken=%@&platform=qq_m&current_uin=%@&launchfrom=sq_gamecenter", self.qq_orderInfo.quick_info.game_info.package_ios_qq, accessToken, openid, ptoken, openid];
        
    }
    
    
    return openUrl;
    
}

-(void)gameLaunchWithUrl:(NSString *)url{
    
    
    [self openAppWithUrl:url withHandler:^(BOOL result) {
        
        
        NSString *str = [NSString stringWithFormat:@"App_MainInfo?bbh=%@&dh=%@&sys=&fr=10&longitude=&latitude=&address=&qq=&ios_sys_ver=%@&sm_verify_new=1", [DDDUtilsFFF getAppVersion], self.info.unlock_code, [UIDevice currentDevice].systemVersion];
        
        NSString *encryptStr = [DDDZSRc4FFF swRc4EncryptWithSource:str rc4Key:login_rc4_key];
        
        
        [[DDDHttpToolFFF defaultTool] httpTaskWithService:[DDDHttpServiceFFF serviceWithParam:@{} withApi:SW_API_QULICKLOGIN_INFO withPhp:YES] withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
            
        } withFailBlock:^(NSString * _Nonnull err) {
            
        }];
        
        self.loginErrorBlock(LGECode_Success, @"");
    }];
}
@end
