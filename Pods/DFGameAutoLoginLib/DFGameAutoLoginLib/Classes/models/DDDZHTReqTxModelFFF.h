//
//  DDDZHTReqTxModelFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDZHTReqTxModelFFF : NSObject

@property (nonatomic,copy) NSString *reqTxData;

@property (nonatomic,copy) NSString *handleStatusMsg;

@property (nonatomic,copy) NSString *authCode;

@property (nonatomic) NSInteger handleStatus;
@end

NS_ASSUME_NONNULL_END
