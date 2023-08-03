//
//  DDDHMCloudGameLoginFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDHMCloudGameLoginFFF.h"
#import "DDDCloudPlayerWarpperFFF.h"
#import <AVFoundation/AVFoundation.h>
#import "DDDQuickLoginModelFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDRequestTasksFFF.h"
#import "DDDLogFFF.h"
#import "DDDConstFFF.h"
#import "DDDHMCloudSuspendViewFFF.h"
#import "DDDHMCloudBackGameViewFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import "NSString+DDDFFF.h"

#import "DDDHttpServiceFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDSWHMCloudMiddlewareLoginModelFFF.h"
#import "DDDSWHMCloudMessageModelFFF.h"
#import "DDDSWWebsocketMessageModelFFF.h"
#import "DDDCriptsFFF.h"


#import <SocketRocket/SocketRocket.h>
#import <YYModel/YYModel.h>

NSErrorDomain DDDHMCloudErrorDomain = @"DDDHMCloudErrorDomain";

NSURL * DDD_webSocketUrl(void);

#if !TARGET_OS_SIMULATOR

@import HMCloudPlayerCore;

#endif

@interface DDDHMCloudGameLoginFFF()<SRWebSocketDelegate>
{
    int hmSDKRegisted;
    int cloud_plan;
    int timeOut;
    BOOL is_offline;
    int library_version;
    BOOL hmcloudStatus_InGame;
    BOOL checkLoginStatus;
    BOOL isReportLoginType;
    BOOL timeOffLineTrigger;
    DDDQuickLoginModelFFF * unlockModel;
    void(^hmSDKRegistBlock)(void);
    NSString * gamePackage;
    NSString * quick_type_sub;
    SRWebSocket * order_websocket;
    NSString * websocket_session_id;
    dispatch_source_t timer_websocket;
    UIViewController * cloudGameVC;
}
@end

#if !TARGET_OS_SIMULATOR

@interface DDDHMCloudGameLoginFFF(zhenji)<CloudPlayerWarpperDelegate>



@end

#endif

@implementation DDDHMCloudGameLoginFFF

-(void)dealloc{
#if !TARGET_OS_SIMULATOR
    [self websocket_sendTask_cancel];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#endif
    
}

- (instancetype)init{
    
    self = [super init ];
    [self dataInit];
#if !TARGET_OS_SIMULATOR
    [DDDCloudPlayerWarpperFFF sharedWrapper].delegate = self;
    hmSDKRegisted = [[DDDCloudPlayerWarpperFFF sharedWrapper] isRegisted] ? 1 : -1;
#endif
    
    
    return  self;
}

-(void)dataInit{
    
    hmSDKRegisted = -1;
    is_offline = false;
    timeOut = 0;
    library_version = 0;
    cloud_plan = 0;
    hmcloudStatus_InGame = false;
    checkLoginStatus = false;
    isReportLoginType = false;
    timeOffLineTrigger = false;
}

-(void)loginWithInfo:(DDDActInfoFFF *)info{
    
    [super loginWithInfo:info];
    
    
}

-(void)doTask{
    
    UIAlertController * alertview = [UIAlertController alertControllerWithTitle:@"提示" message:@"游戏过程中会消耗大量流量,请在wifi环境下体验游戏" preferredStyle:UIAlertControllerStyleAlert];
    [alertview addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self beginHmCloud];
    }]];
    
    [[DDDUtilsFFF getCurrentViewController] presentViewController:alertview animated:YES completion:nil];
}


-(void)beginHmCloud{
    
#if TARGET_OS_SIMULATOR
   
    [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:102 userInfo:@{@"message":@"HMCloud 海马云SDK不支持模拟器运行"}]];
