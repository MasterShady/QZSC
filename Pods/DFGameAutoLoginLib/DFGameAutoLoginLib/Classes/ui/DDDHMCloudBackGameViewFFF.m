//
//  DDDHMCloudBackGameViewFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/26.
//

#import "DDDHMCloudBackGameViewFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIColor+DDDFFF.h"
#import <Masonry/Masonry.h>
@interface DDDHMCloudBackGameViewFFF()
{
    UIView * _bgView;
}
@end

@implementation DDDHMCloudBackGameViewFFF

+(instancetype)backGameView{
    
    DDDHMCloudBackGameViewFFF * view = [[DDDHMCloudBackGameViewFFF alloc] initWithFrame:UIScreen.mainScreen.bounds];
    
    [view uiConfigure];
    return view;
}


-(void)uiConfigure{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(DDDScale_Width(-260), 0, DDDScale_Width(260), CGRectGetHeight(self.frame))];
    _bgView.backgroundColor = [UIColor.blackColor colorWithAlphaComponent:0.6];
    [self addSubview:_bgView];
    
    UIControl * backBtn = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, DDDScale_Width(200), DDDScale_Width(44))];
    [_bgView addSubview:backBtn];
    [backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * backIcon = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"back_icon",YES)];
    backIcon.frame = CGRectMake(DDDScale_Width(15), DDDScale_Width(15), 15, 15);
    [backBtn addSubview:backIcon];
    
    UILabel * backLabel = [[UILabel alloc] initWithFrame:CGRectMake(DDDScale_Width(42), DDDScale_Width(12), 0, 0)];
    backLabel.text = @"1.4快速游戏";
    backLabel.font = [UIFont fontWithSize:14 withAlias:FontAlispfRegular];
    backLabel.textColor = UIColor.whiteColor;
    [backBtn addSubview:backLabel];
    [backLabel sizeToFit];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectZero];
    line1.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [_bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(DDDScale_Width(230));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(_bgView).offset(DDDScale_Width(44));
        make.left.equalTo(_bgView).offset(DDDScale_Width(15));
    }];
    
    UIButton * backGameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backGameBtn setImage:DDDGetImageFFF(@"go_game_btn", YES) forState:UIControlStateNormal];
    [_bgView addSubview:backGameBtn];
    [backGameBtn addTarget:self action:@selector(backGameBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [backGameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(DDDScale_Width(121));
        make.height.mas_equalTo(DDDScale_Width(34));
        make.centerX.equalTo(_bgView);
        make.centerY.equalTo(_bgView).offset(DDDScale_Width(10));
    }];
    
    UILabel * bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    backLabel.text = @"点此按钮，退出游戏回到APP";
    backLabel.font = [UIFont fontWithSize:11 withAlias:FontAlispfRegular];
    backLabel.textColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    [backBtn addSubview:backLabel];
    [_bgView addSubview:backLabel];
    [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(backGameBtn).offset(-DDDScale_Width(11));
        make.top.equalTo(backGameBtn.mas_bottom).offset(DDDScale_Width(12));
    }];
    
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectZero];
    line2.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
    [_bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(DDDScale_Width(230));
        make.height.mas_equalTo(0.5);
        make.top.equalTo(backGameBtn.mas_bottom).offset(DDDScale_Width(39));
        make.left.equalTo(_bgView).offset(DDDScale_Width(15));
    }];
    
}

-(void)backGameBtnClicked{
    
    self.closeGameBlock!= nil ? self.closeGameBlock() : nil;
}

-(void)backBtnClicked{
    
    [self dismiss];
    
}
-(void)dismiss{
    
    [self removeFromSuperview];
}

-(void)showWith:(UIView *)view{
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self->_bgView setFrame:CGRectMake(0, 0, 260, CGRectGetHeight(self.frame))];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    CGPoint touchPoint = [[touches.allObjects objectAtIndex:0] locationInView:self];
    if(CGRectContainsPoint(_bgView.frame,touchPoint)){return;}
    
    [self dismiss];
}
@end
