//
//  DDDGameAutoLoginToolFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDGameAutoLoginToolFFF.h"
#import "DDDAutoLoginPlatformBaseFFF.h"
#import "DDDLoginGameLoadingViewProtocolFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDQQLoginFFF.h"
#import "DDDHMCloudGameLoginFFF.h"
#import "DDDWxLoginBaseFFF.h"
#import "DDDConstFFF.h"
#import "DDDLogFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import "DDDLoadingProviderFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDRequestTasksFFF.h"
const  NSErrorDomain DDDSmErrorDomain =  @"DDDSmNSErrorDomain";
const  NSErrorDomain DDDAutoGameErrorDomain =  @"DDDAutoGameErrorDomain";
const  NSErrorDomain DDDAutoGameQQErrorDomain =  @"DDDAutoGameQQErrorDomain";
const  NSErrorDomain DDDAutoGameWXErrorDomain =  @"DDDAutoGameWXErrorDomain";
const  NSErrorDomain DDDAutoGameCloudErrorDomain =  @"DDDAutoGameCloudErrorDomain";
@import DFRiskSDK;
@interface DDDGameAutoLoginToolFFF()<DDDHMCloudGameLoginProtocolFFF>
{
    DDDWxLoginBaseFFF * _wx;
    DDDHMCloudGameLoginFFF * _hmcloud;
    DDDQQLoginFFF * _qq;
}

@property(nonatomic,copy)NSString * OSTag;

@property(nonatomic,strong)DDDLoadingProviderFFF * loadingProvider;
@property(nonatomic,strong)DDDSmCheckUtilFFF * smCheckUtil;
@property(nonatomic,strong)id<DDDAutoLoginPlatformProtocolFFF> currentPlatform;


@end

@implementation DDDGameAutoLoginToolFFF

-(DDDLoadingProviderFFF *)loadingProvider{
    
    if(_loadingProvider == nil){
        
        _loadingProvider = [DDDLoadingProviderFFF new];
        WeakObj(self);
        [_loadingProvider setCancelBlock:^{
            
            [weakSelf cancel];
        }];
    }
    return _loadingProvider;
}

-(instancetype)initWithToken:(NSString *)token withUUID:(NSString *)uuid withApiType:(NSInteger)apitype withAppVersion:(NSString *)appversion withAppsign:(NSString *)appsign withAppid:(NSString *)appid withWebsocketSign:(NSString *)websocketsign withshumeiId:(NSString *)shumeiid withsmid:(NSString *)smid{
    
    self = [super init];
    DDDOtherInfoWrapFFF * wrap = [DDDOtherInfoWrapFFF shared];
    if(self){
        
        wrap.token = token;
        wrap.uuid = uuid;
        [DDDHttpToolFFF defaultTool].api_env = apitype;
        wrap.shumei_id = shumeiid;
        wrap.smid = smid;
        wrap.appversion = appversion;
        wrap.appId = appid;
        wrap.httpSignStr = appsign;
        wrap.websocketSignStr = websocketsign;
        
#ifdef  DEBUG
        wrap.loglevel = DDDLogLevelAll;
        
#else
        wrap.loglevel = DDDLogLevelNone;
#endif
    }
    
    return self;
}


-(void)setActInfo:(DDDActInfoFFF *)actInfo{
    
    _actInfo = actInfo;
    [self.loadingProvider setLoadingViewWithInfo:actInfo];
    
}
-(NSString *)OSTag{
    
    return  @"ios";
}

-(void)cancel{
    
    [_currentPlatform taskCancel];
    _currentPlatform = nil;
}

-(void)doTask{
    
    [self smCheck];
}

-(void)smCheck{
    
    
    _smCheckUtil = [DDDSmCheckUtilFFF new];
    _smCheckUtil.uncode = self.actInfo.unlock_code;
    [[self.loadingProvider getLoadingVieW] show];
    WeakObj(self);
    [_smCheckUtil setResultBlock:^(NSInteger resultType, id _Nullable resultbody) {
        
        switch (resultType) {
            case 1:
            {
                [weakSelf loginGame];
            }
                break;
            case 3:
            {
                [[weakSelf.loadingProvider getLoadingVieW] hidden];
                [weakSelf.delegate toolTaskErrorWith:(NSError *)resultbody withCompletion:^{
                    [[weakSelf.loadingProvider getLoadingVieW] hidden];
                }];
            }
            case 2:
            {
                [[weakSelf.loadingProvider getLoadingVieW] hidden];
                [weakSelf.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDSmErrorDomain code:LGECode_SMCheck_Fail userInfo:@{@"message":resultbody}] withCompletion:^{
                    [[weakSelf.loadingProvider getLoadingVieW] hidden];
                }];
            }
                break;
            default:
                break;
        }
    }];
}