#endif
    

    
    [self.loadingView show];
    
    [DDDRequestTasksFFF sw_logingame_qq_getOrderInfoWithUncode:self.info.unlock_code withCallBack:^(NSInteger status, NSString * _Nullable errorMessage, DDDQuickLoginModelFFF * _Nullable model) {
        
        
        if(status == 1){
            
            if(model == nil){
                
                [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:301 userInfo:@{@"message":@"HMCloud 获取上号信息失败-返回数据为空"}]];
               
                return;
            }
            
            self->unlockModel = model;
            
            [self beginHmGame];
            
        }else if (status ==  -2){
            
            [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:301 userInfo:@{@"message":@"HMCloud 获取上号信息失败-网络异常"}]];
            DDDError(@"HMCloud 获取上号信息失败-网络异常");
        }else if (status == -1){
            
            [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:301 userInfo:@{@"message":@"HMCloud 获取上号信息失败-数据解析失败"}]];
            DDDError(@"HMCloud 获取上号信息失败-数据解析失败");
        }else{
            [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:301 userInfo:@{@"message":[NSString stringWithFormat:@"异常错误码%ld",(long)status]}]];
           
            
        }
    }];

}

-(void)beginHmGame{
    
    
#if !TARGET_OS_SIMULATOR
    
    DDDQuickLoginInfoModelFFF * quickModel =  unlockModel.quick_info;
    DDDQuickOrderInfoModelFFF * orderInfo = unlockModel.order_info;
    if (quickModel == nil ){
        
        [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:401 userInfo:@{@"message":@"HMCloud 上号信息数据为空"}]];
        return;}
    if (orderInfo == nil ){
        
        [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:401 userInfo:@{@"message":@"HMCloud 上号订单信息数据为空"}]];
        return;}
    
    is_offline = [quickModel.offline_switch intValue] == 1;
    if (is_offline){
        
        timeOut = [quickModel.cloud_timeout intValue] * 60;
    }
    
    library_version = [quickModel.library_version intValue];
    
    cloud_plan = [quickModel.cloud_plan intValue];
    
    quick_type_sub = quickModel.quick_tyle_sub ;
    
    if (self.info.is_wx_server == NO){
        
        checkLoginStatus = [quickModel.cloud_plan intValue] == 1;
    }
    
    DDDLog([NSString stringWithFormat:@"订单 %@ | %@ | %@",is_offline ? @"到时不下线":@"",is_offline ? [NSString stringWithFormat:@"超时时间%d",timeOut]:@"",checkLoginStatus ? @"检测登录态":@""]);
    
    gamePackage = quickModel.game_info.package_android;
    NSInteger orientation = 0;
    NSString * userId = quickModel.cloud_uid;
    NSString * userToken = userId;
    NSString * accessKey = quickModel.cloud_access_key;
    NSString * accessKeyId = quickModel.cloud_bid;
    NSInteger playTimes = [orderInfo.zq intValue] * 3600 + timeOut;
    NSString * channelName = SW_HMCLoudChannelId;
    [DDDCloudPlayerWarpperFFF sharedWrapper].accessKeyId = accessKeyId;
    [DDDCloudPlayerWarpperFFF sharedWrapper].accessKey = accessKey;
    [[DDDCloudPlayerWarpperFFF sharedWrapper] regist:channelName];
    
    DDDLog([NSString stringWithFormat:@"accessKeyId:%@,channelId:%@,accessKey:%@",accessKeyId,channelName,accessKey]);
    
   NSString * cToken = [DDDUtilsFFF hmcloud_generateCToken:gamePackage withUserId:userId withUserToken:userToken withAccessKey:accessKey withAccessKeyId:accessKeyId withChannelId:channelName];
    NSMutableDictionary * gameOptions = @{ CloudGameOptionKeyId:gamePackage,//
                                    CloudGameOptionKeyUserId:userId,
                                    CloudGameOptionKeyArchive:@(0),
                                    CloudGameOptionKeyProtoData:@"",
                                    CloudGameOptionKeyConfigInfo:@"config",
                             CloudGameOptionKeyUserToken:userToken,
                           CloudGameOptionKeyOrientation:@(orientation), //
                                CloudGameOptionKeyCToken:cToken,//
                              CloudGameOptionKeyPriority:@(0),//
                           CloudGameOptionKeyPlayingTime:@(playTimes * 1000),//
//                                   CloudGameOptionKeyExtraId:quick_token,//
                            CloudGameOptionKeyAppChannel:channelName,//
                                    CloudGameOptionKeyStreamType:@(CloudCoreStreamingTypeRTC)//
                           
    }.mutableCopy;
    
    if (quickModel.quick_cloud.length > 0){
        
        gameOptions[@"CloudGameOptionKeyCid"] = quickModel.quick_cloud;
    }
    
    DDDLog([NSString stringWithFormat:@"HMCloud startSDK params : %@",[gameOptions yy_modelToJSONString]]);
    
    if (_currentViewController == nil){
        
        
        [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:103 userInfo:@{@"message":@"HMCloud currentViewController nil ."}]];
        return;}
    
    
    if (hmSDKRegisted != -1){
        
        DDDLog(@"hmSDK registed");
        
        [self prepare_HMCloudPageWith:_currentViewController withOptions:gameOptions];
    }else{
        
        WeakObj(self);
        hmSDKRegistBlock = ^{
            
            StrongObj(weakSelf);
            
            if(strongSelf->hmSDKRegisted == 1){
                
                DDDLog(@"hmSDK registed success");
                
                [strongSelf prepare_HMCloudPageWith:strongSelf.currentViewController withOptions:gameOptions];
            }else{
                
                DDDLog(@"hmSDK registed fail");
                [strongSelf.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:201 userInfo:@{@"message":@"HMCloud startSDK Registed Fail ."}]];
            }
        };
    }
