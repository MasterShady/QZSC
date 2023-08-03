//
//  ClassLoader.h
//  PKGModule
//
//  Created by 刘思源 on 2023/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassLoader : NSObject

+ (NSArray<Class> *)classesConformingToProtocol:(Protocol *)protocol;

@end

NS_ASSUME_NONNULL_END
