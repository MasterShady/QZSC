//
//  DDDFaceCheckFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDFaceCheckModelFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDFaceCheckFFF : NSObject

@property(nonatomic,strong)DDDFaceCheckModelFFF * faceModel;

//人脸检测老流程
- (void)oldLogDoOldInterfaceCheck;

//人脸检测新流程
- (void)skeyGetSessionId;

//人脸检测成功 -- 0旧流程 1新流程
@property (nonatomic, copy) void (^faceCheckSucess)(NSInteger type);

//人脸检测失败 --- 提示信息
@property (nonatomic, copy) void (^faceCheckFail) (NSString *msg);

//人脸检测 -- 刷新订单
@property (nonatomic, copy) void (^reloadTip) (NSString *msg);
@end

NS_ASSUME_NONNULL_END