#endif
}




#if !TARGET_OS_SIMULATOR

- (void)taskCancel{
    
    
}

-(void)prepare_HMCloudPageWith:(UIViewController *)currentVc
                   withOptions:(NSDictionary *)gameOptions{
    
    
    UIViewController * vc = [[DDDCloudPlayerWarpperFFF sharedWrapper] prepare:gameOptions];
    
    if (vc == nil){
        
        DDDLog(@"HMCloud startSDK Failed .");
        [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:201 userInfo:@{@"message":@"HMCloud startSDK Failed ."}]];
        return;
    }
    
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [currentVc presentViewController:vc  animated:YES completion:^{
        
        [self.delegate SWHMCloudGamePageDidPresent:vc];
        
        [self.loadingView hidden];
    }];
    
    cloudGameVC = vc ;
    
    [self motitorApp];
}

-(void)gameSuccessWith:(NSString *)cloudId{
    
    if(cloudId != nil){
        
        DDDLog([NSString stringWithFormat:@"HMCloud cloudId %@",cloudId]);
        
        [self setReportHMRent:@"{extraInfo={optype=0;state=videoVisible;};sceneId=playerState;}"];
        [self connectWebsocket];
        
        [self.delegate SWHMCloudGameLoginSuccess];
        
        if (cloudGameVC != nil){
            
            [self showSuspendView:cloudGameVC.view];
        }
    }else{
        
        DDDLog(@"HMCloud cloudId 为空");
        [self stopHmGameWith:1 withmsg:@"HMCloud cloudId 为空"];
    }
}
-(void)stopHmGameWith:(NSInteger)eventId
              withmsg:(NSString *)msg{
    
    [[DDDCloudPlayerWarpperFFF sharedWrapper] stopAndDismiss:YES];
    
    [self websocket_sendTask_cancel];
    
    [self closeWebsocket];
    
    [self stopMotiorApp];
    
    if(eventId == 0){
        
        [self.delegate SWHMCloudGameOrderEnd];
    }
    
    else if (eventId == 501){
        
        [self.delegate SWHMCloudGameOrderAutoTs];
    }
    
    else if (eventId == 101){
        
    }
    
    else if (eventId == 300){
        
        [self.delegate SWHMCloudGameCloseDidGame];
    }
    
    else{
        
        [self.delegate SWHMCloudGameLoginTaskError:[NSError errorWithDomain:DDDHMCloudErrorDomain code:eventId userInfo:@{@"message":msg}]];
    }
    
    
    
}
-(void)updatePlayTimeWith:(NSInteger)time{
    
    [[DDDCloudPlayerWarpperFFF sharedWrapper] updateTimes:time];
}

