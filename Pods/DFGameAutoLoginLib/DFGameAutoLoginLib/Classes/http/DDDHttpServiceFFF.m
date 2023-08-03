//
//  DDDHttpServiceFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDHttpServiceFFF.h"

@implementation DDDHttpServiceFFF


+(instancetype)serviceWithParam:(NSDictionary *)dic
                           withApi:(NSString *)api
                            withPhp:(BOOL)isphp{
    
    
    DDDHttpServiceFFF * service = [DDDHttpServiceFFF new];
    
    service.param = dic;
    service.api = api;
    service.apiType = isphp ? 0:1;
    service.httpmethod = 1;
    return service;
}
@end
