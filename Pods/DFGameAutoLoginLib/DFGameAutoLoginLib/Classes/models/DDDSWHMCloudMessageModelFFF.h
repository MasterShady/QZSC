//
//  SWHMCloudMessageModel.h
//  ThirdLogin
//
//  Created by ch on 2022/6/16.
//

#import <Foundation/Foundation.h>



@interface DDDSWHMCloudMessageModelFFF : NSObject

@property (nonatomic, strong) NSNumber *type;

@property (nonatomic, strong) NSNumber *gameStatus;//1 游戏登录成功 2 开始对局 3 对局结束

@property (nonatomic, copy) NSString *openId;

@property (nonatomic, copy) NSString *log;

@property (nonatomic, copy) NSString *desc;

@property (nonatomic, copy) NSString *errorMsg;

@property (nonatomic) NSInteger result;
@property (nonatomic, copy) NSString *msg;
@end