-(void)showSuspendView:(UIView *)WithSuperView{
    
    DDDHMCloudSuspendViewFFF * suspendView = [DDDHMCloudSuspendViewFFF suspendViewWith:WithSuperView];
    
    WeakObj(self);
    [suspendView setClickCallBack:^{
        
        [weakSelf showBackGameView:WithSuperView];
        
    }];
}
-(void)motitorApp{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
}
-(void)stopMotiorApp{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)appEnterBackground{
    
    [[DDDCloudPlayerWarpperFFF sharedWrapper] pause];
}
-(void)appEnterForeground{
    
    [[DDDCloudPlayerWarpperFFF sharedWrapper] resume:0];
}
-(void)showBackGameView:(UIView *)withSuperView{
    
    
    DDDHMCloudBackGameViewFFF * backView = [DDDHMCloudBackGameViewFFF backGameView];
    [backView setCloseGameBlock:^{
        
        [self userClose];
    }];
    
    [backView showWith:withSuperView];
}
-(void)websocket_sendTask_do{
    
    [self websocket_sendTask_cancel];
    
    WeakObj(self);
    timer_websocket = DDDTimer(10, ^{
        
        StrongObj(weakSelf);
        NSData * data = [strongSelf websocketMessage];
        
        if (data != nil){
            
            [strongSelf->order_websocket sendData:data error:nil];
        }
    });
    
    dispatch_resume(timer_websocket);
    
}
-(NSData * __nullable)websocketMessage{
    
    if (websocket_session_id == nil) {return nil;}
    
    NSString * timsstamp = [NSString stringWithFormat:@"%.0f",[[NSDate alloc] init].timeIntervalSince1970];
    
    NSString * websocketSignStr = [DDDOtherInfoWrapFFF shared].websocketSignStr;
    
    NSString * str = [NSString stringWithFormat:@"session_id=%@&timestamp=%@&appsecret=%@",websocket_session_id,timsstamp,websocketSignStr];
    NSString * sign = [str MD5Encrypt];
    
    NSDictionary * dic = @{@"action":@"order_progress",@"session_id":websocket_session_id,@"sign":sign,@"timestamp":timsstamp,@"uncode":self.info.unlock_code};
    
    NSString * json = [dic yy_modelToJSONString];
    
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}
//swift版 未调用
-(void)sendHmGamgeScreenPic{}
-(NSDictionary *)hmCloudMessageConfig:(NSInteger)withType{
    
    NSString * gameid = gamePackage;
    NSMutableDictionary * jsonDic = @{}.mutableCopy;
    jsonDic[@"type"] = @(withType);
    jsonDic[@"game"] = gameid;
    
    switch (withType) {
        case 101:
        {
            jsonDic[@"from"] = @"com.houmingxuan.bundleid.test";
            if ([gameid isEqualToString:@"com.tencent.jkchess"] || [gameid isEqualToString:@"com.tencent.lolm"] || library_version == 2) {
                
                jsonDic[@"db"] = @"itop_login.txt";
                jsonDic[@"table"] = @"";
                jsonDic[@"column"] = @"";
            }else{
                jsonDic[@"db"] = @"WEGAMEDB2";
                jsonDic[@"table"] = @"qq_login_info";
                jsonDic[@"column"] = @"open_id";
                
            }
        }
            break;
            
        default:
            break;
    }
    
    DDDLog([NSString stringWithFormat:@"HMCLoud Send Message %@",[jsonDic yy_modelToJSONString]]);
    
    return jsonDic;
}

