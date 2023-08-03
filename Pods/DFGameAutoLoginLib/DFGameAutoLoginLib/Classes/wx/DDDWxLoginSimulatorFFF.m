//
//  DDDWxLoginSimulatorFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/27.
//

#import "DDDWxLoginSimulatorFFF.h"
#import "DDDRequestTasksFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDLogFFF.h"
@interface DDDWxLoginSimulatorFFF()

@property(nonatomic,strong)dispatch_source_t tokenpollingTimer;
@property(nonatomic,strong)dispatch_source_t resetpollingTimer;
@end

@implementation DDDWxLoginSimulatorFFF


- (void)dealloc{
    
    if (_tokenpollingTimer != nil){
        
        dispatch_source_cancel(_tokenpollingTimer);
        
        _tokenpollingTimer = nil;
    }
    if (_resetpollingTimer != nil){
        
        dispatch_source_cancel(_resetpollingTimer);
        
        _resetpollingTimer = nil;
    }
}


-(void)loginWithInfo:(DDDActInfoFFF *)info{
    
    [super loginWithInfo:info];
    
    [self.loadingView show];
    
    [DDDRequestTasksFFF sw_logingame_wx_joinTokenQueueWithOrderId:self.info.Id WithCallBack:^(NSInteger status) {
        
        if (status == -2){
            
            [self.loadingView hidden];
            self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
            return;
        }
        
        switch (status) {
            case 4:
                
            {
                [self.loadingView hidden];
                [self openAppWithUrl:self.wx_package_openScheme withHandler:^(BOOL result) {
                    
                    
                    self.loginErrorBlock(LGECode_Success, @"");
                }];
            }
                break;
            case 1:
            case 3:
            {
                [self doTokenPollTimer];
            }
                break;
            case -1:
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Json_error, DDDNETErrorDescription);
            default:
                
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Request_CodeError, [NSString stringWithFormat:@"加入token队列-%ld错误",(long)status]);
                break;
        }
    }];
}

-(void)doTokenPollTimer{
    
    if (_tokenpollingTimer != nil){
        
        return;
    }
    __block int  sum = 360;
    WeakObj(self);
    self.tokenpollingTimer = DDDTimer(2, ^{
        
        StrongObj(weakSelf);
        sum -= 2;
        
        if (sum > 0){
            
            [self checkLoginCode];
        }else{
            
            dispatch_source_cancel(strongSelf.tokenpollingTimer);
        }
    });
    
    dispatch_resume(_tokenpollingTimer);
}


-(void)checkLoginCode{
    
    
    [DDDRequestTasksFFF sw_logingame_wx_getTokenWithOrderId:self.info.Id WithCallBack:^(NSInteger status, NSString * _Nonnull msg) {
        
        if (status == -2){
            
            [self.loadingView hidden];
            self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
            return;
        }
        
        switch (status) {
            case 1:
                
            {
                if (self.tokenpollingTimer != nil){
                    
                    dispatch_source_cancel(self.tokenpollingTimer);
                    self.tokenpollingTimer = nil;
                    
                }
                
                if (msg.length == 0){
                    
                    self.loginErrorBlock(LGECode_Request_DataNull, @"获取微信token为空");
                }else{
                    
                    NSString * rc4str = [self tokenDecrypt:[msg uppercaseString]];
                    
                    if (rc4str.length > 0){
                        
                        NSString * url = [NSString stringWithFormat:@"%@oauth?code=%@&state=weixin",self.wx_package_openScheme,rc4str];
                        
                        [self openAppWithUrl:url withHandler:^(BOOL result) {
                            
                            self.loginErrorBlock(LGECode_Success, @"");
                        }];
                    }else{
                        self.loginErrorBlock(LGECode_Crypt_Error, @"获取微信code解密失败");
                        
                    }
                }
            }
                break;
            case 0:
            case 3:
            {
                
                if (self.tokenpollingTimer != nil){
                    
                    dispatch_source_cancel(self.tokenpollingTimer);
                    self.tokenpollingTimer = nil;
                    
                }
                [self joinResetQueue];
            }
                break;
            case -1:
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Json_error, DDDNETErrorDescription);
            case 2:
                DDDLog(@"正在获取游戏信息...");
            default:
                
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Request_CodeError, [NSString stringWithFormat:@"加入token队列-%ld错误",(long)status]);
                break;
        }
        
    }];
}

