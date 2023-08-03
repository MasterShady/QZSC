//
//  DDDAuthorityViewFFF.m
//  DFGameAutoLoginLib
//
//  Created by mac on 2023/7/24.
//

#import "DDDAuthorityViewFFF.h"
#import "UIColor+DDDFFF.h"
#import "DDDUtilsFFF.h"
#import "UIFont+DDDFFF.h"
#import "UIView+DDDFFF.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
@interface DDDAuthorityViewFFF()<UIGestureRecognizerDelegate>

@property CGFloat contentHeight;
@property (nonatomic,strong)UIView *bottomBgView;
@property (nonatomic,strong)SWLGAuthorityCourseView *authorityCourseView;
@property (nonatomic,strong)UIImageView * bottomTitleImage;
@property (nonatomic,strong)UIImageView *  bottomTitleBgImage ;
@property (nonatomic,strong)UIButton * bottomCloseButton;
@property (nonatomic,strong) UILabel * bottomTitleLabel;
@property (nonatomic,strong) UILabel * bottomSubTitleLabel;
@property (nonatomic,strong)UIButton * launchGameButton;
@property (nonatomic,strong) UILabel * launchSubTitleLabel;
@property (nonatomic,strong) UIView * authorityContentView;
@property (nonatomic,strong)UIImageView * authorityMicroImageView;
@property (nonatomic,strong)UILabel * authorityMicroTitleLabel;
@property (nonatomic,strong)UILabel * authorityMicroSubTitleLabel;
@property (nonatomic,strong)UISwitch * authorityMicroSwitch;
@property (nonatomic,strong)UIButton * authorityMicroCourseButton;
@end

@implementation DDDAuthorityViewFFF

-(SWLGAuthorityCourseView *)authorityCourseView{
    
    if(_authorityCourseView == nil){
        
        _authorityCourseView = [[SWLGAuthorityCourseView alloc] initWithFrame:CGRectZero];
        
        WeakObj(self);
        _authorityCourseView.confirmBlock = ^{
            
            [weakSelf courseViewDismiss];
        };
    }
    
    return _authorityCourseView;
}

-(UIButton *)authorityMicroCourseButton {
    
    if (_authorityMicroCourseButton == nil){
        
        _authorityMicroCourseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_authorityMicroCourseButton setTitle:@"教程" forState:UIControlStateNormal];
        [_authorityMicroCourseButton setTitleColor:[UIColor colorWithHex:@"#F6194F"] forState:UIControlStateNormal];
        _authorityMicroCourseButton.titleLabel.font = [UIFont fontWithSize:10 withAlias:FontAlispfRegular];
        _authorityMicroCourseButton.layer.borderColor = [UIColor colorWithHex:@"#F6194F"].CGColor;
        _authorityMicroCourseButton.layer.borderWidth = 0.5;
        _authorityMicroCourseButton.layer.cornerRadius = 4;
        [_authorityMicroCourseButton setImage:DDDGetImageFFF(@"auth_course_arrow", YES) forState:UIControlStateNormal];
        [_authorityMicroCourseButton setImageEdgeInsets:UIEdgeInsetsMake(0, DDDScale_Width(26), 0, 0)];
        [_authorityMicroCourseButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, DDDScale_Width(10))];
    }
    
    return _authorityMicroCourseButton;
}