-(void)loginGame{
    
    if(_actInfo == nil){
        
        return;
    }
    
    if(_actInfo.is_cloudGame){
        [self cloud];
        return;
    }
    
    if(_actInfo.yx != self.OSTag){
        
        [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Param_Error userInfo:@{@"message":@"账号非iOS平台"}] withCompletion:^{
            
            [[self.loadingProvider getLoadingVieW] hidden];
        }];
        return;
    }
    
    [DDDRequestTasksFFF sw_loginGame_checkDeviceUidWithuncode:_actInfo.unlock_code withCallBack:^(BOOL result , NSString * _Nonnull message) {
        
        if(!result){
            
            [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Request_CodeError userInfo:@{@"message":message}] withCompletion:^{
                
                [[self.loadingProvider getLoadingVieW] hidden];
            }];
            return;
        }
        
        if(self.actInfo.is_wx_server){
            
            [self wx];
        }else{
            
            [self qq];
        }
    }];
}
-(void)wx{
    
    void(^doBlock)(void) = ^{
        
        self.currentPlatform = self->_wx;
        self->_wx.loadingView = [self.loadingProvider getLoadingVieW];
        WeakObj(self);
        [self->_wx setLoginErrorBlock:^(DDDErrorCode ecode, NSString * _Nullable message) {
            
            StrongObj(weakSelf);
            
            [strongSelf->_wx.loadingView hidden];
            if(ecode == LGECode_Success){
                
                [strongSelf.delegate toolFinished];
            }else{
                [strongSelf.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameWXErrorDomain code:ecode userInfo:@{@"message":message}] withCompletion:^{
                    [[strongSelf.loadingProvider getLoadingVieW] hidden];
                }];
            }
        }];
        [self->_wx setReloadBlock:^(NSString * _Nullable message) {
            StrongObj(weakSelf);
            [strongSelf->_wx.loadingView hidden];
            [strongSelf.delegate orderNeedReloadWithMessage:message];
        }];
        
        [self->_wx.loadingView show];
        [self->_wx loginWithInfo:self.actInfo];
    };
    
    if(_actInfo.wx_type == 0){
        
        _wx = [DDDWxLoginBaseFFF wechatLoginWith:nil];
        doBlock();
    }else{
        
        [DDDRequestTasksFFF sw_logingame_qq_getOrderInfoWithUncode:_actInfo.unlock_code withCallBack:^(NSInteger code, NSString * _Nullable message, DDDQuickLoginModelFFF * _Nullable model) {
            
            if(code == 1){
               
                if(model.quick_info == nil){
                    
                    [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Request_DataNull userInfo:@{@"message":@"微信上号返回数据错误"}] withCompletion:^{
                        
                        [[self.loadingProvider getLoadingVieW] hidden];
                    }];
                    
                    return;
                }
                
                if(model.quick_info.credential.length == 0){
                    
                    
                    [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Request_DataNull userInfo:@{@"message":@"微信上号凭证为空"}] withCompletion:^{
                        
                        [[self.loadingProvider getLoadingVieW] hidden];
                    }];
                    return;
                }
                
                [DDDOtherInfoWrapFFF shared].zhongtai_credential = model.quick_info.credential;
                [DDDOtherInfoWrapFFF shared].zhongtai_bid = model.quick_info.biz_id;
                self->_wx = [DDDWxLoginBaseFFF wechatLoginWith: model.quick_info];
                doBlock();
            }
            else if (code == -1){
                [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Json_error userInfo:@{@"message":@"数据异常"}] withCompletion:^{
                    
                    [[self.loadingProvider getLoadingVieW] hidden];
                }];
            }
            else if (code == -2){
                [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Request_Net userInfo:@{@"message":DDDNETErrorDescription}] withCompletion:^{
                    
                    [[self.loadingProvider getLoadingVieW] hidden];
                }];
            }else{
                
                [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameErrorDomain code:LGECode_Request_CodeError userInfo:@{@"message":[NSString stringWithFormat:@"异常状态码%ld",(long)code]}] withCompletion:^{
                    
                    [[self.loadingProvider getLoadingVieW] hidden];
                }];
            }
        }];
    }
    
}
-(void)qq{
    
    _qq = [DDDQQLoginFFF new];
    _currentPlatform = _qq;
    _qq.loadingView = [self.loadingProvider getLoadingVieW];
    [_qq loginWithInfo:_actInfo];
    WeakObj(self);
    [_qq setLoginErrorBlock:^(DDDErrorCode code, NSString * _Nonnull message) {
        
        StrongObj(weakSelf);
        
        if(code ==  LGECode_Success){
            
            [strongSelf.delegate toolFinished];
        }
        else{
            [strongSelf.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameQQErrorDomain code:code userInfo:@{@"message":message}] withCompletion:^{
                [[strongSelf.loadingProvider getLoadingVieW] hidden];
            }];
        }
    }];
    [_qq setReloadBlock:^{
        
        
        StrongObj(weakSelf);
        [strongSelf->_qq.loadingView hidden];
        [strongSelf.delegate orderNeedReloadWithMessage:nil];
    }];
}
-(void)cloud{
    
    _hmcloud = [DDDHMCloudGameLoginFFF new];
    _currentPlatform = _hmcloud;
    _hmcloud.currentViewController = [self.delegate HMCloudGamePresentViewController];
    _hmcloud.delegate = self;
    _hmcloud.loadingView = [self.loadingProvider getLoadingVieW];
    [DDDOtherInfoWrapFFF shared].hmcloudLouadingView = [self.loadingProvider getHMCloudGamePageLoadingView];
    [_hmcloud loginWithInfo:_actInfo];
}






