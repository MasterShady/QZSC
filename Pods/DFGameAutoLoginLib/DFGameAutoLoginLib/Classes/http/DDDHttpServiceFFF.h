//
//  DDDHttpServiceFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDHttpServiceFFF : NSObject

@property(nonatomic,strong)NSDictionary * param;

@property(nonatomic,copy)NSString * api;

@property(nonatomic)NSInteger httpmethod;

@property NSInteger apiType;

+(instancetype)serviceWithParam:(NSDictionary *)dic
                           withApi:(NSString *)api
                            withPhp:(BOOL)isphp;


@end

NS_ASSUME_NONNULL_END
