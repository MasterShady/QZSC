//
//  DDDGameGuidePopWidgetFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDGameGuidePopWidgetFFF.h"

#import <AVFoundation/AVFoundation.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <Masonry/Masonry.h>
#import "UIColor+DDDFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIView+DDDFFF.h"

@interface DDDGameGuidePopWidgetFFF()<UIGestureRecognizerDelegate,SDCycleScrollViewDelegate>

@property(nonatomic,strong)NSArray * urls;

@property(nonatomic,strong)UIView * contentView;

@property(nonatomic,strong)UILabel * titleLabel;

@property(nonatomic,strong)UIButton * launchGameButton;

@property(nonatomic,strong)UIButton *  alertSubTitleButton;

@property(nonatomic,strong)SDCycleScrollView * videoScrollView;

@property(nonatomic,strong)UIPageControl * imagePageControl;

@property(nonatomic,strong)CAShapeLayer * radioLayer;

@end



@interface DDDGameVideoCollectionCellFFF : UICollectionViewCell

@property(nonatomic,strong)AVPlayerLayer * videoLayer;

@property(nonatomic,strong)UIImageView * holderImg;

@end


@implementation DDDGameVideoCollectionCellFFF


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    _videoLayer = [AVPlayerLayer layer];
    
    [self.layer addSublayer:_videoLayer];
    
    _holderImg = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"df_gameGuide_holder", YES)];
    
    [self addSubview:_holderImg];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [_holderImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self);
    }];
    return self;
}

-(void)setUrl:(NSString *)url{
    
    AVPlayer * player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    self.videoLayer.player = player;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]){
        
        if ([change[NSKeyValueChangeNewKey] intValue] == 1){
         
            [self.videoLayer.player play];
        }
    }
}


-(void)play{
    
    if (_videoLayer.player  == nil){return;}
    
    [_videoLayer.player play];
}
-(void)videoPlayEnd{
    
    if (_videoLayer.player  == nil){return;}
    
    [_videoLayer.player.currentItem seekToTime:kCMTimeZero completionHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self play];
    });
}
-(void)layoutSubviews {
    
    [super layoutSubviews];
    
    _videoLayer.frame = self.bounds;
}
@end

@implementation DDDGameGuidePopWidgetFFF



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


-(SDCycleScrollView *)videoScrollView{
    
    if(_videoScrollView == nil){
    
        _videoScrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectZero];
        _videoScrollView.delegate = self;
        _videoScrollView.autoScroll = NO;
        _videoScrollView.infiniteLoop = YES;
        _videoScrollView.showPageControl = NO;
        _videoScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
       
    }
    
    
    return _videoScrollView;
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
    
    DDDGameGuidePopWidgetFFF * view = [[DDDGameGuidePopWidgetFFF alloc] initWithFrame: UIScreen.mainScreen.bounds];
    
    view.urls = info.urls;
    
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
    [_contentView addSubview:self.videoScrollView];
    [_contentView addSubview:self.imagePageControl];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(DDDScreenWidth*1.2 + DDDScale_Height(65 + 115) + DDDBOTTOM_HEIGHT);
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(DDDScreenWidth*1.2 + DDDScale_Height(65 + 115) + DDDBOTTOM_HEIGHT);
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
    
    [_videoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_contentView);
        make.right.equalTo(_contentView);
        make.top.equalTo(_contentView).offset(DDDScale_Height(65));
        make.height.mas_equalTo(DDDScreenWidth * 1.2);
    }];
    
   
    
    [_imagePageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_contentView);
        make.top.equalTo(_videoScrollView.mas_bottom).offset(DDDScale_Height(12));
        make.height.mas_equalTo(DDDScale_Height(8));
    }];
    
    _videoScrollView.imageURLStringsGroup = _urls;
    if (_urls.count <= 1){
        
        [_imagePageControl setHidden: YES];
    }
    
    _imagePageControl.numberOfPages = _urls.count;
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

-(Class)customCollectionViewCellClassForCycleScrollView:(SDCycleScrollView *)view{
    
    return [DDDGameVideoCollectionCellFFF class];
}

-(void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(SDCycleScrollView *)view{
    
    if ([cell isKindOfClass:DDDGameVideoCollectionCellFFF.class]){
       
        DDDGameVideoCollectionCellFFF * _cell = (DDDGameVideoCollectionCellFFF*)cell;
        
        [_cell setUrl:_urls[index]];
    }
   
}
@end

