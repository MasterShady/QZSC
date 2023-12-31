//
//  CloudPlayerWarpper.m
//  YWCloudPlayer
//
//  Created by Apple on 2018/7/10.
//  Copyright © 2018年 Apple. All rights reserved.
//

#if !(TARGET_IPHONE_SIMULATOR)

#import "DDDCloudPlayerWarpperFFF.h"

@interface DDDCloudPlayerWarpperFFF () <HMCloudPlayerDelegate> {
    BOOL isInitialized;
}

@end

@implementation DDDCloudPlayerWarpperFFF

-(void)dealloc {
    
   
}

+ (instancetype) sharedWrapper {
    static id cloudPlayerWarpper;
    static dispatch_once_t cloudPlayerWarpperToken;
    dispatch_once(&cloudPlayerWarpperToken, ^{
        cloudPlayerWarpper = [[self alloc] init];
    });

    return cloudPlayerWarpper;
}

- (instancetype) init {
    if (self = [super init]) {
        isInitialized = NO;
        
    }

    return self;
}

//- (void) readConfigFile {
//    @autoreleasepool {
//        NSString *configFile = [[NSBundle mainBundle] pathForResource:@"CloudPlayer.config" ofType:nil];
//        NSData *configData = [NSData dataWithContentsOfFile:configFile];
//        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:configData options:NSJSONReadingAllowFragments error:nil];
//
//        if (jsonDic && [jsonDic isKindOfClass:[NSDictionary class]]) {
//            self.accessKeyId = [jsonDic objectForKey:@"accessKeyId"];
//            self.accessKey = [jsonDic objectForKey:@"accessKey"];
//
//            self.games = [jsonDic objectForKey:@"games"];
//        }
//    }
//}

- (BOOL) isRegisted{
    
    return  isInitialized;
}

- (void) regist:(NSString *)channelId{
    if (isInitialized) return;

    NSLog(@" =============== SDK_VERSION : %@", CLOUDGAME_SDK_VERSION);

    [[HMCloudPlayer sharedCloudPlayer] setDelegate:self];
    [[HMCloudPlayer sharedCloudPlayer] registCloudPlayer:self.accessKeyId channelId:channelId options:nil];
    
}

- (UIViewController *) prepare:(NSDictionary *)options {
    if (!isInitialized) return NULL;

    return [[HMCloudPlayer sharedCloudPlayer] prepare:options];
}

- (void) setBackgroundImage:(UIImage *)bgImage {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] setBackgroundImage:bgImage];
}

-(CloudCorePlayerStatus)playerStatus{
    
    return  [HMCloudPlayer sharedCloudPlayer].playerStatus;
}

- (void) updateTimes:(NSInteger)tims{
    
    [[HMCloudPlayer sharedCloudPlayer] updateGameUID:[HMCloudPlayer sharedCloudPlayer].userId userToken:[HMCloudPlayer sharedCloudPlayer].userToken ctoken:[HMCloudPlayer sharedCloudPlayer].cToken playingTime:tims tip:nil protoData:nil success:^(BOOL successed) {
        
    } fail:^(NSString *errorCode) {
        
    }];
}

- (void) play {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] play];
}
- (void) queueConfirm {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] confirmQueue];
}

- (void) pause {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] pause];
}

- (void) resume:(NSInteger)playingTime {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] resume:playingTime];
}

- (void) stop {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] stop];
}

- (void) stopAndDismiss:(BOOL)animated {
    if (!isInitialized) return;

    if ([NSThread isMainThread])
        [[HMCloudPlayer sharedCloudPlayer] stopAndDismiss:NO];
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[HMCloudPlayer sharedCloudPlayer] stopAndDismiss:animated];
        });
    }
}

- (void) swithcResolutin:(NSInteger)resolutionId {
    if (!isInitialized) return;

    [[HMCloudPlayer sharedCloudPlayer] switchResolution:resolutionId];
}

- (void) sendMessage:(NSString *_Nonnull)msg{
    if (!isInitialized) return;
    if (!msg || ![msg isKindOfClass:[NSString class]] || !msg.length) return;

    [[HMCloudPlayer sharedCloudPlayer] sendMessage:msg];
}

- (NSString * __nullable) getCloudId{
    
    return  [HMCloudPlayer sharedCloudPlayer].cloudId;
}

-(NSInteger)getPlayingTime {
    
    return  [HMCloudPlayer sharedCloudPlayer].playingTime;
}

- (void) download:(NSString *)pickName {
    
    HMFile * file = [[HMFile alloc] init];
    file.fileName = pickName ;
    file.destinationPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    [[HMCloudPlayer sharedCloudPlayer] downloadFile:CloudPlayerDownloadTypeImage fileList:@[file] downloadProgress:^(double downloadProgress, HMFile *file) {
            
        } cloudFileDownloadResponseBlock:^(BOOL result, CloudPlayerDownloadResponseStatus status, NSString *errorMsg, HMFile *file) {
            
            if (result) {
                
                [self savePhoto:file];
                
            }
        } cloudFileDownloadComplete:^{
            
        }];
}

