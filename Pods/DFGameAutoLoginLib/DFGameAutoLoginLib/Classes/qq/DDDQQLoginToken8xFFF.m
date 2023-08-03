//
//  DDDQQLoginToken8xFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDQQLoginToken8xFFF.h"



static NSInteger OP_8001 = 8001;

static NSInteger OP_8002 = 8002;

static NSInteger OP_8003 = 8003;

static NSInteger OP_8004 = 8004;

static NSInteger OP_8005 = 8005;

static NSInteger OP_8007 = 8007; //plist方式

static NSInteger OP_9001 = 9001;

static NSInteger OP_9002 = 9002;

static NSInteger OP_9003 = 9003;

static NSInteger OP_0001 = 1;

static NSInteger OP_0002 = 2;

static NSInteger OP_0003 = 3;

static NSInteger OP_0004 = 4 ;//plist方式





@interface DDDQQLoginToken8xFFF()<DDD8xSocketProtocol>

@property(nonatomic,strong)DDDAlertViewFFF * sliderBackview;

@property(nonatomic,strong)DDDAlertHKMideViewFFF * sliderView;

@property NSInteger reTry_num;

@property BOOL isTry;

@property BOOL isTs ;

@property(nonatomic,strong)DDD8xSocket * xxsocket;

@property(nonatomic,strong)DDDQQSocket * socketqq;


@end








@implementation DDDQQLoginToken8xFFF

-(DDDAlertHKMideViewFFF *)sliderView{
    
    if(_sliderView == nil){
        
        _sliderView = [[DDDAlertHKMideViewFFF alloc] initWithFrame:UIScreen.mainScreen.bounds];
    }
    
    return _sliderView;
}


-(void)lg8xxSliderVerifyWithUrl:(NSString *)url
                       withCall:(void(^)(NSString *))call{
    
    [self.sliderView configureLoadUrl:url];
    
    WeakObj(self);
    [self.sliderView setTickerAndRandstrBlock:^(NSString * _Nonnull ticket, NSString * _Nonnull randstr) {
        
        [weakSelf.sliderBackview dismiss];
        
        call(ticket);
    }];
    
    [self.sliderView setCloseBlock:^{
        
        [weakSelf.sliderBackview dismiss];
    }];
    
    _sliderBackview = [[DDDAlertViewFFF alloc] initWithMiddleView:self.sliderView];
    
    [_sliderBackview show];
}

-(void)lg8xxtokenGetSuccessWithTokenInfo:(NSString*)info{
    
    self.eventblock(1, info);
}

-(void)lg8xxSendDataToQQWithhost:(NSString *)host
                        withPort:(NSInteger)port
                        withData:(NSData *)data
                        withCall:(void(^)(NSString *))callback{
    
    void(^msgCallBack)(NSString *) = ^(NSString * msg){
        
        callback(msg);
    };
    
    if(_socketqq == nil){
        
        _socketqq = [[DDDQQSocket alloc] initWithIp:host withPort:port];
    }
    
    [_socketqq sendDataWith:data withCallBack:msgCallBack];
    
}

-(void)lg8xxErrorwith:(NSInteger)code
                   withMessage:(NSString *)message{
    
    self.eventblock(2, [NSString stringWithFormat:@"%ld:[qq_8x] %@",(long)code,message]);
}

-(void)reload:(NSString *)withMsg{
    
    self.eventblock(0, [NSString stringWithFormat:@"[qq_8x] %@",withMsg]);
}

