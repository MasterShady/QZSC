//
//  QuickTypeModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickTypeModelFFF : NSObject

/** name
 
 快速上号方式
 84 => 8.4上号方式
 qrcode => 扫码方式(暂无)
 server => 服务端v2.0方式(默认token上号)
 weblogin => web登录
 */
@property (nonatomic,copy) NSString *name; //判断上号方式


/** source */
@property (nonatomic,copy) NSString *source; //上报token或者错误的时候带上


/** quick_desc */
@property (nonatomic,copy) NSString *quick_desc;//描述, 没用


/** weight */
@property (nonatomic,copy) NSString *weight; // 排序, 也没用, 我排好了


/** off_rent */
@property (nonatomic,strong) NSArray <NSString *>*off_rent; //这个是会自动投诉的条件, 碰见这种上报错误, 我就直接投诉掉了

/** retry */
@property (nonatomic,strong) NSArray <NSString *>*retry; //这个是重试条件,碰见就重试

/** retry_times */
@property (nonatomic,strong) NSNumber *retry_times; //这是重试次数


@end

NS_ASSUME_NONNULL_END
