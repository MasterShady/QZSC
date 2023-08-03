//
//  DFFaceVerifyManager.m
//  zuhaowan
//
//  Created by mac on 2021/9/15.
//  Copyright © 2021 chenhui. All rights reserved.
//

#import "DFFaceVerifyManager.h"
#import "NTESToastView.h"

#import <TencentCloudHuiyanSDKFace/WBFaceVerifyCustomerService.h>
#import "NTESApproveMsgController.h"



static DFFaceVerifyManager * manager;


@interface DFFaceVerifyManager()<WBFaceVerifyCustomerServiceDelegate>
{
    BOOL sdkInit;
}
@property(nonatomic,strong,readwrite)DFFaceVerifyItem * currentItem;

@end

@implementation DFFaceVerifyManager

-(void)wbfaceVerifyCustomerServiceDidFinishedWithFaceVerifyResult:(WBFaceVerifyResult *)faceVerifyResult{
    
    [self closeAllPage];
    
    
    if (faceVerifyResult.isSuccess) {
        
        
        
        NSString * faceId = _currentItem.txInfo[@"faceId"];

        [self.delegate DFFaceVerifySuccessWithMsg:faceId];
        
        self.currentItem = nil;
        
        self.delegate = nil;
    }else{
        
        if ([self.delegate respondsToSelector:@selector(DFFaceVerifyErrorWith:)]) {
            
            [self.delegate DFFaceVerifyErrorWith:faceVerifyResult.error.desc];
        }
    }
    
   
    
}

-(void)wbfaceVerifyCustomerServiceWillUploadBestImage:(UIImage *)bestImage{
    
    
}

+(instancetype)shareManager{
    
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[DFFaceVerifyManager alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(faceSuccessno:) name:@"DF_NOTIFICATION_PUBLIC_FACE_SUCCESS" object:nil];
        
    });
    
    return  manager;
}



-(void)verifyTaskWith:(DFFaceVerifyItem *)item withTarget:(id<DFFaceVerifyProtocol>)delegate{
    
    self.delegate = delegate;
    
    _currentItem = item;
    
    [self openProtocolPage];
    
    
    
   
}


-(void)openProtocolPage{
    
    NTESApproveMsgController * beginPage = [[NTESApproveMsgController alloc] init];
    
    beginPage.protocolLinkTxt = _channel == 2 ? @"《腾讯人脸核身隐私政策》":@"《网易易盾隐私政策》";
    beginPage.protocolLinkUrl = _channel == 2 ? @"https://cloud.tencent.com/document/product/1007/66043":@"https://dun.163.com/clause/privacy";
    
    __weak NTESApproveMsgController * weakPage = beginPage;
    
    beginPage.nextBlock = ^{
        
        [self toDetail:weakPage];
        
    };
    [self push:beginPage];
}

-(void)toDetail:(UIViewController*)beginPage {
    
    if (self.channel == 2){
       
        [WBFaceVerifyCustomerService sharedInstance].delegate = self;
        
        WBFaceVerifySDKConfig *config = [WBFaceVerifySDKConfig sdkConfig];
        
        config.customTipsInUpload = @"";
        config.customTipsInDetect = @"";
        config.bottomCustomTips = @"";
        
        DFFaceVerifyItem * item = _currentItem ;
        
        
        NSString * userid = item.txInfo[@"userId"];
        NSString * nonce = item.txInfo[@"nonce"];
        NSString * sign = item.txInfo[@"sign"];
        NSString * appid = item.txInfo[@"appId"];
        NSString * orderId = item.txInfo[@"orderId"];
        NSString * version = item.txInfo[@"version"];
        NSString * keyLicence = _txLisence;
        NSString * faceId = item.txInfo[@"faceId"];
        [[WBFaceVerifyCustomerService sharedInstance] initSDKWithUserId:userid nonce:nonce sign:sign appid:appid orderNo:orderId apiVersion:version licence:keyLicence faceId:faceId sdkConfig:config success:^{
            
            [[WBFaceVerifyCustomerService sharedInstance] startWbFaceVeirifySdk];
            
        } failure:^(WBFaceError * _Nonnull error) {
           
            [NTESToastView showNotice:error.desc];
        }];
        
        
    }else if (self.channel == 1){
        
        //打开页面
        
        UIViewController * vc = [[NSClassFromString(@"NTESLDMainViewController") alloc] init];
        
        [beginPage.navigationController pushViewController:vc  animated: YES];
        
    }else{
        
        [NTESToastView showNotice:@"暂不支持此种认证方式"];
    }
}

-(void)push:(UIViewController*)page{
    
    if (self.delegate.viewController == nil && ![self.delegate isKindOfClass:[UIViewController class]]) {
        
        
        NSLog(@"无法打开页面");
        return;
        
        
    }
    
    if ([self.delegate.viewController isKindOfClass:[UINavigationController class]]) {
        
        [(UINavigationController *)self.delegate.viewController pushViewController:page animated:true];
    }else{
        
        UINavigationController * nv = [[UINavigationController alloc] initWithRootViewController:page];
        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
        
        if (self.delegate.viewController != nil) {
            
            [self.delegate.viewController presentViewController:nv animated:true completion:nil];
            
        }else{
            
            [(UIViewController *)self.delegate presentViewController:nv animated:true completion:nil];
        }
        
        
    }
    
}

-(void)closeAllPage{
    
    if (self.delegate.viewController == nil) {
        
        
        [((UIViewController *)self.delegate ).presentedViewController dismissViewControllerAnimated:true completion:nil];
        return;
    }
    
    if ([self.delegate.viewController isKindOfClass:[UINavigationController class]]) {
       
       NSArray * array = [(UINavigationController *)self.delegate.viewController viewControllers];
        __block NSUInteger index = 0;
        
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([obj isKindOfClass:NSClassFromString(@"NTESApproveMsgController")]) {
                
                index = idx;
                
                *stop = YES;
            }
        }];
       
        [(UINavigationController *)self.delegate.viewController popToViewController: array[index - 1] animated:true];
        
       
    }else{
        
        [self.delegate.viewController.presentedViewController dismissViewControllerAnimated: true completion:nil];
    }
}


-(void)faceSuccessno:(NSNotification*)no{
    
    NSDictionary * dic = no.userInfo;
    
    NSString * token = dic[@"token"];
    
    DFFaceVerifyItem * item   = dic[@"item"];
    
    if (item != _currentItem) {
        
        return;
        
    }
    
    [self.delegate DFFaceVerifySuccessWithMsg:token];
    
    [self closeAllPage];
     
    self.currentItem = nil;
    
    self.delegate = nil;
}



@end


@implementation DFFaceVerifyItem




@end