-(void)uploadError:(NSString *)withMsg{
    
   __block BOOL _ists = NO;
    
    [self.quickModel.off_rent enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        if ([withMsg containsString:obj]){
            
            _ists = YES;
            *stop = YES;
        
        }
    }];
    __block BOOL _istry = NO;
     
     [self.quickModel.retry enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
         if ([withMsg containsString:obj]){
             
             _istry = YES;
             *stop = YES;
         
         }
     }];
    _isTry = _istry;
    
    if(_isTs){
        
        [_xxsocket endTask];
        
        [_socketqq endTask];
        
        NSDictionary *param = @{
            @"hid":self.param.order_info.hid,
            @"order_id":self.param.order_info.orderid,
            @"remark":withMsg,
            @"source":self.quickModel.source,
            @"quick_ts":@(1),
            @"err_times":@(0),
            @"quick_version":@"5",
            @"order_login":self.param.quick_info.order_login
        };
        
        DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SETTOKENERROR withPhp:YES];
        [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
            
            
            if (model == nil){return;}
            
            if(model.status == 2){
                
                self.eventblock(0, model.message);
            }
        } withFailBlock:^(NSString * _Nonnull error) {
            
        }];
    }
    
    if (!_isTs){
        
        
        if(_isTry){
            
            if(_reTry_num > 0){
                
                _reTry_num -= 1;
                
                [_xxsocket reDoTask];
            }else{
                
                NSDictionary *param = @{
                    @"hid":self.param.order_info.hid,
                    @"order_id":self.param.order_info.orderid,
                    @"remark":withMsg,
                    @"source":self.quickModel.source,
                    @"err_times":@(0),
                    @"quick_version":@"5",
                    @"order_login":self.param.quick_info.order_login
                };
                
                DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SETTOKENERROR withPhp:YES];
                [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
                    
                    
                 
                } withFailBlock:^(NSString * _Nonnull error) {
                    
                }];
                
                [_xxsocket endTask];
                [_socketqq endTask];
                
                self.eventblock(2, @"84上号失败");
            }
        }
    }
    
}

-(void)lg8xx_plistInfoGetSuccess:(NSDictionary *)withplist{
    
    
    self.eventblock(3, withplist);
}






-(void)queryToken{
    
    _reTry_num = [_quickModel.retry_times intValue];
    
    _xxsocket = [[DDD8xSocket alloc] init];
    
    _xxsocket.game_id = _game_id;
    
    _xxsocket.delegate = self;
    
    _xxsocket.upload_source = _quickModel.source;
    
    [_xxsocket doTaskWith:_param];
}


-(void)cancel{
    
    [_sliderBackview dismiss];
    
    [_socketqq endTask];
    
    [_xxsocket endTask];
}

@end



@implementation DDD8xSocket




- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        
        _readedData = [NSMutableData data];
    }
    return self;
}
-(void)reDoTask{
    
    _readedData = [NSMutableData data];
    
    _status = DDD8XSocketEventTypeNONE;
    
    _aes_key = [DDDUtilsFFF random128BitAESKey];
    
    NSString * host = _info.quick_info.rent_auth_address;
    
    NSString * pt = _info.quick_info.rent_auth_port;
    
    if (host.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"socket ip 为空"];
        return;
        
    }
    if (pt.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"socket port 为空"];
        return;
        
    }
    
    if(_socket.isConnected == NO){
        
        NSError * error;
        
        [_socket connectToHost:host onPort:[pt intValue] error:&error];
        
        if (error != nil){
            
            [self.delegate lg8xxErrorwith:4 withMessage:@"socket connet error"];
            return;
        }
        
        NSData * data = [self _handshake];
        
        if (data.length == 0){
            
            [self.delegate lg8xxErrorwith:5 withMessage:@"握手包构建失败"];
            return;
        }
        
        [self sendData:data];
    }else{
        
        NSData * data = [self _handshake];
        if (data.length == 0){
            
            [self.delegate lg8xxErrorwith:5 withMessage:@"握手包构建失败"];
            return;
        }
        [self sendData:data];
    }
}

-(void)endTask{
    
    [_socket disconnect];
}

