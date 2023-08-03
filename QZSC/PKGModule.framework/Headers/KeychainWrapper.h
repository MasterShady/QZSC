//
//  KeychainWrapper.h
//  PKGModule
//
//  Created by 刘思源 on 2023/7/27.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

@property (nonatomic, copy, readonly) NSString *service;

- (instancetype)initWithService:(NSString *)service;
- (void)setObject:(id)object forKeyedSubscript:(NSString *)key;
- (id)objectForKeyedSubscript:(NSString *)key;

@end

