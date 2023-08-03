//
//  DDDImageGuideViewFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDImageGuideViewFFF.h"
#import "UIColor+DDDFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIView+DDDFFF.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import "Masonry.h"
@interface DDDImageGuideViewFFF()<UIGestureRecognizerDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)NSArray * imgURLS;

@property(nonatomic,strong)UIView * contentView;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIButton * launchGameButton;

@property(nonatomic,strong)UIButton *  alertSubTitleButton;

@property(nonatomic,strong)SDCycleScrollView * imageScrollView;

@property(nonatomic,strong)UIPageControl * imagePageControl;

@end

@implementation DDDImageGuideViewFFF



-(UIView *)contentView{
    
    if(_contentView == nil){
        
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        _contentView.layer.cornerRadius = 17;
        _contentView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    
    return _contentView;
}

-(UILabel *)titleLabel{
    
    if(_titleLabel == nil){
        
        _titleLabel= [[UILabel alloc] init];
        _titleLabel.text = @"上号操作引导";
        _titleLabel.font = [UIFont fontWithSize:18 withAlias:FontAlispfSemibold];
        _titleLabel.textColor = [UIColor colorWithHex:@"#222222"];
    }
    
    return _titleLabel;
}
-( UIButton*)launchGameButton{
    
    if(_launchGameButton == nil){
        
        _launchGameButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_launchGameButton setTitle:@"启动游戏" forState:UIControlStateNormal];
        [_launchGameButton setTitleColor:[UIColor colorWithHex:@"#FFFFFF"] forState:UIControlStateNormal];
        _launchGameButton.titleLabel.font = [UIFont fontWithSize:16 withAlias:FontAlispfMedium];
        _launchGameButton.layer.cornerRadius = DDDScale_Width(23.5);
        _launchGameButton.layer.masksToBounds = YES;
        [_launchGameButton addTarget:self action:@selector(launchGame) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _launchGameButton;
}

-( UIButton*)alertSubTitleButton{
    
    if(_alertSubTitleButton == nil){
        
        _alertSubTitleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_alertSubTitleButton setTitle:@"下次不再提醒" forState:UIControlStateNormal];
        [_alertSubTitleButton setTitleColor:[UIColor colorWithHex:@"#999999"] forState:UIControlStateNormal];
        _alertSubTitleButton.titleLabel.font = [UIFont fontWithSize:12 withAlias:FontAlispfMedium];
        [_alertSubTitleButton setImage:DDDGetImageFFF(@"guide_alert_icon_normal", YES) forState:UIControlStateNormal];
        [_alertSubTitleButton setImage:DDDGetImageFFF(@"guide_alert_icon_selected", YES) forState:UIControlStateSelected];
        [_alertSubTitleButton addTarget:self action:@selector(alertAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _launchGameButton;
}


-(SDCycleScrollView *)imageScrollView{
    
    if(_imageScrollView == nil){
    
        _imageScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
        _imageScrollView.delegate = self;
        _imageScrollView.autoScroll = NO;
        _imageScrollView.infiniteLoop = YES;
        _imageScrollView.showPageControl = NO;
        _imageScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _imageScrollView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        _imageScrollView.layer.cornerRadius = DDDScale_Height(16);
        _imageScrollView.layer.masksToBounds = YES;
    }
    
    
    return _imageScrollView;
}

-(UIPageControl *)imagePageControl{
    
    if(_imagePageControl == nil){
        
        _imagePageControl = [UIPageControl new];
        _imagePageControl.currentPageIndicatorTintColor = [UIColor colorWithHex:@"#A1A0AB"];
        _imagePageControl.pageIndicatorTintColor = [[UIColor colorWithHex:@"#A1A0AB"] colorWithAlphaComponent:0.32];
    }
    
    return _imagePageControl;
}

+(instancetype)popWidgetWith:(DDDGuideInfoFFF *)info{
    
    DDDImageGuideViewFFF * view = [[DDDImageGuideViewFFF alloc] initWithFrame: UIScreen.mainScreen.bounds];
    
    view.imgURLS = info.urls;
    [view setUp];
    return view;
}

-(void)setUp{
    
    self.backgroundColor = [[UIColor colorWithHex:@"#000000"] colorWithAlphaComponent:0.7];
    [self setHidden:YES];
    self.alpha = 0;
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    [self setSubviews];
}
-(void)setSubviews{
    
    [self addSubview:self.contentView];
    [_contentView addSubview:self.titleLabel];
    [_contentView addSubview:self.launchGameButton];
    [_contentView addSubview:self.imageScrollView];
    [_contentView addSubview:self.imagePageControl];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(DDDScale_Height(465) + DDDBOTTOM_HEIGHT);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(DDDScale_Height(465) + DDDBOTTOM_HEIGHT);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_contentView).offset(DDDScale_Height(16));
        make.centerX.equalTo(_contentView);
    }];
    
    [_launchGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(DDDScale_Width(272));
        make.height.mas_equalTo(DDDScale_Height(47));
        make.centerX.equalTo(_contentView);
        make.bottom.equalTo(_contentView).offset(-DDDBOTTOM_HEIGHT-DDDScale_Height(28));
        
    }];
    
    [_launchGameButton gradientColorWithColors:@[[UIColor colorWithHex:@"#FF467B"],[UIColor colorWithHex:@"#FF334B"]] withStartPoint:CGPointMake(0, 0) withEndPoint:CGPointMake(1, 1)];
    
    [_imageScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_contentView).offset(DDDScale_Width(16));
        make.right.equalTo(_contentView).offset(DDDScale_Width(-16));
        make.top.equalTo(_contentView).offset(DDDScale_Height(65));
        make.height.mas_equalTo(DDDScale_Height(285));
    }];
    
    _imageScrollView.imageURLStringsGroup = _imgURLS;
    
    [_imagePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_imageScrollView.mas_bottom).offset(DDDScale_Height(12));
        make.height.mas_equalTo(DDDScale_Height(8));
    }];
    
    if (_imgURLS.count <= 1){
        
        [_imagePageControl setHidden: YES];
    }
    
    _imagePageControl.numberOfPages = _imgURLS.count;
    _imagePageControl.currentPage = 0;
}
-(void)alertAction:(UIButton *)sender{
    
    [sender setSelected:!sender.isSelected];
}
-(void)dismiss{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 0;
        [self setHidden:NO];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
        }];
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}
-(void)showWith:(UIView *)containerView{
    
    [self removeFromSuperview];
    
    if (containerView == nil){
        
        [[DDDUtilsFFF getCurrentViewController].view addSubview:self];
    }else{
        
        [containerView addSubview:self];
    }
    
    [self.superview layoutIfNeeded];
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 1;
        [self setHidden:NO];
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self);
        }];
        
        [self layoutIfNeeded];
    }];
    
}
-(void)launchGame{
    
    [self dismiss];
    
    self.completionBlock != nil ? self.completionBlock() : nil;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_contentView]){
        
        return  false;
    }
    
    
    return  true;
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
    _imagePageControl.currentPage = index;
}
@end