-(void)doTaskWith:(DDDQuickLoginModelFFF *)dic{
    
    _info = dic;
    
    _aes_key = [DDDUtilsFFF random128BitAESKey];
    
    NSString * game_auth = _info.quick_info.game_auth_88.uppercaseString;
    
    if (game_auth.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"game_auth 为空"];
        
        return;
    }
    
    NSString * rc4TokenStr = [DDDZSRc4FFF swRc4DecryptWithSource:game_auth  rc4Key:game_auth_key];
    
    if (rc4TokenStr.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"game_auth rc4 解密失败"];
        
        return;
    }
    
    NSDictionary * dicToken = [DDDUtilsFFF dicFRomJson:rc4TokenStr];
    
    if (dicToken == nil){
        
        [self.delegate lg8xxErrorwith:3 withMessage:@"game_auth 解析失败"];
        return;
    }
    DDDLog([NSString stringWithFormat:@"gameAuth88-%@",rc4TokenStr]);
    
    _game_auth_dic = dicToken;
    
    NSString * host = _info.quick_info.rent_auth_address;
    
    NSString * pt = _info.quick_info.rent_auth_port;
    
    if (host.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"socket ip 为空"];
        return;
        
    }
    if (pt.length == 0){
        
        [self.delegate lg8xxErrorwith:1 withMessage:@"socket port 为空"];
        return;
        
    }
    
    if (_status != DDD8XSocketEventTypeNONE){return;}
    
    if(_socket.isConnected == NO){
        
        NSError * error;
        
        [_socket connectToHost:host onPort:[pt intValue] error:&error];
        
        if (error != nil){
            
            [self.delegate lg8xxErrorwith:4 withMessage:@"socket connet error"];
            return;
        }
        
        NSData * data = [self _handshake];
        
        if (data.length == 0){
            
            [self.delegate lg8xxErrorwith:5 withMessage:@"握手包构建失败"];
            return;
        }
        
        [self sendData:data];
    }else{
        
        NSData * data = [self _handshake];
        if (data.length == 0){
            
            [self.delegate lg8xxErrorwith:5 withMessage:@"握手包构建失败"];
            return;
        }
        [self sendData:data];
    }
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    NSString * data_str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if (data_str == nil || data_str.length == 0){return;}
    
    [self.readedData appendData:data];
    
    BOOL isSend = [data_str hasSuffix:@"\0"];

    if (!isSend) { //如果没有遇到结束表示，则继续读取数据
        
        [self.socket readDataWithTimeout:-1 tag:tag];
        
        return;
    }
    
    NSString *result = [[NSString alloc] initWithData:self.readedData encoding:NSUTF8StringEncoding];
    DDDLog([NSString stringWithFormat:@"88socket result 接收到的数据 ===%@",result]);
    
    
    if (result == nil || result.length == 0) {
        return;
    }
    
    // readedData 重新初始化，清空数据
    self.readedData = [NSMutableData data];
    
    NSDictionary *json = [DDDUtilsFFF turnStringToDictionary:result];
    
    if (json == nil || json.count == 0) {
        return;
    }
    
   
    
    NSInteger ec = [json[@"ec"] integerValue];
    
    //处理业务逻辑
    if (ec == 0) {
        
        switch (self.status) {
            case DDD8XSocketEventTypeHANDSHAKE: //交换秘钥
            {
                NSString *srv_key_crypt = json[@"srv_key"];
                if (srv_key_crypt == nil || srv_key_crypt.length == 0) {
                    return;
                }
                self.srv_key = [DDDRSAUtilFFF decryptString:srv_key_crypt publicKey:rsa_key];
                if (self.qq_token != nil && self.qq_token.length > 0) {
                    NSInteger qq_uin = [self.game_auth_dic[@"qq"] integerValue];
                    NSDictionary *dic = @{
                        @"op":@(OP_8007),
                        @"usr_info":@{@"uin":@(qq_uin)},
                        @"dev_info":[self getDeviceInfo],
                        @"gm_init":@{@"gm_id":self.game_id, @"qq_token":self.qq_token}
                    };
                    NSData *_data = [self _operationMsg:dic];
                    if (data == nil) {
                        return;
                    }
                    //发送数据
                    [self sendData:_data];
                }else {
                    if (self.re_open_token) {
                        //重试
                        NSData *_data = [self open];
                        if (_data == nil) {
                            return;
                        }
                        //发送数据
                        [self sendData:_data];
                    }else { //非重试
                        /**
                         交换秘钥后，上号端先发 8002根据qtoken获取游戏token, 如果获取成功上报数据并上号，如果获取失败，则重新走一次上号端开通
                         */
                        NSInteger qq_uid = [self.game_auth_dic[@"qq"] integerValue];
                        
                        NSDictionary *dic = @{
                            @"op":@(OP_8007),
                            @"usr_info":@{@"uin":@(qq_uid)},
                            @"dev_info":[self getDeviceInfo],
                            @"gm_init":@{
                                @"gm_id":self.game_id,
                                @"qq_token":self.game_auth_dic[@"qtoken"]
                            }
                        };
                        
                        NSData *_data = [self _operationMsg:dic];
                        
                        if (_data == nil) {
                            return;
                        }
                        
                        //发送数据
                        [self sendData:_data];
                    }
                }
                break;
            }
            case DDD8XSocketEventTypeSENDDATA:
            {
                NSString *hexStr = json[@"data"];
                
                if (hexStr == nil || hexStr.length == 0) {
                    if ([self.delegate respondsToSelector:@selector(lg8xxErrorwith:withMessage:)]) {
                        [self.delegate lg8xxErrorwith:1 withMessage:@"server 返回数据 为空"];
                    }
                }
                
                NSString *deAesStr = [DDDAESFFF AES128DecryptECB:hexStr key:self.srv_key];
                
                if (deAesStr == nil || deAesStr.length == 0) {
                    if ([self.delegate respondsToSelector:@selector(lg8xxErrorwith:withMessage:)]) {
                        [self.delegate lg8xxErrorwith:1 withMessage:@"aes 128 解密数据 为空"];
                    }
                }
                
                NSDictionary *serv_dic = [DDDUtilsFFF turnStringToDictionary:deAesStr];
                
                //获取动作类型码
                NSUInteger oprationCode = [serv_dic[@"op"] integerValue];
                
                if (oprationCode == OP_9001) { //向腾讯发包，获取上号数据
                    
                    NSDictionary *transpond = serv_dic[@"transpond"];
                    
                    NSString *ip = transpond[@"ip"];
                    
                    NSString *port = transpond[@"port"];
                    
                    NSData *qq_data = [DDDUtilsFFF convertHexStrToData:transpond[@"data"]];
                    
                    //连接 qq_socket
                    [self.delegate lg8xxSendDataToQQWithhost:ip withPort:[port intValue] withData:qq_data withCall:^(NSString * msg) {
                        
                        NSDictionary *pkg_dic = @{
                            @"op":@(OP_8003),
                            @"transpond":@{@"r_data":msg},
                        };
                        
                        NSData *_data = [self _operationMsg:pkg_dic];
                        
                        if (_data) {
                            
                            [self sendData:_data];
                        }
                        
                        
                    }];
                }else if (oprationCode == OP_9002) {
                    //弹出滑块验证 ==> 此处必须在主线程操作，否则webview初始化返回nil
                    dispatch_async(dispatch_get_main_queue(), ^{
                       
                        NSString *url = serv_dic[@"v_code"][@"uri"];
                        if (url == nil) {
                            return;
                        }
                        
                        [self.delegate lg8xxSliderVerifyWithUrl:url withCall:^(NSString * ticket) {
                            
                            NSDictionary *pkg_dic = @{
                                @"op":@(OP_8004),
                                @"v_code":@{@"key":ticket} //参数是v_code 不是c_code
                            };
                            NSData *_data = [self _operationMsg:pkg_dic];
                            if (_data == nil) {
                                return;
                            }
                            [self sendData:_data];
                        }];
                        
                       
                        
                    });
                    
                    
                }else if (oprationCode == OP_9003) {
                    
                    //触发短信验证码 == 上报错误
                    
                    DDDLog(@"操作码9003,触发短信验证码");
                    [self.delegate uploadError:@"触发短信验证码"];
                    
                }else if (oprationCode == OP_0001) {
                    
                    //重新开始任务
                    NSDictionary *result = serv_dic[@"result"];
                    self.qq_token = result[@"qq_token"];
                    self.qq_skey = result[@"qq_skey"];
                    self.game_auth_sign = result[@"sign"];
                    DDDLog(@"操作码0001，重新开启任务");
                    [self reDoTask];
                }else if (oprationCode == OP_0002) {
                    
                    //获取token成功 -- 上号
                    NSDictionary *result = serv_dic[@"result"];
                    self.qq_skey = result[@"qq_skey"];
                    NSString *tokenStr = result[@"gm_token"];
                    if (tokenStr == nil || tokenStr.length == 0) {
                        return;
                    }
                    NSArray *tokenArr = [tokenStr componentsSeparatedByString:@"_"];
                    
                    if (tokenArr.count != 3) {
                        return;
                    }
                    
                    //成功上报token
                    [self uploadGameTokenInfo:tokenArr[0] openid:tokenArr[1] ptoken:tokenArr[2]];
                    
                    
                    //开始上号
                    if ([self.delegate respondsToSelector:@selector(lg8xxtokenGetSuccessWithTokenInfo:)]) {
                        [self.delegate lg8xxtokenGetSuccessWithTokenInfo:tokenStr];
                    }
                    
                }else if (oprationCode == OP_0003) {
                    
                    NSDictionary *result = serv_dic[@"result"];
                    NSString *error = result[@"error"];
                    if (self.re_open_token == NO) {
                        self.re_open_token = YES;
                        [self reDoTask];
                    }else {
                        //上报错误
                        [self.delegate uploadError:error.length == 0 ? @"OP_0003" : error];
                    }
                    
                }else if (oprationCode == OP_0004) {
                    
                    NSDictionary *result = serv_dic[@"result"];
                    NSDictionary *gmtoken = result[@"gm_token"];
                    
                    if (gmtoken != nil && gmtoken.count > 0) {
                        
                        self.qq_skey = result[@"qq_skey"];
                        
                        [self uploadGameTokenWithDic:gmtoken];
                        
                        if ([self.delegate respondsToSelector:@selector(lg8xx_plistInfoGetSuccess:)]) {
                            [self.delegate lg8xx_plistInfoGetSuccess:gmtoken];
                        }
                        
                    }else {
                        
                        DDDLog(@"Plist 数据格式有误");
                    }
                    
                }else {
                    DDDLog([NSString stringWithFormat:@"socket 未定义操作码%ld逻辑",oprationCode]);
                }
                
                
                break;
            }
                
            default:
                break;
        }
        
    }else {
        
        NSString *msg = json[@"em"];
        
        if ([msg isEqualToString:@"PACK_STATUS::UNPACK_ERROR"]) {
            
            //重试
            self.re_open_token = YES;
            
            [self reDoTask];
            
        }else {
            
            if ([self.delegate respondsToSelector:@selector(lg8xxErrorwith:withMessage:)]) {
                [self.delegate lg8xxErrorwith:8 withMessage:msg];
            }
            
        }
        
        
        return;
    }
}

