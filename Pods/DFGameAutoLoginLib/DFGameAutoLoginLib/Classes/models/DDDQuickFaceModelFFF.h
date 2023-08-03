//
//  QuickFaceModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickFaceModelFFF : NSObject

/** switch1 => switch */
@property (nonatomic,strong) NSNumber *switch1;

/** switch2 */
@property (nonatomic,strong) NSNumber *switch2;

/** quick_token */
@property (nonatomic,copy) NSString *quick_token;

/** url */
@property (nonatomic,copy) NSString *url;

/** hopetoken */
@property (nonatomic,copy) NSString *hopetoken;

/** chk_id */
@property (nonatomic,strong) NSNumber *chk_id;


@end

NS_ASSUME_NONNULL_END
