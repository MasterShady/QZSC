//
//  DDDShanghaoLoadingView.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDShanghaoLoadingViewFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIColor+DDDFFF.h"


#import <Masonry/Masonry.h>
@import Lottie;



@interface DDDShanghaoLoadingViewFFF ()

@property(nonatomic,strong)dispatch_source_t timer;



@property(nonatomic,strong)CompatibleAnimationView * animationView;

@property(nonatomic,strong)UIView * progressBackView;

@property(nonatomic,strong)UILabel * progressNumLabel;

@property(nonatomic,strong)UIProgressView * progress;

@property(nonatomic,strong)UILabel * progressMsgLabel;

@property(nonatomic,strong)UILabel * msgLabel;

@property(nonatomic,strong) UIButton * closeBtn;

@end

@implementation DDDShanghaoLoadingViewFFF

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)dealloc{
    
    if(_timer != nil){
        
        dispatch_source_cancel(_timer);
        
        _timer = nil;
    }
}

+(instancetype)loadingView{
    
    DDDShanghaoLoadingViewFFF * view = [[DDDShanghaoLoadingViewFFF alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    [view uiConfigure];
    return view;
}

-(void)uiConfigure{
    [self addSubview: self.animationView];
    [self addSubview:self.progressBackView];
    [self.progressBackView addSubview:self.progressNumLabel];
    [self.progressBackView addSubview:self.progress];
    [self addSubview: self.progressMsgLabel];
    [self addSubview:self.msgLabel];
    [self addSubview:self.closeBtn];
    
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(DDDScale_Height(105) + DDDSTATUSBAR_HEIGHT);
        make.size.equalTo(@(CGSizeMake(DDDScale_Width(208), DDDScale_Height(208))));
    }];
    
    
    [self.progressBackView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.top.equalTo(self.animationView.mas_bottom);
        make.height.mas_equalTo(DDDScale_Height(44));
    }];
    
    [self.progressNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_progressBackView);
        make.left.equalTo(_progressBackView).offset(DDDScale_Width(90));
        make.height.equalTo(@(DDDScale_Height(13)));
    }];
    
    [_progress mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(_progressBackView);
        make.left.equalTo(_progressNumLabel.mas_right).offset(DDDScale_Width(6));
        make.size.equalTo(@(CGSizeMake(DDDScale_Width(164), DDDScale_Height(6))));
    }];
    
    [_progressMsgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self);
        make.top.equalTo(_progressBackView.mas_bottom);
    }];
    [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_progressMsgLabel.mas_bottom).offset(DDDScale_Height(8));
        make.left.equalTo(self).offset(DDDScale_Width(80));
        make.right.equalTo(self).offset(DDDScale_Width(-80));
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(DDDScale_Width(15));
        make.top.equalTo(self).offset(DDDScale_Height(8) + DDDSTATUSBAR_HEIGHT);
        make.width.height.equalTo(@(32));
        
    }];

}


-(void)setMsgArray:(NSArray<NSString *> *)msgArray{
    
    
    _msgArray = msgArray;
    
    if (_msgArray.count == 0){return;}
    
    self.msgLabel.text = _msgArray[0];
    
    __block int index = 1;
    
    WeakObj(self);
    
    self.timer = DDDTimer(5, ^{
        
        if (weakSelf == nil) {return; }
        
        
        if (index >= weakSelf.msgArray.count){
            
            index = 0;
        }else{
            
            weakSelf.msgLabel.text = weakSelf.msgArray[index ];
            index += 1;
        }
    });
    
    dispatch_resume(_timer);
    
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf == nil) {return; }
        weakSelf.progress.progress = 0.2;
        weakSelf.progressNumLabel.text = @"20%";
        weakSelf.progressMsgLabel.text = @"正在检测本地环境中...";
    });
    
   
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(80 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf == nil) {return; }
        weakSelf.progress.progress = 0.45;
        weakSelf.progressNumLabel.text = @"45%";
        weakSelf.progressMsgLabel.text = @"正在校验...";
        
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf == nil) {return; }
        weakSelf.progress.progress = 0.6;
        weakSelf.progressNumLabel.text = @"60%";
        weakSelf.progressMsgLabel.text = @"正在获取数据...";
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(300 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (weakSelf == nil) {return; }
        weakSelf.progress.progress = 0.9;
        weakSelf.progressNumLabel.text = @"90%";
        weakSelf.progressMsgLabel.text = @"准备就绪，正在启动游戏...";
    });
}


