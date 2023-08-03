//
//  SWWebsocketWrapModel.h
//  ThirdLogin
//
//  Created by ch on 2022/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDSWWebsocketWrapModelFFF : NSObject

@property (nonatomic, strong) NSNumber *order_status; //1 正常 0异常 2结束

@property (nonatomic, copy) NSString *session_id;

@end

NS_ASSUME_NONNULL_END
