//
//  DDDLoadingDelegateFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import "DDDLoadingProviderFFF.h"
#import "DDDHmCloudLoadingViewFFF.h"
#import "DDDShanghaoLoadingViewFFF.h"
#import "DDDUtilsFFF.h"
@interface DDDLoadingProviderFFF()

@property(nonatomic,strong)DDDShanghaoLoadingViewFFF * loginGameLoadingView;

@end


@implementation DDDLoadingProviderFFF

-(DDDShanghaoLoadingViewFFF *)loginGameLoadingView{
    
    if(_loginGameLoadingView == nil){
        
        
        _loginGameLoadingView = [DDDShanghaoLoadingViewFFF loadingView];
        _loginGameLoadingView.backgroundColor = UIColor.whiteColor;
        _loginGameLoadingView.targetView = [DDDUtilsFFF getCurrentViewController].view;
        WeakObj(self);
        _loginGameLoadingView.closeBlock = ^{
            
            [weakSelf.loginGameLoadingView setHidden:YES];
            weakSelf.cancelBlock != nil ? weakSelf.cancelBlock() : nil;
        };
    }
    
    return _loginGameLoadingView;
}

-(void)setLoadingViewWithInfo:(DDDActInfoFFF *)info{
    
    if (info.is_cloudGame){
        
        self.loginGameLoadingView.show_text = @"云游戏准备中,请稍后";
    }else{
        
        if (info.is_wx_server){
            
            self.loginGameLoadingView.msgArray = [info.wx_loadingStrings mutableCopy];
            
        }else{
            
            self.loginGameLoadingView.show_text = @"启动游戏...";
        }
    }
}

-(id<DDDLoginGameLoadingViewProtocolFFF>)getLoadingVieW{
    
    return self.loginGameLoadingView;
}

-(id<DDDLoginGameLoadingViewProtocolFFF>)getHMCloudGamePageLoadingView{
    
    return [DDDHmCloudLoadingViewFFF loadingView];
}

@end