-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    switch (_status) {
        case DDD8XSocketEventTypeNONE:
            
            _status = DDD8XSocketEventTypeHANDSHAKE;
            break;
        case DDD8XSocketEventTypeHANDSHAKE:
            
            _status = DDD8XSocketEventTypeSENDDATA;
            break;
        default:
            break;
    }
    
    [sock readDataWithTimeout:-1 tag:0];
}

-(void)sendData:(NSData *)data{
    
    [_socket writeData:data withTimeout:-1 tag:0];
}



- (NSData *)_operationMsg:(NSDictionary *)content {
    
    NSString *jsonStr = [DDDUtilsFFF jsonFromDic:content];
    
    NSString *enc_str = [DDDAESFFF AES128EncryptECB:jsonStr key:self.aes_key];
    
    NSString *sign_str = [DDDUtilsFFF md5ForBytesToLower32Bate:enc_str];
    
    NSDictionary *dic = @{
        @"data":enc_str,
        @"sign":sign_str,
        @"time":[DDDUtilsFFF getNowTimeTimestamp]
    };
    
    return [self _msgBodyWith:dic];
}


-(NSData *)_handshake{
    
    NSString * quick_identity = _info.quick_info.quick_identity;
    
    if (quick_identity.length == 0){
        
        return nil;
    }
    
    NSString * hid = _info.order_info.hid;
    
    if (hid.length == 0){
        
        return nil;
    }
    
    NSString * str = [DDDRSAUtilFFF encryptString:_aes_key publicKey:rsa_key];
    
    NSString * cln_token = [NSString stringWithFormat:@"hid=%@&qq=%@&token=%@",hid,_info.qq,quick_identity];
    
    NSDictionary *dic = @{
        @"cln_key":str,
        @"srv_ide":@(1),
        @"cln_app":[DDDOtherInfoWrapFFF shared].appId,
        @"cln_token":cln_token,
        @"cln_dev":[DDDOtherInfoWrapFFF shared].uuid
    };
    
    return [self _msgBodyWith:dic];
}

