//
//  DDDWxLoginIpadServerFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/27.
//

#import "DDDWxLoginIpadServerFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDHttpServiceFFF.h"
#import "DDDZHTQueryModelFFF.h"
#import "DDDRequestTasksFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDLogFFF.h"
#import "DDDZHTReqTxModelFFF.h"
#import "DDDCriptsFFF.h"
@interface DDDWxLoginIpadServerFFF ()

@property BOOL isReport;
@property(nonatomic,strong)DDDQueueHttpTaskFFF * server_queue_task;

@property(nonatomic,strong)DDDZHTQueryModelFFF * queryModel;
@end

@implementation DDDWxLoginIpadServerFFF

- (void)loginWithInfo:(DDDActInfoFFF *)info{
    
    [super loginWithInfo:info];
    
    [self requestLoginTask];
}

-(void)requestLoginTask{
    
    [DDDRequestTasksFFF sw_zht_login_requestWithBusniss:self.quickModel.biz_type WithOpenMode:@"1" withpt:self.quickModel.pt withbusinessData:self.quickModel.biz_data withsuccessBack:^(DDDModelBaseFFF<NSString *> * _Nonnull model) {
        
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
        [self queueTask_queryLoginResult];
        
    } withErrorBack:^(NSString * _Nonnull errorMsg) {
        self.loginErrorBlock(LGECode_Request_Net, DDDNETErrorDescription);
    }];
}

-(void)retry{
    
    _isReport = NO;
    [self.server_queue_task taskEnd];
    [self requestLoginTask];
}

-(void)queueTask_queryLoginResult{
    
    WeakObj(self);
    _server_queue_task = [[DDDQueueHttpTaskFFF alloc] initWithBlock:^(DDDModelBaseFFF<NSString*> * _Nonnull model, NSString * _Nonnull errorMsg) {
        
        if (model == nil){
            
            weakSelf.loginErrorBlock(LGECode_Request_Net, errorMsg);
            [weakSelf.server_queue_task taskEnd];
            return;
        }
        
        if (model.code != 200){
            
            weakSelf.loginErrorBlock(LGECode_Request_CodeError, @"状态码异常");
            [weakSelf.server_queue_task taskEnd];
        }
        else{
            if (model.data == nil || model.data.length == 0){
                
                weakSelf.loginErrorBlock(LGECode_Request_DataNull, @"接口返回数据为空");
                
                [weakSelf.server_queue_task taskEnd];
                
                return;
            }
            
            NSString * jsonStr = [DDDAESFFF AES256DecryptECB:model.data key:[DDDUtilsFFF zhongtai_aesKey]];
            DDDLog([NSString stringWithFormat:@"服务器上号结果:%@",jsonStr]);
            
            if ([jsonStr isEqualToString:@"null"]){
                
                DDDLog(@"未获取到异步轮询的数据 继续 轮询");
                return;
            }else{
                
                [weakSelf.server_queue_task taskEnd];
                
                DDDZHTReqTxModelFFF * txmodel = [DDDZHTReqTxModelFFF yy_modelWithJSON:jsonStr];
                
                if(txmodel == nil){
                    
                    weakSelf.loginErrorBlock(LGECode_Request_CodeError, @"数据解密失败");
                }else{
                    
                    if (!weakSelf.isReport){
                        
                        
                        weakSelf.isReport = YES;
                        
                        [weakSelf uploadResultWithModel:txmodel];
                    }
                }
            }
            
            
        }
        
    }];
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:@{@"queueId":self.queryModel.queueId,@"openMode":@"1"} withApi:SW_ZHT_API_QueryLoginResult withPhp:NO];
    
    _server_queue_task.service = service;
    _server_queue_task.responseClass = NSString.class;
    [_server_queue_task taskDo];
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

-(void)taskCancel{
    
    [_server_queue_task taskEnd];
}
@end
