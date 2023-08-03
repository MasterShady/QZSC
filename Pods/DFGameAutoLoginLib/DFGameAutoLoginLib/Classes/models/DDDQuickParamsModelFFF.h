//
//  QuickParamsModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/27.
//  前端传过来的参数封装成model

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 暴露组件的方法给前端
 获取上号需要的信息
 options ==> @{
 
    @"token":@"用户token",
    @"uncode":@"解锁码",
    @"host":@"业务域名",
 //一下取订单详情的数据
    @"yx":@"yx",
    @"Id":@"id", //订单id
    @"is_wx_server":@"is_wx_server",
    @"game_package_name_ios":@"game_package_name_ios", //启动游戏用的urlscrem
    @"game_package_name_ios_wx":@"game_package_name_ios_wx",
    @"unlock_code":@"unlock_code", //解锁码
    @"game_id":@"game_id",
    @"is_cloudGame":@"is_cloudGame",
    @"channel":@"", //上号方渠道  app / shanghaoqi
    @"appid":@"",
    @"sign_key":@"签名秘钥",
    @"versionCode":"版本号",
    @"versionName":@"版本名称",
    @"wss":@"websocket连接",
    @"web_sign":@"web签名秘钥", //海马云使用 -- 根据appid不一样
    
 }
 */



@interface DDDQuickParamsModelFFF : NSObject


@property (nonatomic, copy) NSString *token; //登录token

@property (nonatomic, copy) NSString *uncode; //解锁码

@property (nonatomic, copy) NSString *host; //请求业务域名

@property (nonatomic, copy) NSString *yx;

@property (nonatomic, copy) NSString *Id; //订单id

@property (nonatomic, strong) NSNumber *is_wx_server;

//新增参数
@property (nonatomic, copy) NSString *quick_type; //判断是新的ipad上号还是老的模拟器上号

@property (nonatomic, copy) NSString *game_package_name_ios;

@property (nonatomic, copy) NSString *game_package_name_ios_wx;

@property (nonatomic, copy) NSString *game_id;

@property (nonatomic, strong) NSNumber *is_cloudGame; //是否是云游戏


@property (nonatomic, copy) NSString *channel; //上号渠道

@property (nonatomic, copy) NSString *appid;

@property (nonatomic, copy) NSString *versionName;

@property (nonatomic, copy) NSString *versionCode;

@property (nonatomic, strong) NSNumber *isRelease;

@property (nonatomic, copy) NSString *web_sign;

@property (nonatomic, copy) NSString *sign_key;

@property (nonatomic, copy) NSString *wss; // socket连接

@property (nonatomic, copy) NSString *mid_host;//中台服务host

@property (nonatomic, copy) NSString *smid;// 数美id

@end

NS_ASSUME_NONNULL_END