-(void)joinResetQueue{
    
    [DDDRequestTasksFFF sw_logingame_wx_joinResetQueueWithOrderId:self.info.Id WithCallBack:^(NSInteger status ) {
        
        if (status == -2){
            
            [self.loadingView hidden];
            self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
            return;
        }
        
        switch (status) {
            case 4:
                
            {
                [self.loadingView hidden];
                [self openAppWithUrl:self.wx_package_openScheme withHandler:^(BOOL result) {
                    
                    
                    self.loginErrorBlock(LGECode_Success, @"");
                }];
            }
                break;
            case 1:
            case 3:
            {
                [self doresetPollTimer];
            }
                break;
            case -1:
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Json_error, DDDNETErrorDescription);
            default:
                
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Request_CodeError, [NSString stringWithFormat:@"加入token队列-%ld错误",(long)status]);
                break;
        }
    }];
    
    
    
}

-(void)doresetPollTimer{
    
    if (_resetpollingTimer != nil){
        
        return;
    }
    __block int  sum = 180;
    WeakObj(self);
    self.resetpollingTimer = DDDTimer(2, ^{
        
        StrongObj(weakSelf);
        sum -= 2;
        
        if (sum > 0){
            
            [self checkResetcodeData];
        }else{
            
            dispatch_source_cancel(strongSelf.resetpollingTimer);
        }
    });
    
    dispatch_resume(_resetpollingTimer);
}

-(void)checkResetcodeData{
    
    [DDDRequestTasksFFF sw_logingame_wx_resetDataWithOrderId:self.info.order_id WithCallBack:^(NSInteger status, NSString * _Nonnull msg) {
        
        
        if (status == -2){
            
            [self.loadingView hidden];
            self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
            return;
        }
        
        switch (status) {
            case 1:
                
            {
                if (self.resetpollingTimer != nil){
                    
                    dispatch_source_cancel(self.resetpollingTimer);
                    self.resetpollingTimer = nil;
                    
                }
                
                if (msg.length == 0){
                    
                    self.loginErrorBlock(LGECode_Request_DataNull, @"获取微信token为空");
                }else{
                    
                    NSString * rc4str = [self tokenDecrypt:[msg uppercaseString]];
                    
                    if (rc4str.length > 0){
                        
                        NSString * url = [NSString stringWithFormat:@"%@oauth?code=%@&state=weixin",self.wx_package_openScheme,rc4str];
                        
                        [self openAppWithUrl:url withHandler:^(BOOL result) {
                            
                            self.loginErrorBlock(LGECode_Success, @"");
                        }];
                    }else{
                        self.loginErrorBlock(LGECode_Crypt_Error, @"获取微信code解密失败");
                        
                    }
                }
            }
                break;
            
            case -1:
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Json_error, DDDNETErrorDescription);
            case 2:
                DDDLog(@"待开通.");
            default:
                
                [self.loadingView hidden];
                self.loginErrorBlock(LGECode_Request_CodeError, [NSString stringWithFormat:@"轮询修复-数据异常-%ld错误",(long)status]);
                break;
        }
        
    }];
    
    
}

-(void)taskCancel{
    
    if (_tokenpollingTimer != nil){
        
        dispatch_source_cancel(_tokenpollingTimer);
        
        _tokenpollingTimer = nil;
    }
    if (_resetpollingTimer != nil){
        
        dispatch_source_cancel(_resetpollingTimer);
        
        _resetpollingTimer = nil;
    }
}

@end
