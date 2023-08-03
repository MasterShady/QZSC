//
//  DDDWxLoginFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDWxLoginBaseFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import "DDDWxLoginSimulatorFFF.h"
#import "DDDWxLoginIpadLocalFFF.h"
#import "DDDWxLoginIpadServerFFF.h"
#import "DDDCriptsFFF.h"
@implementation DDDWxLoginBaseFFF


-(NSString *)wx_package_openScheme{
    
    return self.info.game_package_name_ios;
}



- (NSString *)tokenDecrypt:(NSString *)withToken{
    
    return [DDDZSRc4FFF swRc4DecryptWithSource:withToken rc4Key:game_auth_key];
}


+(instancetype)wechatLoginWith:(DDDQuickLoginInfoModelFFF *)infoModel{
    
    if (infoModel == nil){
        
        return [[DDDWxLoginSimulatorFFF alloc] init];
    }else{
        
        if([infoModel.open_mode isEqualToString:@"1"]){
            
            DDDWxLoginIpadServerFFF * server = [[DDDWxLoginIpadServerFFF alloc] init];
            
            server.quickModel = infoModel;
            
            return server;
        }else{
            
            DDDWxLoginIpadLocalFFF * local = [[DDDWxLoginIpadLocalFFF alloc] init];
            
            local.quickModel = infoModel;
            
            return local;
        }
    }
}
@end