-(void)setShow_text:(NSString *)show_text{
    
    _show_text = show_text;
    
    
    self.msgLabel.text = show_text;
    _msgLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.progressMsgLabel setHidden:YES];
    [self.progressNumLabel setHidden:YES];
    [self.progress setHidden:YES];
}

-(CompatibleAnimationView *)animationView{
    
    if (_animationView == nil){

        _animationView = [[CompatibleAnimationView alloc] init];
        CompatibleAnimation * animation = [[CompatibleAnimation alloc] initWithName:@"lolm_tb_game" bundle:[DDDUtilsFFF getCurrentBundle]];
        
        _animationView.compatibleAnimation = animation;
        
        _animationView.contentMode = UIViewContentModeScaleAspectFill;
        
        _animationView.loopAnimationCount = -1;
    }
    return  _animationView;
}


-(UIView *)progressBackView {
    
    if(_progressBackView == nil){
        
        _progressBackView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    
    return _progressBackView;
}

-(UILabel *)progressNumLabel {
    
    if(_progressNumLabel == nil){
        
        _progressNumLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _progressNumLabel.text = @"0%";
        
        _progressNumLabel.font = [UIFont fontWithSize:12 withAlias:FontAlispfRegular];
        
        _progressNumLabel.textColor = [UIColor colorWithHex:@"#FF6080"];
    }
    
    return _progressNumLabel;
}


-(UIProgressView *)progress{
    
    if(_progress == nil){
        
        
        _progress = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        _progress.trackTintColor = [UIColor colorWithHex:@"#FFDCE3"];
        
        _progress.progressTintColor = [UIColor colorWithHex:@"#FF6080"];
        
        _progress.progress = 0;
        
        _progress.layer.cornerRadius = 3;
        
        _progress.layer.masksToBounds = YES;
        
        
    }
    
    return _progress;
}


-(UILabel *)progressMsgLabel{
    
    if(_progressMsgLabel == nil){
        
        _progressMsgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _progressMsgLabel.text = @"正在检测本地环境中...";
        
        _progressMsgLabel.font = [UIFont fontWithSize:14 withAlias:FontAlispfRegular];
        
        _progressMsgLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    
    return _progressMsgLabel;
}
-(UILabel *)msgLabel{
    
    if(_msgLabel == nil){
        
        _msgLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
        _msgLabel.text = @"";
        
        _msgLabel.font = [UIFont fontWithSize:12 withAlias:FontAlispfRegular];
        
        _msgLabel.textColor = [UIColor colorWithHex:@"A1A0AB"];
    }
    
    return _msgLabel;
}


-(UIButton *)closeBtn{
    
    if(_closeBtn == nil){
        
        
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_closeBtn setImage:DDDGetImageFFF(@"back_icon_black", YES) forState:UIControlStateNormal];
        
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _closeBtn;
}

-(void)lottie_play{ [_animationView play];}
-(void)lottie_pause{[_animationView pause];}
-(void)closeBtnClicked{if (self.closeBlock != nil){self.closeBlock();}}

- (void)hidden {
    
    [self lottie_pause];
    
    [self removeFromSuperview];
}

- (void)play {
    
    [self lottie_play];
}

- (void)show {
    
    [_targetView addSubview:self];
    
    [self lottie_play];
}

- (void)suspend {
    
    [self lottie_pause];
}



@end