-(void)setReportHMRent:(NSString *)withRemark{
    
    NSString * cloudId = [[DDDCloudPlayerWarpperFFF sharedWrapper] getCloudId];
    
    if (cloudId == nil || cloudId.length == 0){
        
        
        DDDWarning(@"HMCloud cloudId is nil");
        return;
    }
    
    NSString * cloud_json = [@{@"cid":cloudId,@"quick_type_sub":quick_type_sub} yy_modelToJSONString];
    NSData * cloud_data = [cloud_json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary * param = @{}.mutableCopy;
    param[@"order_id"] = unlockModel.order_info.orderid;
    param[@"status"] = @(1);
    DDDQuickTypeModelFFF * quick =  unlockModel.quick_info.quick_type.firstObject;
    if (quick != nil){
        
        param[@"source"] = quick.source;
    }else{
        param[@"source"] = unlockModel.default_source;
    }
    
    param[@"order_login"] = unlockModel.quick_info.order_login;
    param[@"quick_version"] = @(7);
    param[@"remark"] = [NSString stringWithFormat:@"%@ cid-%@ | %@",withRemark,cloudId,cloud_plan == 0 ? [NSString stringWithFormat:@"登录态云上号方案-%d",cloud_plan]:[NSString stringWithFormat:@"写库登录云上号 -%d",cloud_plan]];
    param[@"cloud_data"] = cloud_data;
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_HMCloud_ReportOrder withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        DDDLog([NSString stringWithFormat:@"cloudReportOrder result %@",model.message]);
    } withFailBlock:^(NSString * _Nonnull error) {
        
        DDDLog(@"cloudReportOrder error");
    }];
}

-(void)middilewareLoginWithMode:(NSInteger)mode
                     withOpenid:(NSString *)openId
                       withType:(NSInteger)type
                 WithFaceLogUrl:(NSString *)logUrl{
    NSMutableDictionary * param = @{}.mutableCopy;
    param[@"order_id"] = unlockModel.order_info.orderid;
    param[@"quick_version"] = @(7);
    DDDQuickTypeModelFFF * quick =  unlockModel.quick_info.quick_type.firstObject;
    if (quick != nil){
        
        param[@"source"] = quick.source;
    }else{
        param[@"source"] = unlockModel.default_source;
    }
    if (type == 3){
        
        param[@"type"] = @"3";
        param[@"mode"] = @(mode);
        param[@"openid"] = openId;
    }
    else if (type == 4){
        
        param[@"type"] = @"4";
        param[@"trigger_face"] = @"1";
        param[@"face_url"] = logUrl;
    }
    else if (type == 5){
        param[@"type"] = @"5";
        param[@"content"] = openId;
    }
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_HMCloud_middlewareLogin withPhp:YES];
    
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:DDDSWHMCloudMiddlewareLoginModelFFF.class withSuccessBlock:^(DDDModelBaseFFF <DDDSWHMCloudMiddlewareLoginModelFFF*>* _Nullable model) {
        
        if (model.data == nil){
            
            
            return;
        }
        
        if (model.data.auto_ts){
            
            DDDLog(@"HMCLoud 无登录态 自动撤单");
            [self stopHmGameWith:501 withmsg:@"HMCLoud 无登录态 自动撤单"];
        }
        
        
    } withFailBlock:^(NSString * _Nonnull error) {
        
        DDDLog(@"middilewareLogin error");
    }];
}
-(void)cloudOffLine:(NSInteger)ingame{
    
    NSMutableDictionary * param = @{}.mutableCopy;
    param[@"order_id"] = unlockModel.order_info.orderid;
    param[@"quick_version"] = @(7);
    param[@"in_game"] = @(ingame);
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF serviceWithParam:param withApi:SW_API_HMCloud_OffLine withPhp:YES];
    [[DDDHttpToolFFF defaultTool] httpTaskWithService:service withResponseDataClass:NSString.class withSuccessBlock:^(DDDModelBaseFFF * _Nullable model) {
        DDDLog([NSString stringWithFormat:@"SW_API_HMCloud_OffLine response %@",model.message]);
    } withFailBlock:^(NSString * _Nonnull error) {
        
        DDDLog(@"cloudOffLine error");
    }];
}
-(void)connectWebsocket{
    
    if(order_websocket != nil){
        
        [order_websocket close];
        order_websocket.delegate = nil;
        order_websocket = nil;
    }
    
    order_websocket = [[SRWebSocket alloc] initWithURL:DDD_webSocketUrl()];
    order_websocket.delegate = self;
    [order_websocket open];
}
-(void)closeWebsocket{
    
    [order_websocket close];
    order_websocket = nil;
}
-(void)userClose{
    
    [self stopHmGameWith:300 withmsg:@""];
}

