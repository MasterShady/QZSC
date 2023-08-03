//
//  DDDWxLoginIpadLocalFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/27.
//

#import "DDDWxLoginIpadLocalFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDHttpServiceFFF.h"
#import "DDDZHTQueryModelFFF.h"
#import "DDDRequestTasksFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDLogFFF.h"
#import "DDDZHTReqTxModelFFF.h"
#import "DDDCriptsFFF.h"

@interface DDDWxLoginIpadLocalFFF ()
@property(nonatomic,strong)DDDZHTQueryModelFFF * queryModel;

@property(nonatomic,strong)DDDQueueHttpTaskFFF * currentQueryTask;

@property BOOL redo_460;

@property NSInteger step;


@end

@implementation DDDWxLoginIpadLocalFFF


-(void)loginWithInfo:(DDDActInfoFFF *)info{
    
    [super loginWithInfo:info];
    [self datainit];
    [self.loadingView show];
    [self doTaskWithData:nil];
}

-(void)doTaskWithData:(id)withData{
    
    switch (self.step) {
        case 1:
        {
            [self requestLoginTask];
        }
            break;
        case 2:
        {
            [self queueTask_queryRefreshTokenPackage];
        }
            break;
        case 3:
        {
            [self tencentTask_refreshTokenWith:withData];
        }
            break;
        case 4:
        {
            [self sendTokenTaskWithtokenData:withData];
        }
            break;
        case 5:
        {
            [self queueTask_queryAuthCodePackage];
        }
            break;
        case 6:
        {
            [self tencentTask_queryAuthCode:withData];
        }
            break;
        case 7:
        {
            [self sendAuthCodeTaskWithCode:withData];
        }
            break;
        case 8:
        {
            [self queueTask_queryResult];
        }
            break;
        default:
            DDDError(@"未知操作");
            break;
    }
}

-(void)retry{
    
    [_currentQueryTask taskEnd];
    _currentQueryTask = nil;
    [self datainit];
    [self doTaskWithData:nil];
}
-(void)taskCancel{
    
    [_currentQueryTask taskEnd];
    _currentQueryTask = nil;
}

-(void)datainit{
    
    _step = 1;
    _redo_460 = NO;
}


-(void)requestLoginTask{
    
    DDDLog(@"即将发起本地上号流程");
    
    [DDDRequestTasksFFF sw_zht_login_requestWithBusniss:self.quickModel.biz_type WithOpenMode:@"2" withpt:self.quickModel.pt withbusinessData:self.quickModel.biz_data withsuccessBack:^(DDDModelBaseFFF<NSString *> * _Nonnull model) {
        
        if(model == nil){
            
            self.loginErrorBlock(LGECode_Json_error, @"数据解析异常");
            return;
        }
        if (model.data == nil || model.data.length == 0){
            
            self.loginErrorBlock(LGECode_Request_DataNull, @"接口返回数据为空");
            return;
        }
        
        DDDZHTQueryModelFFF * dataModel = [DDDUtilsFFF zhongTai_dataWith:model.data withModelClass:DDDZHTQueryModelFFF.class];
        
        if (dataModel == nil){
            
            self.loginErrorBlock(LGECode_Crypt_Error, @"数据解密失败");
            return;
        }
        self.queryModel = dataModel;
        self.step = 2;
        [self doTaskWithData:nil];
        
    } withErrorBack:^(NSString * _Nonnull errorMsg) {
        self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
    }];
}

-(void)sendTokenTaskWithtokenData:(NSString *)tokenData{
    
    DDDLog(@"Step  4发送token到中台");
    NSDictionary * param = @{@"queueId":self.queryModel.queueId,
                             @"openMode":@"2",
                             @"analysisType":@"1",
                             @"txdata":tokenData
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_getResult withPhp:NO];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF<NSString *> * _Nullable model) {
        
        if (model == nil){
            
            self.loginErrorBlock(LGECode_Json_error, @"数据解析异常");
            return;
        }
        
        if(model.code == 200){
            
            self.step = 5;
            [self doTaskWithData:nil];
        }else{
            
            self.loginErrorBlock(LGECode_Request_CodeError, model.msg);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
    }];
}