- (void)savePhoto:(HMFile *)file{
   
    NSString *path = [file.destinationPath stringByAppendingPathComponent:file.fileName];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    UIImageWriteToSavedPhotosAlbum(image, NULL, NULL, NULL);
}

#pragma mark CloudPlayer Delegate
- (void) cloudPlayerSceneChangedCallback:(NSDictionary *)dict {
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) return;

    NSLog(@"%s : %@", __FUNCTION__, dict);

    @autoreleasepool {
        NSString *scene = [dict objectForKey:@"sceneId"];
        NSDictionary *extraInfo = [dict objectForKey:@"extraInfo"];

        do {
            if ([scene isEqualToString:@"init"]) {
                [self processSceneInitInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"data"]) {
                [self processDataInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"prepare"]) {
                [self processPrepareInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"playerState"]) {
                [self processPlayerStateInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"queue"]) {
                [self processQueueInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"playingtime"]) {
                [self processPlayingTimeInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"resolution"]) {
                [self processResolutionInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"stastic"]) {
                [self processStasticInfo:extraInfo];
                break;
            }

            if ([scene isEqualToString:@"maintance"]) {
                [self processMaintanceInfo:extraInfo];
                break;
            }
        } while (0);
    }
}

- (void) cloudPlayerTouchBegan {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - CloudPlayer Delegate Function
- (void) processSceneInitInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"state"];
//    NSString *errorCode = [info objectForKey:@"errorCode"];

    if ([state isEqualToString:@"success"]) {
        isInitialized = YES;

        if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerReigsted:)])
            [_delegate cloudPlayerReigsted:YES];
    } else if ([state isEqualToString:@"failed"]) {
        isInitialized = NO;
        
        if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerReigsted:)])
            [_delegate cloudPlayerReigsted:NO];
    }
}

- (void) processDataInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    do {
        NSString *type = [info objectForKey:@"type"];

        if ([type isEqualToString:@"resolutions"]) {
            //设置清晰度切换按钮菜单
            NSArray *resolutions = [info objectForKey:@"data"];
            if (resolutions && [resolutions isKindOfClass:[NSArray class]]) {
                if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerResolutionList:)])
                    [_delegate cloudPlayerResolutionList:[NSArray arrayWithArray:resolutions]];
            }
            break;
        }

        if ([type isEqualToString:@"message"]) {
            //收到实例发送到客户端的消息
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerRecvMessage:)])
                [_delegate cloudPlayerRecvMessage:[info objectForKey:@"data"]];
            break;
        }
    } while (0);
}

- (void) processPrepareInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"state"];

    if ([state isEqualToString:@"success"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerPrepared:)])
            [_delegate cloudPlayerPrepared:YES];
    } else if ([state isEqualToString:@"failed"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerPrepared:)])
            [_delegate cloudPlayerPrepared:NO];
    }
}

- (void) processPlayerStateInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"state"];

    do {
        if ([state isEqualToString:@"prepared"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                [_delegate cloudPlayerStateChanged:PlayerStateInstancePrepared];
            break;
        }

        if ([state isEqualToString:@"videoVisible"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                [_delegate cloudPlayerStateChanged:PlayerStateVideoVisible];
            
            break;
        }

        if ([state isEqualToString:@"stopped"]) {
//            NSString *errorCode = [info objectForKey:@"errorCode"];
//            NSString *errorMsg = [info objectForKey:@"errorMsg"];
            NSString *reason = [info objectForKey:@"stop_reason"];

            if ([reason isEqualToString:@"no_operation"] || [reason isEqualToString:@"url_timeout"]) {
                if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                    [_delegate cloudPlayerStateChanged:PlayerStateStopCanRetry];
            } else {
                if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                    [_delegate cloudPlayerStateChanged:PlayerStateStop];
            }
            break;
        }

        if ([state isEqualToString:@"playFailed"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                [_delegate cloudPlayerStateChanged:PlayerStateFailed];
            break;
        }

        if ([state isEqualToString:@"timeout"]) {
//            NSString *tip = [info objectForKey:@"tip"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                [_delegate cloudPlayerStateChanged:PlayerStateTimeout];
            break;
        }

        if ([state isEqualToString:@"refreshSToken"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStateChanged:)])
                [_delegate cloudPlayerStateChanged:PlayerStateSToken];
            break;
        }
    } while (0);
}

- (void) processQueueInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"state"];
//    NSString *title = [info objectForKey:@"title"];

    do {
        if ([state isEqualToString:@"confrim"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerQueueStateChanged:)])
                [_delegate cloudPlayerQueueStateChanged:PlayerQueueStateConfirm];
            break;
        }

        if ([state isEqualToString:@"update"]) {
//            NSInteger index = [[info objectForKey:@"index"] integerValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerQueueStateChanged:)])
                [_delegate cloudPlayerQueueStateChanged:PlayerQueueStateUpdate];
            break;
        }

        if ([state isEqualToString:@"entering"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerQueueStateChanged:)])
                [_delegate cloudPlayerQueueStateChanged:PlayerQueueStateEntering];
            break;
        }
    } while (0);
}

