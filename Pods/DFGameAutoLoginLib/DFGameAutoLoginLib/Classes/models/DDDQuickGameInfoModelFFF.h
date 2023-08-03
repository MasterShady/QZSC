//
//  QuickGameInfoModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/27.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickGameInfoModelFFF : NSObject

/** gid */
@property (nonatomic,copy) NSString *gid;

/** gname */
@property (nonatomic,copy) NSString *gname;


/** package_android */
@property (nonatomic,copy) NSString *package_android;


/** appid_android_qq */
@property (nonatomic,copy) NSString *appid_android_qq;


/** package_ios_qq */
@property (nonatomic,copy) NSString *package_ios_qq;


/** sign_android */
@property (nonatomic,copy) NSString *sign_android;

/** status */
@property (nonatomic,copy) NSString *status;

@end

NS_ASSUME_NONNULL_END
