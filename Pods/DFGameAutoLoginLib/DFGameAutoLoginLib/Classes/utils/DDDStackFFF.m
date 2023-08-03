//
//  DDDStackFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import "DDDStackFFF.h"

@interface DDDStackFFF ()
@property(nonatomic,strong)NSMutableArray* array;
@end

@implementation DDDStackFFF


-(instancetype)initWith:(NSArray *)datas{
    
    self = [super init];
    
    if (self){
        
        self.array = datas.mutableCopy;
    }
    return  self;
}

-(id)current {
    
    return  _array.firstObject;
}


-(void)pop{
    
    if (_array.count == 0){ return;}
    
    [_array removeObjectAtIndex:0];
}
@end
