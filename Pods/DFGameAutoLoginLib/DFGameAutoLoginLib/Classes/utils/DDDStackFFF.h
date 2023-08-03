//
//  DDDStackFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDStackFFF : NSObject

-(instancetype)initWith:(NSArray*)datas;

-(id)current;

-(void)pop;

@end

NS_ASSUME_NONNULL_END