-(UISwitch *)authorityMicroSwitch{
    
    if(_authorityMicroSwitch == nil){
        
        _authorityMicroSwitch = [UISwitch new];
        _authorityMicroSwitch.onTintColor = [UIColor colorWithHex:@"#FE3E6D"];
        [_authorityMicroSwitch addTarget:self action:@selector(switchActionValueChanged) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _authorityMicroSwitch;
}

-(UILabel *)authorityMicroSubTitleLabel{
    
    if(_authorityMicroSubTitleLabel == nil){
        
        _authorityMicroSubTitleLabel = [[UILabel alloc] init];
        _authorityMicroSubTitleLabel.text = @"开启麦克风授权，您可以在游戏中选择开麦。";
        _authorityMicroSubTitleLabel.font = [UIFont fontWithSize:12 withAlias:FontAlispfRegular];
        _authorityMicroSubTitleLabel.textColor = [UIColor colorWithHex:@"#999999"];
    }
    
    return _authorityMicroSubTitleLabel;
}

-(UILabel *)authorityMicroTitleLabel{
    
    if(_authorityMicroTitleLabel == nil){
        
        _authorityMicroTitleLabel= [[UILabel alloc] init];
        _authorityMicroTitleLabel.text = @"麦克风授权";
        _authorityMicroTitleLabel.font = [UIFont fontWithSize:16 withAlias:FontAlispfSemibold];
        _authorityMicroTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    
    return _authorityMicroTitleLabel;
}

-(UIImageView *)authorityMicroImageView{
    
    if(_authorityMicroImageView == nil){
        
        _authorityMicroImageView = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"auth_micro_img", YES)];
    }
    
    return _authorityMicroImageView;
}


-(UIView *)authorityContentView{
    
    if(_authorityContentView == nil){
        
        _authorityContentView = [UIView new];
        _authorityContentView.backgroundColor = [UIColor whiteColor];
        _authorityContentView.layer.cornerRadius = DDDScale_Width(8);
    }
    
    return _authorityContentView;
}

-(UILabel *)launchSubTitleLabel{
    
    if(_launchSubTitleLabel == nil){
        
        _launchSubTitleLabel= [[UILabel alloc] init];
        _launchSubTitleLabel.text = @"请放心 租号玩不会泄漏您任何隐私";
        _launchSubTitleLabel.font = [UIFont fontWithSize:11 withAlias:FontAlispfRegular];
        _launchSubTitleLabel.textColor = [UIColor colorWithHex:@"#8E92A2"];
    }
    
    return _launchSubTitleLabel;
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

-(UILabel *)bottomSubTitleLabel{
    
    if(_bottomSubTitleLabel == nil){
        
        _bottomSubTitleLabel= [[UILabel alloc] init];
        _bottomSubTitleLabel.text = @"为保证您的上号体验，需开启以下权限才可启动游戏";
        _bottomSubTitleLabel.font = [UIFont fontWithSize:12 withAlias:FontAlispfRegular];
        _bottomSubTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
        _bottomSubTitleLabel.numberOfLines = 0;
        _bottomSubTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _bottomSubTitleLabel;
}

-(UILabel *)bottomTitleLabel{
    
    if(_bottomTitleLabel == nil){
        
        _bottomTitleLabel= [[UILabel alloc] init];
        _bottomTitleLabel.text = @"开启上号授权";
        _bottomTitleLabel.font = [UIFont fontWithSize:20 withAlias:FontAlispfSemibold];
        _bottomTitleLabel.textColor = [UIColor colorWithHex:@"#333333"];
    }
    
    return _bottomTitleLabel;
}


-( UIButton*)bottomCloseButton{
    
    if(_bottomCloseButton == nil){
        
        _bottomCloseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_bottomCloseButton setImage:DDDGetImageFFF(@"auth_close_icon", YES) forState:UIControlStateNormal];
        [_bottomCloseButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _bottomCloseButton;
}

-(UIImageView *)bottomTitleBgImage{
    
    if(_bottomTitleBgImage == nil){
        
        _bottomTitleBgImage = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"auth_titlebg_image", YES)];
    }
    
    return _bottomTitleBgImage;
}
-(UIImageView *)bottomTitleImage{
    
    if(_bottomTitleImage == nil){
        
        _bottomTitleImage = [[UIImageView alloc] initWithImage:DDDGetImageFFF(@"auth_title_image", YES)];
    }
    
    return _bottomTitleImage;
}


-(UIView *)bottomBgView{
    
    if(_bottomBgView == nil){
        
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomBgView.layer.cornerRadius =17;
        _bottomBgView.layer.maskedCorners = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner;
    }
    
    return _bottomBgView;
}


-(void)addMainWindow{
    
    [[DDDUtilsFFF getCurrentViewController].view addSubview:self];
    [self setHidden:YES];
    self.alpha = 0;
}

-(void)goToSetting{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidAvtive) name:UIApplicationDidBecomeActiveNotification object:nil];
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    self.backgroundColor = [[UIColor colorWithHex:@"#000000"] colorWithAlphaComponent:0.7];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    gesture.delegate = self;
    [self addGestureRecognizer:gesture];
    
    [self uiConfigure];
    [self autoLayout];
    return  self;
}