-(void)sendAuthCodeTaskWithCode:(NSString *)authcode{
    
    DDDLog(@"Step   7发送授权码到中台");
    NSDictionary * param = @{@"queueId":self.queryModel.queueId,
                             @"openMode":@"2",
                             @"analysisType":@"2",
                             @"txdata":authcode
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_getResult withPhp:NO];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF<NSString *> * _Nullable model) {
        
        if (model == nil){
            
            self.loginErrorBlock(LGECode_Json_error, @"数据解析异常");
            return;
        }
        
        if(model.code == 200){
            
            self.step = 8;
            [self doTaskWithData:nil];
        }else{
            
            self.loginErrorBlock(LGECode_Request_CodeError, model.msg);
        }
        
    } withFailBlock:^(NSString * _Nonnull errorMsg) {
        
        self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
    }];
}


-(void)queueTask_queryRefreshTokenPackage{
    
    DDDLog(@"Step 2 轮询查询 刷新token数据包接口");
    [_currentQueryTask taskEnd];
    _currentQueryTask = nil;
    
    NSDictionary * param = @{@"queueId":self.queryModel.queueId,
                             @"openMode":@"2",
                             @"txDataType":@"1"
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_QueryTxDataPackage withPhp:NO];
    WeakObj(self);
    _currentQueryTask = [[DDDQueueHttpTaskFFF alloc] initWithBlock:^(DDDModelBaseFFF<NSString *> * _Nonnull model, NSString * _Nonnull errorMsg) {
        
        if (errorMsg != nil){
            
            weakSelf.loginErrorBlock(LGECode_Request_Net, errorMsg);
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
            
        if (model == nil){
                
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        
        if (model.code != 200){
            
            weakSelf.loginErrorBlock(LGECode_Request_CodeError, @"状态码异常");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        if (model.data.length > 0){
            
            NSString * jsonStr = [DDDAESFFF AES256DecryptECB:model.data key:[DDDUtilsFFF zhongtai_aesKey]];
            DDDLog([NSString stringWithFormat:@"服务器上号结果:%@",jsonStr]);
            
            if ([jsonStr isEqualToString:@"null"]){
                
                DDDLog(@"未获取到异步轮询的数据 继续 轮询");
                
            }else{
                
                [weakSelf.currentQueryTask taskEnd];
                
                DDDZHTReqTxModelFFF * txmodel = [DDDZHTReqTxModelFFF yy_modelWithJSON:jsonStr];
                
                if(txmodel == nil){
                    
                    weakSelf.loginErrorBlock(LGECode_Crypt_Error, @"数据解密失败");
                }else{
                    
                    if (txmodel.handleStatus == 30){
                        
                        if(weakSelf.step != 3){

                            weakSelf.step = 3;
                            
                            [weakSelf doTaskWithData:txmodel.reqTxData];
                            
                        }
                    }else{
                        
                        [weakSelf uploadResultWithModel:txmodel];
                    }
                }
            }
            
            
        }else{
            
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
        }
        
    }];
    _currentQueryTask.service = service;
    _currentQueryTask.responseClass = NSString.class;
    [_currentQueryTask taskDo];
}


-(void)queueTask_queryAuthCodePackage{
    
    DDDLog(@"Step  5 轮询查询 查询游戏授权码数据包接口");
    [_currentQueryTask taskEnd];
    _currentQueryTask = nil;
    
    NSDictionary * param = @{@"queueId":self.queryModel.queueId,
                             @"openMode":@"2",
                             @"txDataType":@"2"
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_QueryTxDataPackage withPhp:NO];
    WeakObj(self);
    _currentQueryTask = [[DDDQueueHttpTaskFFF alloc] initWithBlock:^(DDDModelBaseFFF<NSString *> * _Nonnull model, NSString * _Nonnull errorMsg) {
        
        if (errorMsg != nil){
            
            weakSelf.loginErrorBlock(LGECode_Request_Net, errorMsg);
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
            
        if (model == nil){
                
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        
        if (model.code != 200){
            
            weakSelf.loginErrorBlock(LGECode_Request_CodeError, @"状态码异常");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        if (model.data.length > 0){
            
            NSString * jsonStr = [DDDAESFFF AES256DecryptECB:model.data key:[DDDUtilsFFF zhongtai_aesKey]];
            DDDLog([NSString stringWithFormat:@"服务器上号结果:%@",jsonStr]);
            
            if ([jsonStr isEqualToString:@"null"]){
                
                DDDLog(@"未获取到异步轮询的数据 继续 轮询");
                
            }else{
                
                [weakSelf.currentQueryTask taskEnd];
                
                DDDZHTReqTxModelFFF * txmodel = [DDDZHTReqTxModelFFF yy_modelWithJSON:jsonStr];
                
                if(txmodel == nil){
                    
                    weakSelf.loginErrorBlock(LGECode_Crypt_Error, @"数据解密失败");
                }else{
                    
                    if (txmodel.handleStatus == 30){
                        
                        if(weakSelf.step != 6){

                            weakSelf.step = 6;
                            
                            [weakSelf doTaskWithData:txmodel.reqTxData];
                            
                        }
                    }else if (txmodel.handleStatus == 460){
                        
                        if(!weakSelf.redo_460){
                         
                            weakSelf.redo_460 = YES;
                            if(weakSelf.step != 3){
                                
                                weakSelf.step = 3;
                                
                                [weakSelf doTaskWithData:txmodel.reqTxData];
                            }
                        }else{
                            
                            DDDLog(@"游戏授权码数据包接口 460 重复");
                            
                            [weakSelf uploadResultWithModel:txmodel];
                        }
                    }else{
                        
                        [weakSelf uploadResultWithModel:txmodel];
                    }
                }
            }
            
            
        }else{
            
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
        }
        
    }];
    _currentQueryTask.service = service;
    _currentQueryTask.responseClass = NSString.class;
    [_currentQueryTask taskDo];
}


-(void)queueTask_queryResult{
    
    
    DDDLog(@"MARK: Step   8 轮询查询 查询解密过的授权码");
    [_currentQueryTask taskEnd];
    _currentQueryTask = nil;
    
    NSDictionary * param = @{@"queueId":self.queryModel.queueId,
                             @"openMode":@"2"
                             
    };
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_ZHT_API_getAuthCode withPhp:NO];
    WeakObj(self);
    _currentQueryTask = [[DDDQueueHttpTaskFFF alloc] initWithBlock:^(DDDModelBaseFFF<NSString *> * _Nonnull model, NSString * _Nonnull errorMsg) {
        
        if (errorMsg != nil){
            
            weakSelf.loginErrorBlock(LGECode_Request_Net, errorMsg);
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
            
        if (model == nil){
                
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        
        if (model.code != 200){
            
            weakSelf.loginErrorBlock(LGECode_Request_CodeError, @"状态码异常");
            [weakSelf.currentQueryTask taskEnd];
            return;
        }
        
        if (model.data.length > 0){
            
            NSString * jsonStr = [DDDAESFFF AES256DecryptECB:model.data key:[DDDUtilsFFF zhongtai_aesKey]];
            DDDLog([NSString stringWithFormat:@"服务器上号结果:%@",jsonStr]);
            
            if ([jsonStr isEqualToString:@"null"]){
                
                DDDLog(@"未获取到异步轮询的数据 继续 轮询");
                
            }else{
                
                [weakSelf.currentQueryTask taskEnd];
                
                DDDZHTReqTxModelFFF * txmodel = [DDDZHTReqTxModelFFF yy_modelWithJSON:jsonStr];
                
                if(txmodel == nil){
                    
                    weakSelf.loginErrorBlock(LGECode_Crypt_Error, @"数据解密失败");
                }else{
                    
                    if(weakSelf.step != 1){
                        
                        weakSelf.step = 1;
                        
                        [weakSelf uploadResultWithModel:txmodel];
                    }
                }
            }
            
            
        }else{
            
            weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"返回数据为空");
            [weakSelf.currentQueryTask taskEnd];
        }
        
    }];
    _currentQueryTask.service = service;
    _currentQueryTask.responseClass = NSString.class;
    [_currentQueryTask taskDo];
}



-(void)tencentTask_refreshTokenWith:(NSString *)withReqTxData{
    
    DDDLog(@"Step 3调用腾讯刷新token接口");
    
    NSURLRequest * request = [NSURLRequest urlRequestFromTxdata:withReqTxData];
    
    if (request == nil){
        
        
        [self taskCancel];
        self.loginErrorBlock(LGECode_TxRequest_Error, @"");
        return;
    }
    
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(error != nil){
                
                [self taskCancel];
                DDDError(error.debugDescription);
                self.loginErrorBlock(LGECode_TxRequest_Error, @"Tx接口访问失败3");
                return;
            }
            
            if (data.length == 0){
                [self taskCancel];
                DDDError(@"Tx接口data为空3");
                self.loginErrorBlock(LGECode_TxRequest_Error, @"Tx接口data为空3");
                
                return;
            }
            
            self.step = 4;
            
            [self doTaskWithData: [data base64EncodedStringWithOptions:0]];
            
        });
    }];
    
    [task resume];
}


-(void)tencentTask_queryAuthCode:(NSString *)withReqTxData{
    
    DDDLog(@"Step  6  调用腾讯获取游戏授权码接口");
    
    NSURLRequest * request = [NSURLRequest urlRequestFromTxdata:withReqTxData];
    
    if (request == nil){
        
        
        [self taskCancel];
        self.loginErrorBlock(LGECode_TxRequest_Error, @"");
        return;
    }
    
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(error != nil){
                
                [self taskCancel];
                DDDError(error.debugDescription);
                self.loginErrorBlock(LGECode_TxRequest_Error, @"Tx接口访问失败6");
                return;
            }
            
            if (data.length == 0){
                [self taskCancel];
                DDDError(@"Tx接口data为空6");
                self.loginErrorBlock(LGECode_TxRequest_Error, @"Tx接口data为空6");
                
                return;
            }
            
            self.step = 7;
            
            [self doTaskWithData: [data base64EncodedStringWithOptions:0]];
            
        });
    }];
    
    [task resume];
}


