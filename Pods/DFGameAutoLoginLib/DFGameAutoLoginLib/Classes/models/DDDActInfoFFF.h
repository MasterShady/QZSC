//
//  DDDActInfoFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DDDActInfoFFF : NSObject

@property(nonatomic,copy) NSString * yx;

@property(nonatomic,copy) NSString * Id;

@property(nonatomic) BOOL is_wx_server;

@property(nonatomic) NSInteger wx_type;

@property(nonatomic,copy) NSString * game_package_name_ios;

@property(nonatomic,copy) NSString * game_package_name_ios_wx;

@property(nonatomic,copy) NSString * unlock_code;


@property(nonatomic,copy) NSString * game_id;

@property(nonatomic) BOOL is_cloudGame;

@property(nonatomic,copy) NSString * order_id;

@property(nonatomic,strong) NSArray<NSString *> * wx_loadingStrings;

@end

NS_ASSUME_NONNULL_END