-(void)SWHMCloudGameLoginTaskError:(NSError * )error{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self->_hmcloud.loadingView hidden];
        [self.delegate toolTaskErrorWith:[NSError errorWithDomain:DDDAutoGameCloudErrorDomain code:LGECode_HMCloud_Error userInfo:@{@"message":error.userInfo[@"message"]}] withCompletion:^{
            
            [[self.loadingProvider getLoadingVieW] hidden];
        }];
    });
}
-(void)SWHMCloudGamePageDidPresent:(UIViewController *)vc{
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        id<DDDLoginGameLoadingViewProtocolFFF> loading = [[DDDOtherInfoWrapFFF shared] hmcloudLouadingView];
        
        if([loading isKindOfClass:UIView.class]){
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                UIView * loadingView = (UIView *)loading;
                loadingView.frame = vc.view.bounds;
                [vc.view addSubview:loadingView];
            });
        }
        
    });
}
-(void)SWHMCloudGameLoginSuccess{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        id<DDDLoginGameLoadingViewProtocolFFF> loading = [[DDDOtherInfoWrapFFF shared] hmcloudLouadingView];
        
        if([loading isKindOfClass:UIView.class]){
            
           
            [loading hidden];
               
         
        }
        
        
        [self.delegate toolFinished];
    });
    
}
-(void)SWHMCloudGameOrderEnd{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate orderNeedReloadWithMessage:@"订单已经结束"];
    });
}
-(void)SWHMCloudGameOrderAutoTs{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate orderNeedReloadWithMessage:@"云游戏登录异常，已自动撤单"];
    });
}
-(void)SWHMCloudGameCloseDidGame{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.delegate HMCloudGameClose];
    });
}
@end


@interface DDDSmCheckUtilFFF()
@property NSInteger checkCount;
@property NSInteger checkMaxCount;
@property NSTimeInterval checkInterval;

@end


@implementation DDDSmCheckUtilFFF


-(void)check{
     
    [self datainit];
    
}

-(void)datainit{
    
    _checkCount = 1;
    _checkMaxCount = 10;
    _checkInterval = 0.5;
}

-(void)httptask{
    
    
    NSString * xdid = [DFRiskSDK xdid];
    
    
    NSString * rc4Str = [DDDZSRc4FFF swRc4DecryptWithSource:[NSString stringWithFormat:@"%@%.0f",xdid,[NSDate new].timeIntervalSince1970 * 1000] rc4Key:xdid_rc4_key];
    
    NSDictionary * param = @{@"dh":_uncode,
                             @"req_num":@(_checkCount),
                             @"sm_version":@"100",
                             @"xdid":rc4Str,
                             @"isv":@"1000",
                             @"env_info":[@{@"isRoot":@([DFRiskSDK risk])} yy_modelToJSONString]
    };
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_SMVerify withPhp:YES];
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        
        if(model == nil){
            
            self.resultBlock(3, [NSError errorWithDomain:DDDSmErrorDomain code:LGECode_Request_DataNull userInfo:@{@"message":@"设备环境检测未通过!!"}]);
            return;
        }
        if (model.status == 3){
            
            [self retryHttpTask];
        }
        else if (model.status == 0){
            
            self.resultBlock(2, model.message);
        }
        else if (model.status == 1 || model.status == 2){
            
            self.resultBlock(1, nil);
        }else{
            
            self.resultBlock(3, [NSError errorWithDomain:DDDSmErrorDomain code:LGECode_Request_CodeError userInfo:@{@"message":@"设备环境检测未通过!!!"}]);
        }
        
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
        self.resultBlock(3, [NSError errorWithDomain:DDDSmErrorDomain code:LGECode_Request_Net userInfo:@{@"message":@"设备环境检测未通过!!!"}]);
    }];
}
-(void)retryHttpTask{
    
    
    if(_checkCount >= 11){
        
        self.resultBlock(1, nil);
        return;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        self.checkCount += 1;
        
        [self httptask];
    });
}
@end
