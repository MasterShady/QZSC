//
//  QuickLoginWxipadModel.h
//  ThirdLogin
//
//  Created by ch on 2023/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickLoginWxipadModelFFF : NSObject

@property (nonatomic, copy) NSString *queueId; //业务跟踪id

@property (nonatomic, copy) NSString *openMode; //开通模式【1->服务端发包；2->客户端发包】

@end

NS_ASSUME_NONNULL_END
