//
//  DDDGameAutoLoginToolFFF.h
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/21.
//

#import <Foundation/Foundation.h>
#import "DDDActInfoFFF.h"
NS_ASSUME_NONNULL_BEGIN

extern const  NSErrorDomain DDDSmErrorDomain ;
extern const  NSErrorDomain DDDAutoGameErrorDomain ;
extern const  NSErrorDomain DDDAutoGameQQErrorDomain ;
extern const  NSErrorDomain DDDAutoGameWXErrorDomain ;
extern const  NSErrorDomain DDDAutoGameCloudErrorDomain ;

@protocol DDDLoginGameToolProtocolFFF <NSObject>


-(void)toolFinished;
-(void)toolTaskErrorWith:(NSError *)error
          withCompletion:(dispatch_block_t)completionBlock;
-(void)orderNeedReloadWithMessage:(NSString * __nullable)message;

-(__kindof UIViewController *)HMCloudGamePresentViewController;
-(void)HMCloudGameClose;

@end

@interface DDDGameAutoLoginToolFFF : NSObject

-(instancetype)initWithToken:(NSString *)token
                    withUUID:(NSString *)uuid
                 withApiType:(NSInteger)apitype
              withAppVersion:(NSString *)appversion
                 withAppsign:(NSString *)appsign
                   withAppid:(NSString *)appid
           withWebsocketSign:(NSString *)websocketsign
                withshumeiId:(NSString *)shumeiid
                    withsmid:(NSString *)smid;

@property(nonatomic,weak)id<DDDLoginGameToolProtocolFFF> delegate;
@property(nonatomic,strong)DDDActInfoFFF * actInfo;
-(void)cancel;

-(void)doTask;

@end




@interface DDDSmCheckUtilFFF : NSObject

@property(nonatomic,copy)NSString * uncode;

-(void)check;

@property(nonatomic,copy)void(^resultBlock)(NSInteger,id __nullable);


@end
NS_ASSUME_NONNULL_END
