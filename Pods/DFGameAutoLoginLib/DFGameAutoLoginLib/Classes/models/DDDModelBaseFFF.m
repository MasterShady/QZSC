//
//  DDDModelBaseFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDModelBaseFFF.h"
#import "NSObject+YYModel.h"
@implementation DDDModelBaseFFF




+(instancetype)modelWithDataClass:(Class)classType
                         withjson:(id) json{
    
    DDDModelBaseFFF * model = [DDDModelBaseFFF yy_modelWithJSON:json];

    model.data = [classType yy_modelWithJSON: model.data];
    
    return  model;
    
}
@end