-(void)websocket_sendTask_cancel{
    
    if(timer_websocket != nil){
        
        dispatch_source_cancel(timer_websocket);
        timer_websocket = nil;
    }
}



- (void)cloudPlayerReigsted:(BOOL)success{
    
    DDDLog([NSString stringWithFormat:@"HMCloud registed %@",success ? @"success":@"fail"]);
    
    hmSDKRegisted = success ? 1 : 2;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self->hmSDKRegistBlock();
    });
}

- (void)cloudPlayerResolutionList:(NSArray<HMCloudPlayerResolution *> *)resolutions{
    
    DDDLog(@"HMCloud ResolutionList");
}


- (void)cloudPlayerRecvMessage:(NSString *)msg{
    
    
    DDDLog([NSString stringWithFormat:@"HMCloud recvMessage%@",msg]);
    
    DDDSWHMCloudMessageModelFFF * messageModel = [DDDSWHMCloudMessageModelFFF yy_modelWithJSON:msg];
    NSInteger gameStatus = [messageModel.gameStatus intValue];
    
    if ( messageModel == nil ) {return;}
    
    if (is_offline){
        
        if([messageModel.type intValue] == 102){
            
            hmcloudStatus_InGame = gameStatus == 2;
            
            if (gameStatus == 1){
                
                DDDLog(@"海马游戏Status 游戏登陆成功");
            }
            if (gameStatus == 2){
                
                DDDLog(@"海马游戏Status 进入对局");
            }
            if (gameStatus == 3){
                
                DDDLog(@"海马游戏Status 对局结束");
            }
        }
    }
    
    
    if (checkLoginStatus){
        
        if([messageModel.type intValue] == 102 && gameStatus == 1){
            
            if (isReportLoginType == false){
                
                isReportLoginType = true;
                
                [self middilewareLoginWithMode:1 withOpenid:messageModel.desc withType:3 WithFaceLogUrl:nil];
            }
        }
        
        if([messageModel.type intValue] == 101){
            
            NSString * openid = messageModel.openId;
            
            if (messageModel.errorMsg.length > 0){
                
                openid = messageModel.errorMsg;
            }
            
            if (openid.length == 0){
                
                DDDError(@"HMCloud 获取登录Type openid 失败");
            }
            
            [self middilewareLoginWithMode:0 withOpenid:openid withType:3 WithFaceLogUrl:nil];
        }
    }
    
    if ([messageModel.type intValue] == 102){
        
        
        if ([msg containsString:@"check paytoken failed"]||[msg containsString:@"qq pay token expired"]){
            
            [self setReportHMRent:@"status: check paytoken failed or expired"];
        }
        
        if (gameStatus == 1 && [messageModel.desc containsString:@"登陆成功"]){
            
            [self setReportHMRent:@"status: 登陆成功"];
        }
    }
    
    if ([messageModel.type intValue] == 102){
        
        if(gameStatus == 4){
            
            NSString * faceLogUrl = messageModel.log;
            
            NSRange range = [faceLogUrl rangeOfString:@"openUrl:"];
            
            if (range.length > 0){
                
                faceLogUrl = [faceLogUrl substringFromIndex:range.location + range.length];
                
            }
            
            [self middilewareLoginWithMode:0 withOpenid:@"" withType:4 WithFaceLogUrl:faceLogUrl];
        }
    }
    
    NSString * cid = [[DDDCloudPlayerWarpperFFF sharedWrapper] getCloudId];
    
    if ([messageModel.type intValue] == 1000){
        
        if(messageModel.result != 1){
            
            NSMutableDictionary * msgData = @{}.mutableCopy;
            msgData[@"cid"] = cid;
            msgData[@"msg_type"] = @(1000);
            msgData[@"result"] = @(messageModel.result);
            msgData[@"msg"] = messageModel.msg;
            [self middilewareLoginWithMode:0 withOpenid:[msgData yy_modelToJSONString] withType:5 WithFaceLogUrl:nil];
        }
    }
    else if ([messageModel.type intValue] == 101){
        
        if (messageModel.msg.length > 0){
            
            if (messageModel.result != 1){
                
                
                NSMutableDictionary * msgData = @{}.mutableCopy;
                msgData[@"cid"] = cid;
                msgData[@"msg_type"] = @(101);
                msgData[@"result"] = @(messageModel.result);
                msgData[@"msg"] = messageModel.msg;
                [self middilewareLoginWithMode:0 withOpenid:[msgData yy_modelToJSONString] withType:5 WithFaceLogUrl:nil];
            }
        }else{
            
            if(messageModel.errorMsg.length > 0){
                
                NSMutableDictionary * msgData = @{}.mutableCopy;
                msgData[@"cid"] = cid;
                msgData[@"msg_type"] = @(101);
                msgData[@"result"] = @"";
                msgData[@"msg"] = messageModel.errorMsg;
                [self middilewareLoginWithMode:0 withOpenid:[msgData yy_modelToJSONString] withType:5 WithFaceLogUrl:nil];
            }
        }
    }
    else{
        
        if (messageModel.msg.length > 0){
            
            if (messageModel.result != 1){
                
                
                NSMutableDictionary * msgData = @{}.mutableCopy;
                msgData[@"cid"] = cid;
                msgData[@"msg_type"] = messageModel.type;
                msgData[@"result"] = @(messageModel.result);
                msgData[@"msg"] = messageModel.msg;
                [self middilewareLoginWithMode:0 withOpenid:[msgData yy_modelToJSONString] withType:5 WithFaceLogUrl:nil];
            }
        }else{
            
            if(messageModel.errorMsg.length > 0){
                
                NSMutableDictionary * msgData = @{}.mutableCopy;
                msgData[@"cid"] = cid;
                msgData[@"msg_type"] = messageModel.type;
                msgData[@"result"] = @"";
                msgData[@"msg"] = messageModel.errorMsg;
                [self middilewareLoginWithMode:0 withOpenid:[msgData yy_modelToJSONString] withType:5 WithFaceLogUrl:nil];
            }
        }
    }
}