-(NSData *)open{
    NSString *qq_uin = self.info.qq;
    
    NSString *password_c = self.info.quick_info.game_mm;
    
    NSDictionary *userDic = @{
        @"uin":@([qq_uin integerValue]),
        @"password_c":password_c
    };
    
    NSDictionary *devDic = [self getDeviceInfo];
    
    NSDictionary *dic = @{
        @"op":@(OP_8001),
        @"usr_info":userDic,
        @"dev_info":devDic
    };
    
    NSData *_data = [self _operationMsg:dic];
    
    return _data;
}
-(NSData *)_msgBodyWith:(NSDictionary *)dic{
    
    NSData *indata = [NSJSONSerialization dataWithJSONObject:dic options:0 error:nil];
    NSString *temp_str = [[NSString alloc] initWithData:indata encoding:NSUTF8StringEncoding];
    
    NSString *send_str = [NSString stringWithFormat:@"%@%@", temp_str, @"\0"];
    
    NSData *data =[send_str dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}

- (id)getDeviceInfo {
    if (self.game_auth_dic[@"deviceinfo"] != nil) {
        return self.game_auth_dic[@"deviceinfo"];
    }else if (self.game_auth_dic[@"deviceinfo88"] != nil) {
        return self.game_auth_dic[@"deviceinfo88"];
    }else {
        return @"";
    }
}

- (void)uploadGameTokenInfo:(NSString *)atoken openid:(NSString *)openid ptoken:(NSString *)ptoken {
    
    NSMutableDictionary *param = @{
        @"hid":self.info.order_info.hid,
        @"order_id":self.info.order_info.orderid,
        @"source":self.upload_source,
        @"err_times":@(0),
        @"quick_version":@"5",
        @"order_login":self.info.quick_info.order_login,
    }.mutableCopy;
    
    NSDictionary *tokenInfo = @{
        @"ptoken":ptoken,
        @"openid":openid,
        @"atoken":atoken,
        @"current_uin":openid,
        @"platform":@"qq_m",
        @"qq_skey":self.qq_skey
    };
    
    NSString *rc4Str = [DDDZSRc4FFF swRc4EncryptWithSource:[tokenInfo yy_modelToJSONString] rc4Key:game_auth_key];
    
    [param setValue:rc4Str forKey:@"login_token"];
    
    if (self.re_open_token) {
        NSMutableDictionary *game_dic = @{
            @"qtoken":self.qq_token,
            @"deviceinfo88":[self getDeviceInfo],
            @"qq":self.game_auth_dic[@"qq"],
        }.mutableCopy;
        
        if (self.game_auth_sign != nil && self.game_auth_sign.length != 0) {
            [game_dic setValue:self.game_auth_sign forKey:@"sign"];
        }
        
        NSString *rc4Str = [DDDZSRc4FFF swRc4EncryptWithSource:[game_dic yy_modelToJSONString] rc4Key:game_auth_key];
        
        [param setValue:rc4Str forKey:@"game_auth"];
        
        [param setValue:@"上号端重新开通,成功" forKey:@"remark"];
        
    }else {
        
        [param setValue:@"上号成功" forKey:@"remark"];
    }
    
    //上报请求
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:[DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SETTOKENSOFT withPhp:YES] withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
    } withFailBlock:^(NSString * _Nonnull err) {
        
    }];
    
}

