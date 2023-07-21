//
//  NetWorkCommonObject.h
//  DFSQ
//
//  Created by zhouc on 2023/4/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

enum NetWorkState: NSInteger {
    NetWork_Success,
    NetWork_Faliure
};

@interface NetWorkCommonObject : NSObject

@property(nonatomic, assign) enum NetWorkState state;
@property(nonatomic, copy) NSString *msg;
@property(nonatomic, strong) id data;

@end

NS_ASSUME_NONNULL_END