-(void)cloudPlayerPrepared:(BOOL)success{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (success){
            
            [[DDDCloudPlayerWarpperFFF sharedWrapper] play];
        }else{
            
            [self stopHmGameWith:2 withmsg:@"Prepare fail"];
        }
    });
}

- (void)cloudPlayerStateChanged:(CloudPlayerState)state{
    
    switch (state) {
        case PlayerStateInstancePrepared:
            
            DDDLog(@"HMCloud Show Loading");
            break;
        case PlayerStateVideoVisible:
            DDDLog(@"HMCloud Remove Loading");
            [self gameSuccessWith:[[DDDCloudPlayerWarpperFFF sharedWrapper]getCloudId]];
            
            if (checkLoginStatus){
                
               NSString * msg = [[self hmCloudMessageConfig:101] yy_modelToJSONString];
                
                [[DDDCloudPlayerWarpperFFF sharedWrapper] sendMessage:msg];
            }
            break;
        case PlayerStateStopCanRetry:
            DDDLog(@"HMCloud Stoped");
            [self stopHmGameWith:3 withmsg:@"HMCloud Stoped"];
            break;
        case PlayerStateStop:
            DDDLog(@"HMCloud Stopped");
            [self stopHmGameWith:3 withmsg:@"MCloud Stopped"];
            break;
            
        case PlayerStateFailed:
            DDDLog(@"HMCloud Failed.");
            [self stopHmGameWith:3 withmsg:@"HMCloud Failed"];
            break;
        case PlayerStateTimeout:
            DDDLog(@"HMCloud Timeout");
            [self stopHmGameWith:3 withmsg:@"HMCloud Timeout"];
            break;
        case PlayerStateSToken:
            DDDLog(@"HMCloud Show Loading");
            break;
        default:
            break;
    }
}