- (void)uploadGameTokenWithDic:(NSDictionary *)dic {
    
    NSMutableDictionary *param = @{
        @"hid":self.info.order_info.hid,
        @"order_id":self.info.order_info.orderid,
        @"source":self.upload_source,
        @"err_times":@(0),
        @"quick_version":@"5",
        @"order_login":self.info.quick_info.order_login,
    }.mutableCopy;
    
    NSString *ptoken = dic[@"pay_token"];
    NSString *openid = dic[@"openid"];
    NSString *withAtoken = dic[@"access_token"];
    NSString *pf = dic[@"pf"];
    NSString *pfkey = dic[@"pfkey"];
    NSInteger expires_in = [dic[@"expires_in"] integerValue];
    NSString *encrytoken = dic[@"encrytoken"];
    
    NSDictionary *tokenInfo = @{
        @"ptoken":ptoken,
        @"openid":openid,
        @"atoken":withAtoken,
        @"current_uin":openid,
        @"platform":@"qq_m",
        @"qq_skey":self.qq_skey.length == 0 ? @"" : self.qq_skey,
        @"pf":pf,
        @"pfkey":pfkey,
        @"expires_in":@(expires_in),
        @"encrytoken":encrytoken
    };
    
    
    NSString *rc4Str = [DDDZSRc4FFF swRc4EncryptWithSource:[tokenInfo yy_modelToJSONString] rc4Key:game_auth_key];
    
    [param setValue:rc4Str forKey:@"login_token"];
    
    if (self.re_open_token) {
        NSMutableDictionary *game_dic = @{
            @"qtoken":self.qq_token,
            @"deviceinfo88":[self getDeviceInfo],
            @"qq":self.game_auth_dic[@"qq"],
        }.mutableCopy;
        
        if (self.game_auth_sign != nil && self.game_auth_sign.length != 0) {
            [game_dic setValue:self.game_auth_sign forKey:@"sign"];
        }
        
        NSString *rc4Str = [DDDZSRc4FFF swRc4EncryptWithSource:[game_dic yy_modelToJSONString] rc4Key:game_auth_key];
        
        [param setValue:rc4Str forKey:@"game_auth"];
        
        [param setValue:@"上号端重新开通,成功" forKey:@"remark"];
        
    }else {
        
        [param setValue:@"上号成功" forKey:@"remark"];
    }
    
    //上报请求
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:[DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SETTOKENSOFT withPhp:YES] withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
    } withFailBlock:^(NSString * _Nonnull err) {
        
    }];
    
}
@end