-(void)applicationDidAvtive{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    
    switch (session.recordPermission) {
        case AVAudioSessionRecordPermissionDenied:
        case AVAudioSessionRecordPermissionUndetermined:
            [self authorityViewChanged: NO];
            break;
        case AVAudioSessionRecordPermissionGranted:
            [self authorityViewChanged: YES];
            break;
        default:
            [self authorityViewChanged: NO];
            break;
    }
}
-(void)authorityViewChanged:(BOOL)isopen{
    
    if(isopen){
        
        [self.authorityMicroSwitch setOn:YES];
        self.launchGameButton.alpha = 1;
        [self.launchGameButton setEnabled:YES];
    }else{
        [self.authorityMicroSwitch setOn:NO];
        self.launchGameButton.alpha = 0.3;
        [self.launchGameButton setEnabled:NO];
        
    }
}
-(void)uiConfigure{
    
    [self addSubview:self.bottomBgView];
    [_bottomBgView addSubview:self.bottomTitleBgImage];
    [_bottomBgView addSubview:self.bottomTitleImage];
    [_bottomBgView addSubview:self.bottomCloseButton];
    [_bottomBgView addSubview:self.bottomTitleLabel];
    [_bottomBgView addSubview:self.bottomSubTitleLabel];
    [_bottomBgView addSubview:self.authorityContentView];
    
    [_authorityContentView addSubview: self.authorityMicroImageView];
    [_authorityContentView addSubview: self.authorityMicroTitleLabel];
    [_authorityContentView addSubview: self.authorityMicroSwitch];
    [_authorityContentView addSubview: self.authorityMicroCourseButton];
    [_authorityContentView addSubview: self.authorityMicroSubTitleLabel];
    
    [_bottomBgView addSubview:self.launchGameButton];
    [_bottomBgView addSubview:self.launchSubTitleLabel];
    
    [self addSubview:self.authorityCourseView];
}
-(void)autoLayout{
    
    
    [_bottomBgView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self);
    }];
    
    [_bottomTitleBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_bottomBgView);
        make.height.equalTo(@(DDDScale_Height(116)));
        make.top.equalTo(_bottomBgView);
    }];
    [_bottomTitleImage mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(@(DDDScale_Height(102)));
        make.height.mas_equalTo(DDDScale_Height(82));
        make.centerX.equalTo(_bottomBgView);
        make.top.equalTo(_bottomBgView).offset(-DDDScale_Height(57));
    }];
    
    [_bottomCloseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.height.mas_equalTo(DDDScale_Height(26));
        make.top.equalTo(_bottomBgView).offset(DDDScale_Height(12));
        make.right.equalTo(_bottomBgView).offset(DDDScale_Width(-12));
    }];
    
    [_bottomTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(DDDScale_Height(28)));
        make.top.equalTo(_bottomTitleBgImage).offset(DDDScale_Height(31));
        make.centerX.equalTo(_bottomBgView);
    }];
    
    [_bottomSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bottomTitleLabel.mas_bottom).offset(DDDScale_Height(3));
        make.width.equalTo(@(DDDScale_Width(301)));
        make.height.equalTo(@(DDDScale_Height(17)));
        make.centerX.equalTo(_bottomBgView);
    }];
    
    [_authorityContentView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_bottomSubTitleLabel.mas_bottom).offset(DDDScale_Height(18));
        make.height.equalTo(@(DDDScale_Height(76)));
        make.left.equalTo(_bottomBgView).offset(DDDScale_Width(12));
        make.right.equalTo(_bottomBgView).offset(DDDScale_Width(-12));
    }];
    
    [_authorityMicroImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(DDDScale_Height(28)));
        make.left.equalTo(_authorityContentView).offset(DDDScale_Width(14));
        make.centerY.equalTo(_authorityContentView);
    }];
    
    [_authorityMicroTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(DDDScale_Height(22)));
        make.left.equalTo(_authorityMicroImageView.mas_right).offset(DDDScale_Width(8));
        make.top.equalTo(_authorityContentView).offset(DDDScale_Height(18));
    }];
    [_authorityMicroSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.equalTo(@(DDDScale_Height(17)));
        make.left.equalTo(_authorityMicroTitleLabel);
        make.top.equalTo(_authorityMicroTitleLabel.mas_bottom).offset(DDDScale_Height(2));
    }];
    
    [_authorityMicroSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(DDDScale_Width(48));
        make.height.mas_equalTo(DDDScale_Height(26));
        make.centerY.equalTo(_authorityContentView);
        make.right.equalTo(_authorityContentView.mas_right).offset(DDDScale_Width(-14));
    }];
    
    [_authorityMicroCourseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DDDScale_Width(36));
        make.height.mas_equalTo(DDDScale_Height(16));
        make.centerY.equalTo(_authorityMicroTitleLabel);
        make.left.equalTo(_authorityMicroTitleLabel.mas_right).offset(DDDScale_Width(4));
    }];
    
    [_launchGameButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(DDDScale_Width(272));
        make.height.mas_equalTo(DDDScale_Height(47));
        make.centerX.equalTo(_bottomBgView);
        make.top.equalTo(_authorityContentView.mas_bottom).offset(DDDScale_Height(24));
    }];
    
    [_launchSubTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_bottomBgView).offset(-DDDBOTTOM_HEIGHT -DDDScale_Height(4));
        make.height.mas_equalTo(DDDScale_Height(16));
        make.centerX.equalTo(_bottomBgView);
        make.top.equalTo(_launchGameButton.mas_bottom).offset(DDDScale_Height(8));
    }];
    
    [_authorityCourseView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self);
        make.height.mas_equalTo(DDDScale_Height(580));
        make.bottom.equalTo(@(DDDScale_Height(580)));
    }];
    
    [_launchGameButton gradientColorWithColors:@[[UIColor colorWithHex:@"#FF467B"],[UIColor colorWithHex:@"#FF334B"]] withStartPoint:CGPointMake(0, 0) withEndPoint:CGPointMake(1, 1)];
    _launchGameButton.alpha = 0.3;
    [_launchGameButton setEnabled:NO];
    [_bottomBgView layoutIfNeeded];
    _contentHeight = CGRectGetHeight(_bottomBgView.bounds);
    [_bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(_contentHeight);
    }];
}

