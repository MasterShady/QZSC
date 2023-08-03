//
//  DDDLoginGuideUtilFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import "DDDLoginGuideUtilFFF.h"
#import "DDDImageGuideViewFFF.h"
#import "DDDGameGuidePopWidgetFFF.h"
#import "DDDAuthorityViewFFF.h"
@import AVFoundation;
@interface DDDLoginGuideUtilFFF()

@property(nonatomic,strong)DDDGuideInfoFFF * info;
@property(nonatomic,weak)UIView * containerView;
@property(nonatomic,copy)void(^guideCompletionBlock)(void);
@end

@implementation DDDLoginGuideUtilFFF


-(void)showGuideWithInfo:(DDDGuideInfoFFF *)info
                withView:(UIView *)view
withCompletionBlock:(void(^)(void))block{
    
    self.info = info;
    self.containerView = view;
    self.guideCompletionBlock = block;
    
}

-(void)showImage{
    
    DDDImageGuideViewFFF * imgGuideView = [DDDImageGuideViewFFF popWidgetWith:self.info];
    imgGuideView.completionBlock = ^{
        
        self.guideCompletionBlock != nil ? self.guideCompletionBlock() : nil;
    };
    [imgGuideView showWith:self.containerView];
}

-(void)showVideo{
    
    DDDGameGuidePopWidgetFFF * videoGuideView = [DDDGameGuidePopWidgetFFF popWidgetWith:self.info];
    videoGuideView.completionBlock = ^{
        
        self.guideCompletionBlock != nil ? self.guideCompletionBlock() : nil;
    };
    [videoGuideView showWith:self.containerView];
}
@end


@implementation  DDDMicroCheckUtilFFF

+(void)checkMicroWithNext:(dispatch_block_t)block{
    
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    
    switch (session.recordPermission) {
        case AVAudioSessionRecordPermissionDenied:
        case AVAudioSessionRecordPermissionUndetermined:
           
        {
            DDDAuthorityViewFFF * authView = [[DDDAuthorityViewFFF  alloc] initWithFrame:UIScreen.mainScreen.bounds];
            authView.launchGameBlock = block;
            [authView show];
        }
            break;
        case AVAudioSessionRecordPermissionGranted:
            
            block != nil ? block() : nil;
            break;
        default:
           
            break;
    }
    
}

@end