- (void) processPlayingTimeInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"state"];

    do {
        if ([state isEqualToString:@"prompt"]) {
//            NSInteger seconds = [[info objectForKey:@"second"] integerValue];
//            NSString *title = [info objectForKey:@"title"];
//            BOOL countdown = [[info objectForKey:@"countdown"] boolValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerTimeStateChanged:)])
                [_delegate cloudPlayerTimeStateChanged:PlayerTimeStateNotify];
            break;
        }

        if ([state isEqualToString:@"update"]) {
//            NSString *title = [info objectForKey:@"title"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerTimeStateChanged:)])
                [_delegate cloudPlayerTimeStateChanged:PlayerTimeStateUpdate];
            break;
        }

        if ([state isEqualToString:@"totaltime"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerTimeStateChanged:)])
                [_delegate cloudPlayerTimeStateChanged:PlayerTimeStateTotalTime];
            break;
        }
    } while (0);
}

- (void) processResolutionInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *type = [info objectForKey:@"type"];

    do {
        if ([type isEqualToString:@"notify"]) {
//            NSInteger resolutionId = [[info objectForKey:@"cur_rate"] integerValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerResolutionStateChange:)])
                [_delegate cloudPlayerResolutionStateChange:PlayerResolutionStateNotify];
            break;
        }

        if ([type isEqualToString:@"crst"]) {
//            NSString *title = [info objectForKey:@"title"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerResolutionStateChange:)])
                [_delegate cloudPlayerResolutionStateChange:PlayerResolutionStateSwitchStart];
            break;
        }

        if ([type isEqualToString:@"cred"]) {
//            NSString *title = [info objectForKey:@"title"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerResolutionStateChange:)])
                [_delegate cloudPlayerResolutionStateChange:PlayerResolutionStateSwitchEnd];
            break;
        }

        if ([type isEqualToString:@"crtp"]) {
//            NSString *title = [info objectForKey:@"title"];
//            BOOL isMinimum = [[info objectForKey:@"minimum"] boolValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerResolutionStateChange:)])
                [_delegate cloudPlayerResolutionStateChange:PlayerResolutionStateTip];
            break;
        }
    } while (0);
}

- (void) processStasticInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *type = [info objectForKey:@"type"];

    do {
        if ([type isEqualToString:@"bandwidth"]) {
//            NSInteger value = [[info objectForKey:@"value"] integerValue];
//            NSArray *frames = [info objectForKey:@"frames"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStasticInfoReport:)])
                [_delegate cloudPlayerStasticInfoReport:PlayerStasticStateBandwidth];
            break;
        }

        if ([type isEqualToString:@"frames"]) {
//            NSInteger value = [[info objectForKey:@"value"] integerValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStasticInfoReport:)])
                [_delegate cloudPlayerStasticInfoReport:PlayerStasticStateFPS];
            break;
        }

        if ([type isEqualToString:@"decode"]) {
//            NSInteger value = [[info objectForKey:@"value"] integerValue];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerStasticInfoReport:)])
                [_delegate cloudPlayerStasticInfoReport:PlayerStasticStateDecodeTime];
            break;
        }
    } while (0);
}

- (void) processMaintanceInfo:(NSDictionary *)info {
    if (!info || ![info isKindOfClass:[NSDictionary class]]) return;

    NSString *state = [info objectForKey:@"progress"];

    do {
        if ([state isEqualToString:@"soon"]) {
//            NSString *title = [info objectForKey:@"title"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerMaintanceStateChanged:)])
                [_delegate cloudPlayerMaintanceStateChanged:PlayerMaintanceStateSoon];
            break;
        }

        if ([state isEqualToString:@"start"]) {
//            NSString *title = [info objectForKey:@"title"];
//            NSString *errorCode = [info objectForKey:@"errorCode"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerMaintanceStateChanged:)])
                [_delegate cloudPlayerMaintanceStateChanged:PlayerMaintanceStateStarted];
            break;
        }

        if ([state isEqualToString:@"inprogress"]) {
//            NSString *title = [info objectForKey:@"title"];
//            NSString *errorCode = [info objectForKey:@"errorCode"];
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerMaintanceStateChanged:)])
                [_delegate cloudPlayerMaintanceStateChanged:PlayerMaintanceStateInProgress];
            break;
        }

        if ([state isEqualToString:@"done"]) {
            if (_delegate && [_delegate respondsToSelector:@selector(cloudPlayerMaintanceStateChanged:)])
                [_delegate cloudPlayerMaintanceStateChanged:PlayerMaintanceStateDone];
        }
    } while (0);
}
@end


#endif