-(void)dismiss{
    
    [self dismissView:nil];
}

-(void)show{
    
    [self removeFromSuperview];
    [self addMainWindow];
    [self.superview layoutIfNeeded];
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 1;
        [self setHidden:NO];
        [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self);
        }];
    }];
}

-(void)courseViewDismiss{
    
    [UIView animateWithDuration:0.35 animations:^{
       
        [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self);
            
        }];
        
        [self.authorityCourseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self).offset(DDDScale_Height(580));
        }];
    }];
}
-(void)launchGame{
    
    [self dismissView:^{
       
        self.launchGameBlock != nil ? self.launchGameBlock() : nil;
    }];
}
-(void)dismissView:(void(^)(void))block{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        self.alpha = 0;
        [self setHidden:YES];
    } completion:^(BOOL finished) {
       
        [self removeFromSuperview];
        
        block != nil ?block() : nil;
    }];
}
-(void)jumpCourseAction{
    
    [UIView animateWithDuration:0.35 animations:^{
        
        [self.bottomBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.equalTo(self).offset(self.contentHeight);
        }];
        
        [self.authorityCourseView mas_updateConstraints:^(MASConstraintMaker *make) {
           
            make.bottom.equalTo(self);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        
        [self.authorityCourseView setUrl:@"http://video.zuhaowan.com/video/gameShsmVideo/2023-07-13/64af7cb1bbe8f.mp4"];
    }];
}
-(void)switchActionValueChanged{
    
    AVAudioSession * session = [AVAudioSession sharedInstance];
    switch (session.recordPermission) {
        case AVAudioSessionRecordPermissionDenied:
            [self.authorityMicroSwitch setOn:NO];
            [self goToSetting];
            break;
        case AVAudioSessionRecordPermissionUndetermined:
        {
            [self.authorityMicroSwitch setOn:NO];
            [session requestRecordPermission:^(BOOL granted) {
                
                if (granted == NO){
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        DDDToast(@"麦克风权限未开启");
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self authorityViewChanged: YES];
                });
            }];
        }
            break;
        case AVAudioSessionRecordPermissionGranted:
            [self authorityViewChanged: YES];
            break;
        default:
           
            break;
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_bottomBgView]){
        
        return  false;
    }
    if ([touch.view isDescendantOfView:_authorityCourseView]){
        
        return  false;
    }
    
    return  true;
}
@end



@interface SWLGAuthorityCourseView()

@property(nonatomic,strong)UILabel*courseTitleLabel;
@property(nonatomic,strong)UIButton *courseConfirmButton;
@property(nonatomic,strong)UIView * playerView;
@property(nonatomic,strong)AVPlayerLayer*videoPlayerLayer;
@property(nonatomic,strong)UIImageView*videoPlaceholderImage;
@end

