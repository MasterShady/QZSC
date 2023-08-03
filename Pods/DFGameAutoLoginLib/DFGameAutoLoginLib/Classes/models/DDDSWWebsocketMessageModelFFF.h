//
//  SWWebsocketMessageModel.h
//  ThirdLogin
//
//  Created by ch on 2022/6/16.
//

#import <Foundation/Foundation.h>
#import "DDDSWWebsocketWrapModelFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDSWWebsocketMessageModelFFF : NSObject

@property (nonatomic, copy) NSString *action;

@property (nonatomic, copy) NSString *status;

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) DDDSWWebsocketWrapModelFFF *data;

@end

NS_ASSUME_NONNULL_END