- (void)cloudPlayerQueueStateChanged:(CloudPlayerQueueState)state{
    
    switch (state) {
        case PlayerQueueStateConfirm:
            
            [[DDDCloudPlayerWarpperFFF sharedWrapper] queueConfirm];
            break;
        case PlayerQueueStateUpdate:
            DDDLog(@"HMCloud Update");
            break;
        case PlayerQueueStateEntering:
            DDDLog(@"HMCloud entering");
            break;
        default:
            break;
    }
    
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessageWithString:(NSString *)string{
    
    DDDSWWebsocketMessageModelFFF * messageModel = [DDDSWWebsocketMessageModelFFF yy_modelWithJSON:string];
    
    DDDSWWebsocketWrapModelFFF * messageData = messageModel.data;
    
    if (messageModel.data == nil){
        
        DDDError(@"websocket 消息data 为空");
        return;
    }
    
    if ([messageModel.action  isEqualToString:@"link"]){
        
        websocket_session_id = messageData.session_id;
        
        [self websocket_sendTask_do];
    }
    if ([messageModel.action isEqualToString:@"order_progress"]){
        
        switch ([messageData.order_status intValue]) {
            case 2:
            case 0:
                
                DDDLog(@"订单结束或者是异常");
                
                if ([gamePackage isEqualToString:@"com.tencent.tmgp.sgame"] && is_offline == YES){
                    
                    
                    if(hmcloudStatus_InGame == NO){
                        
                        DDDLog(@"订单游戏结束");
                        
                        [self cloudOffLine:0];
                        [self stopHmGameWith:0 withmsg:@""];
                    }else{
                        
                        DDDLog(@"订单还在游戏中");
                        
                        [self cloudOffLine:1];
                        
                        if(timeOffLineTrigger == NO){
                            
                            timeOffLineTrigger = YES;
                            
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeOut * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                
                                DDDLog(@"到时不下线任务响应");
                                
                                [self stopHmGameWith:0 withmsg:@""];
                            });
                        }
                    }
                }else{
                    
                    DDDLog(@"订单游戏结束-不是王者或者是未开启到时不下线");
                    
                    [self stopHmGameWith:0 withmsg:@""];
                }
                break;
                
            default:
                break;
        }
    }
}

#endif

@end



NSURL * DDD_webSocketUrl(void){
    
    NSString * version = [DDDUtilsFFF getAppVersion];
    NSString * versioncode = [version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * appid = [DDDOtherInfoWrapFFF shared].appId;
    NSString * url = @"";
    switch ([DDDHttpToolFFF defaultTool].api_env) {
        case MJHttpServerEnv_test:
            
            url = [NSString stringWithFormat:@"ws://39.98.193.35:9505?app_id=%@&app_version_name=%@&app_version_code=%@",appid,version,versioncode];
            break;
            
        default:
            url = [NSString stringWithFormat:@"wss://heartbeat.zuhaowan.com?app_id=%@&app_version_name=%@&app_version_code=%@",appid,version,versioncode];
            break;
    }
    
    return [NSURL URLWithString:url];
}