-(void)uploadResultWithModel:(DDDZHTReqTxModelFFF*)model{
    
    [DDDRequestTasksFFF sw_wx_login_reportwithQueue_id:self.quickModel.queue_id withOrder_id:self.info.order_id withUncode:self.info.unlock_code withStatus:[NSString stringWithFormat:@"%ld",(long)(model.handleStatus == 30 ? 1:model.handleStatus)] withRemark:model.handleStatusMsg withQuickVersion:@"7" WithCallBack:^(NSInteger status, NSString * _Nonnull message) {
        
        
        if (status == -1 || status == -2 || status == 1){
            
            
            if (model.authCode.length == 0){
                
                self.loginErrorBlock(LGECode_Request_DataNull, @"授权码为空");
                return;
            }
            
            NSString * url = [NSString stringWithFormat:@"%@oauth?code=%@&state=weixin",self.wx_package_openScheme,model.authCode];
            
            [self openAppWithUrl:url withHandler:^(BOOL result) {
                
                self.loginErrorBlock(LGECode_Success, @"");
            }];
        }
        
        
        else if(status == 2){
            
            [self retry];
        }
        
       else if (status == 3){
            
            self.reloadBlock(message);
            [self taskCancel];
        }
        
       else{
           self.loginErrorBlock(LGECode_TxRequest_Error, message);
           [self taskCancel];
       }
    }];
    
    
    
    
    
}
@end
