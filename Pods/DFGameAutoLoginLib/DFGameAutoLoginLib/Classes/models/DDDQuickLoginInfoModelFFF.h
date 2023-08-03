//
//  QuickLoginInfoModel.h
//  ThirdLogin
//
//  Created by ch on 2022/5/27.
//

#import <Foundation/Foundation.h>

#import "DDDQuickGameInfoModelFFF.h"

#import "DDDQuickTypeModelFFF.h"


NS_ASSUME_NONNULL_BEGIN

@interface DDDQuickLoginInfoModelFFF : NSObject

/** repair_switch */
@property (nonatomic,strong) NSNumber *repair_switch;

/** is_wx_server */
@property (nonatomic,strong) NSNumber *is_wx_server;

/** game_mm */
@property (nonatomic,copy) NSString *game_mm;

/** game_auth */
@property (nonatomic,copy) NSString *game_auth;

/**game_auth_88*/
@property (nonatomic, copy) NSString *game_auth_88;

/** quick_token */
@property (nonatomic,copy) NSString *quick_token;

/** rent_auth_address */
@property (nonatomic,copy) NSString *rent_auth_address;

/** rent_auth_port */
@property (nonatomic,copy) NSString *rent_auth_port;

/** rent_auth_ports */
@property (nonatomic,copy) NSString *rent_auth_ports;

/** quick_identity */
@property (nonatomic,copy) NSString *quick_identity;

/** total_times */
@property (nonatomic,strong) NSNumber *total_times;

/** try_times */
@property (nonatomic,strong) NSNumber *try_times;

/** usable_times */
@property (nonatomic,strong) NSNumber *usable_times;

/** order_login */
@property (nonatomic,copy) NSString *order_login;

/** quick_device */
@property (nonatomic,copy) NSString *quick_device;


/** default_source */
@property (nonatomic,copy) NSString *default_source;


/** last_source */
@property (nonatomic,copy) NSString *last_source;

@property (nonatomic,copy)NSNumber * library_version;
/** hid */
@property (nonatomic,copy) NSString *hid;

@property (nonatomic, copy) NSString *game_auth_address; //连接地址

@property (nonatomic, copy) NSString *game_auth_port;// 连接端口


@property (nonatomic, strong) DDDQuickGameInfoModelFFF *game_info;


/** quick_type */
@property (nonatomic,strong) NSArray <DDDQuickTypeModelFFF *>*quick_type;

/**
 一下是海马云游戏参数
 */

@property (nonatomic, copy) NSString *quick_cloud;

@property (nonatomic, strong) NSNumber *haima_cloud; // 海马云开关 0关闭 1-uid 2-中间件

@property (nonatomic, strong) NSNumber *offline_switch; //到时不下线开关 0：关闭  1：开启

@property (nonatomic, strong) NSNumber *cloud_login; // 云游戏登录状态 0：关闭 1：开启

@property (nonatomic, copy) NSString *cloud_bid; //云游戏BID配置

@property (nonatomic, copy) NSString *cloud_access_key; // 云游戏accesskey

@property (nonatomic, strong) NSNumber *cloud_timeout;

@property (nonatomic, copy) NSString *cloud_uid;

@property (nonatomic, strong) NSNumber *cloud_plan;

@property (nonatomic ,copy)NSString * quick_tyle_sub;


//微信ipad上号新增参数
@property (nonatomic, copy) NSString *open_mode; //开通模式【1->服务端发包；2->客户端发包】

@property (nonatomic, copy) NSString *credential; //sdk使用和中台交互 -- 中台服务请求放入header

@property (nonatomic, copy) NSString *pt;//平台, sdk使用和中台交互

@property (nonatomic, copy) NSString *biz_id;//传输给sdk的业务id

@property (nonatomic, copy) NSString *biz_data;//传输给sdk使用的数据, json格式

@property (nonatomic, copy) NSString *biz_type;//传输给sdk的业务平台标识

@property (nonatomic, copy) NSString *queue_id;//上号队列id, 上报时使用

@end

NS_ASSUME_NONNULL_END
