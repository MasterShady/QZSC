//
//  DDDAutoLoginPlatformBaseFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDAutoLoginPlatformBaseFFF.h"
#import "DDDUtilsFFF.h"
@implementation DDDAutoLoginPlatformBaseFFF



- (void)loginWithInfo:(nonnull DDDActInfoFFF *)info {
     
    self.info = info;
    
    
}

-(void)openAppWithUrl:(NSString*)url
          withHandler:(void(^)(BOOL))handler{
    
   NSURL * openurl = [NSURL URLWithString:url];
    
    if (openurl == nil){
        
        DDDToast(@"拉起游戏APP的链接无效");
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if([[UIApplication sharedApplication] canOpenURL:openurl] == false){
        
            DDDToast(@"您的设备可能未安装游戏App,如已安装请忽略此次提醒");
        }
        
        handler != nil ? handler(YES) : nil;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [[UIApplication sharedApplication] openURL:openurl options:@{} completionHandler:nil];
        });
        
    });
    
    
}

- (void)taskCancel {
    
}



@end
