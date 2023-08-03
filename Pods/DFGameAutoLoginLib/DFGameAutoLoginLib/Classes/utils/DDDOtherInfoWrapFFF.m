//
//  DDDOtherInfoWrapFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDOtherInfoWrapFFF.h"

@implementation DDDOtherInfoWrapFFF

+(instancetype)shared{
    
    static dispatch_once_t onceToken;
    
    static DDDOtherInfoWrapFFF * obj;
    
    dispatch_once(&onceToken, ^{
        
        obj = [[DDDOtherInfoWrapFFF alloc] init];
        [obj defaultData];
    });
    
    return obj;
}

-(void)defaultData{
    
    _appId = @"500100000";
    _httpSignStr = @"m*hTXWMD^^hS&H6x";
    _websocketSignStr = @"N9Mw0vPIXZP5@hba";
    _loglevel = DDDLogLevelNone;
    
}
@end