@implementation SWLGAuthorityCourseView

-(void)setUrl:(NSString *)url{
    
    AVPlayer * player = [[AVPlayer alloc] initWithURL:[NSURL URLWithString:url]];
    [player addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:NULL];
    self.videoPlayerLayer.player = player;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame: frame];
    
    self.backgroundColor = [UIColor colorWithHex:@""];
    self.layer.cornerRadius = 17;
    self.layer.maskedCorners = kCALayerMinXMinYCorner |kCALayerMaxXMinYCorner;
    [self uiConfigure];
    [self myAutoLayout];
    return  self;
}

-(void)uiConfigure{
    
    [self addSubview: self.courseTitleLabel];
    [self addSubview:self.courseConfirmButton];
    [self addSubview:self.playerView];
    [self.playerView.layer addSublayer:self.videoPlayerLayer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}
-(void)myAutoLayout{
    
    [self.courseTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
        make.height.equalTo(@(DDDScale_Height(47)));
        make.top.equalTo(self).offset(DDDScale_Height(16));
        make.centerX.equalTo(self);
    }];
    [self.courseConfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.equalTo(@(DDDScale_Height(47)));
        make.width.equalTo(@(DDDScale_Height(164)));
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-DDDBOTTOM_HEIGHT -DDDScale_Height(26));
    }];
    
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(DDDScale_Width(16));
        make.right.equalTo(self).offset(-DDDScale_Width(16));
        make.top.equalTo(self).offset(DDDScale_Height(57));
        make.bottom.equalTo(_courseConfirmButton.mas_top).offset(-DDDScale_Height(16));
    }];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.videoPlayerLayer.frame = self.playerView.bounds;
}


-(UILabel *)courseTitleLabel{
    
    if(_courseTitleLabel == nil){
        
        _courseTitleLabel = [[UILabel alloc] init];
        _courseTitleLabel.text = @"悬浮窗权限开启引导";
        _courseTitleLabel.font = [UIFont fontWithSize:18 withAlias:FontAlispfSemibold];
        _courseTitleLabel.textColor = [UIColor colorWithHex:@"#222222"];
    }
    
    return _courseTitleLabel;
}

-(UIButton *)courseConfirmButton{
    
    if(_courseConfirmButton == nil){
        
        _courseConfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_courseConfirmButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [_courseConfirmButton setTitleColor:[UIColor colorWithHex:@"#F6194F"] forState:UIControlStateNormal];
        [_courseConfirmButton addTarget:self action:@selector(confirmAction) forControlEvents:UIControlEventTouchUpInside];
        _courseConfirmButton.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
        _courseConfirmButton.titleLabel.font = [UIFont fontWithSize:16 withAlias:FontAlispfMedium];
        _courseConfirmButton.layer.borderWidth = 0.8;
        _courseConfirmButton.layer.borderColor = [UIColor colorWithHex:@"#FF1E54"].CGColor;
        _courseConfirmButton.layer.cornerRadius = DDDScale_Height(47/2);
    }
    
    return _courseConfirmButton;
}

-(UIView *)playerView{
    
    if(_playerView == nil){
        
        _playerView = [[UIView alloc] initWithFrame:CGRectZero];
        _playerView.backgroundColor = [UIColor colorWithHex:@"#FFFFFF"];
    }
    
    return _playerView;
}

-(AVPlayerLayer *)videoPlayerLayer{
    
    if(_videoPlayerLayer == nil){
        
        _videoPlayerLayer = [AVPlayerLayer layer];
    }
    
    return _videoPlayerLayer;
}


-(void)confirmAction{
    
    [_videoPlayerLayer.player pause];
    _videoPlayerLayer.player = nil;
    self.confirmBlock != nil ? self.confirmBlock() : nil;
}




-(void)videoPlayEnd{
    
    if (_videoPlayerLayer.player  == nil){return;}
    
    [_videoPlayerLayer.player.currentItem seekToTime:kCMTimeZero completionHandler:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self play];
    });
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]){
        
        if ([change[NSKeyValueChangeNewKey] intValue] == 1){
         
            [self.videoPlayerLayer.player play];
        }
    }
}


-(void)play{
    
    if (_videoPlayerLayer.player  == nil){return;}
    
    [_videoPlayerLayer.player play];
}

@end
