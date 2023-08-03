//
//  DDDModelBaseFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDModelBaseFFF<T> : NSObject


@property(nonatomic) NSInteger status;
@property(nonatomic,copy) NSString * message;
@property(nonatomic) NSInteger code;
@property(nonatomic,copy) NSString * msg;
@property(nonatomic,strong)T  data;

+(instancetype)modelWithDataClass:(Class)classType
                         withjson:(id) json;


@end




NS_ASSUME_NONNULL_END
