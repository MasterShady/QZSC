//
//  DDDQQLoginTokenServerFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDQuickLoginModelFFF.h"
#import "DDDQuickTypeModelFFF.h"
#import "DDDLoginGameLoadingViewProtocolFFF.h"
NS_ASSUME_NONNULL_BEGIN

@interface DDDQQLoginTokenServerFFF : NSObject


@property (nonatomic, strong) DDDQuickLoginModelFFF *param;

@property (nonatomic, strong) DDDQuickTypeModelFFF *quickModel;

@property (nonatomic, copy) NSString *game_id;

@property (nonatomic ,weak)id<DDDLoginGameLoadingViewProtocolFFF> current_loading;
/**
数据处理回调
 */
@property (nonatomic, copy) void (^eventBlock) (NSInteger code, NSString *msg);

/**
 任务开始
 */
- (void)toTaskWithLoading:(id<DDDLoginGameLoadingViewProtocolFFF>)loading;

- (void)defaultTokenLoginGame:(NSString *)quick_token isreport:(BOOL)isreport;

-(void)cancel;


@end

NS_ASSUME_NONNULL_END