@implementation DDDQQSocket

-(instancetype)initWithIp:(NSString *)ip withPort:(NSInteger)port{
    
    self = [super init];
    
    self.ip = ip;
    
    self.port = port;
    
    _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    return self;
}

-(void)endTask{
    
    [_socket disconnect];
}
-(void)sendDataWith:(NSData *)data withCallBack:(void (^)(NSString *))callback{
    
    if(_socket.isConnected == NO){
       
        NSError * error;
        [_socket connectToHost:_ip onPort:_port error:&error];
        
        if (error != nil){
            
            DDDError([NSString stringWithFormat:@"qqsocket-error-%@",error.description]);
            
            return;
        }
        
        
        _callBack = callback;
        
        [_socket writeData:data withTimeout:-1 tag:0];
        
    }else{
        
        _callBack = callback;
        [_socket writeData:data withTimeout:-1 tag:0];
    }
}


-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
    if (_callBack == nil) {
        
        return;
    }
    
    NSString * str = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    
    DDDLog([NSString stringWithFormat:@"qq Socket did read Data--%@",str]);
    
    _callBack([DDDUtilsFFF hexStringFromData:data]);
    
    _callBack = nil;
}


-(void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag{
    
    [sock readDataWithTimeout:-1 tag:0];
}

@end


