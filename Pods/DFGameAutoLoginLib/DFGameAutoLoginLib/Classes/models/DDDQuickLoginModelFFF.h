//
//  QuickLoginModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/25.
//

#import <Foundation/Foundation.h>

#import "DDDQuickOrderInfoModelFFF.h"

#import "DDDQuickLoginInfoModelFFF.h"

#import "DDDQuickFaceModelFFF.h"

NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickLoginModelFFF : NSObject


/**
 qq
 */
@property (nonatomic, copy)NSString * qq;

/**
 type
 */
@property (nonatomic, copy) NSString *type;


/**
 来源 默认 => 999
 */
@property (nonatomic, copy) NSString *default_source;


@property (nonatomic, strong) DDDQuickOrderInfoModelFFF *order_info;

@property (nonatomic, strong) DDDQuickFaceModelFFF *face_verify_switch;

@property (nonatomic, strong) DDDQuickLoginInfoModelFFF *quick_info;




@end

NS_ASSUME_NONNULL_END
