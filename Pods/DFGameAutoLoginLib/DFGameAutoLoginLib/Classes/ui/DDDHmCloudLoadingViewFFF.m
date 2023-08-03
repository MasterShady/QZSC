//
//  DDDHmCloudLoadingView.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDHmCloudLoadingViewFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIColor+DDDFFF.h"

#import <Masonry/Masonry.h>
@import Lottie;

@interface DDDHmCloudLoadingViewFFF()

@property(nonatomic,strong)CompatibleAnimationView * animationView;

@end

@implementation DDDHmCloudLoadingViewFFF

+(instancetype)loadingView{
    
    DDDHmCloudLoadingViewFFF * view = [[DDDHmCloudLoadingViewFFF alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    [view uiConfigure];
    return view;
}

-(CompatibleAnimationView *)animationView{
    
    if (_animationView == nil){

        _animationView = [[CompatibleAnimationView alloc] init];
        CompatibleAnimation * animation = [[CompatibleAnimation alloc] initWithName:@"quick_login_loading" bundle:[DDDUtilsFFF getCurrentBundle]];
        
        _animationView.compatibleAnimation = animation;
        
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
        
        _animationView.loopAnimationCount = -1;
    }
    return  _animationView;
}


-(void)uiConfigure{
    
    [self addSubview:self.animationView];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self);
        make.size.equalTo(@(CGSizeMake(DDDScale_Height(208), DDDScale_Height(208))));
    }];
    
    [self play];
}

- (void)hidden {
    
    [self removeFromSuperview];
 
}

- (void)play {
    
    [self.animationView play];
}

- (void)show {
    
   
}

- (void)suspend {
    
    [self.animationView pause];
}

@end
