//
//  DDDQQLoginToken8xFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDQuickLoginModelFFF.h"
#import "DDDQuickTypeModelFFF.h"

#import "DDDLogFFF.h"
#import "DDDUtilsFFF.h"
#import "DDDAlertViewFFF.h"
#import "DDDAlertHKMideViewFFF.h"
#import "DDDConstFFF.h"
#import "DDDOtherInfoWrapFFF.h"
#import "DDDHttpToolFFF.h"
#import "DDDCriptsFFF.h"


#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import <YYModel/YYModel.h>




NS_ASSUME_NONNULL_BEGIN



typedef enum : NSUInteger {
    DDD8XSocketEventTypeNONE,
    DDD8XSocketEventTypeHANDSHAKE,
    DDD8XSocketEventTypeSENDDATA,
    DDD8XSocketEventTypeEnd
} DDD8XSocketEventType;



@protocol DDD8xSocketProtocol <NSObject>

-(void)lg8xxtokenGetSuccessWithTokenInfo:(NSString*)info;

-(void)lg8xxSendDataToQQWithhost:(NSString *)host
                        withPort:(NSInteger)port
                        withData:(NSData *)data
                        withCall:(void(^)(NSString *))callback;

-(void)lg8xxErrorwith:(NSInteger)code
                   withMessage:(NSString *)message;

-(void)reload:(NSString *)withMsg;

-(void)uploadError:(NSString *)withMsg;

-(void)lg8xx_plistInfoGetSuccess:(NSDictionary *)withplist;

-(void)lg8xxSliderVerifyWithUrl:(NSString *)url
                       withCall:(void(^)(NSString *))call;
@end

@interface DDDQQLoginToken8xFFF : NSObject

@property(nonatomic,copy)NSString * game_id;

@property(nonatomic,strong)DDDQuickLoginModelFFF * param;

@property(nonatomic,strong)DDDQuickTypeModelFFF * quickModel;

@property(nonatomic,copy)void(^eventblock)(NSInteger,id );

-(void)queryToken;
@end



@interface DDDQQSocket : NSObject<GCDAsyncSocketDelegate>

-(instancetype)initWithIp:(NSString *)ip
                 withPort:(NSInteger)port;

-(void)sendDataWith:(NSData *)data
       withCallBack:(void(^)(NSString *))callback;

-(void)endTask;
@property(nonatomic,copy)NSString * ip;
@property NSInteger port;
@property(nonatomic,copy)void(^callBack)(NSString *);

@property(nonatomic,strong)GCDAsyncSocket * socket;
@end

@interface DDD8xSocket : NSObject<GCDAsyncSocketDelegate>

@property(nonatomic,weak)id<DDD8xSocketProtocol>delegate;

@property(nonatomic,strong)GCDAsyncSocket * socket;

@property(nonatomic,strong)DDDQuickLoginModelFFF * info;

@property(nonatomic)DDD8XSocketEventType status;

@property(nonatomic,copy)NSString * aes_key;

@property(nonatomic,copy)NSString * srv_key;

@property(nonatomic,copy)NSString * qq_token;

@property(nonatomic,copy)NSString * qq_skey;

@property(nonatomic,copy)NSString * game_auth_sign;

@property(nonatomic,copy)NSString * game_id;

@property(nonatomic,copy)NSString * upload_source;

@property BOOL re_open_token;

@property(nonatomic,strong)NSDictionary * game_auth_dic;

@property(nonatomic,strong)NSMutableData * readedData;



-(void)reDoTask;

-(void)endTask;

-(void)doTaskWith:(DDDQuickLoginModelFFF *)dic;


@end
NS_ASSUME_NONNULL_END
