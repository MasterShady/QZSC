//
//  QZSCBaseVC.m
//  QZSC
//
//  Created by lsy on 2023/7/19.
//

#import "QZSCBaseVC.h"
#import "Masonry.h"
#import "UIColor+Hex.h"
#import "UIViewController+Tool.h"
#import "CommonDefine.h"
#import "UIDevice+Addition.h"
#import "QZSCControllerManager.h"
@interface QZSCBaseVC ()

@property(nonatomic, strong) UILabel *navTitleL;
@property(nonatomic, strong) UIButton *backBtn;

@end


@implementation QZSCBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBaseControllerUI];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    [self.view bringSubviewToFront:self.customNavBar];
}

- (void)setBaseControllerUI {
    self.view.backgroundColor = [UIColor colorWithHexString: @"#FFFFFF"];
    
    self.backBtn.hidden = !(self.isPushed && !self.isRootNavigation);
    
    [self.view addSubview:self.customNavBar];
    [self.customNavBar addSubview:self.backBtn];
    [self.customNavBar addSubview:self.navTitleL];
    
    [self.customNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self.view);
        make.height.mas_equalTo(KNavBarFullHight);
    }];
    [self.navTitleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-10);
        make.centerX.equalTo(self.customNavBar);
        make.width.mas_lessThanOrEqualTo(kScreenWidth - 100);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(self.customNavBar);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(40);
    }];
    
   
    
    [self.backBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBtnClick {
    [[QZSCControllerManager currentNavVC] popViewControllerAnimated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return false;
}

#pragma mark - lazy
- (void)setHidenBar:(BOOL)hidenBar {
    _hidenBar = hidenBar;
    self.customNavBar.hidden = hidenBar;
}

- (void)setHidenTitleL:(BOOL)hidenTitleL {
    _hidenTitleL = hidenTitleL;
    self.navTitleL.hidden = hidenTitleL;
}

- (void)setNavTitle:(NSString *)navTitle {
    self.navTitleL.text = navTitle;
}

- (void)setBackBtnImg:(UIImage *)backBtnImg {
    _backBtnImg = backBtnImg;
    [self.backBtn setImage:backBtnImg forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    self.navTitleL.textColor = titleColor;
}

- (UIView *)customNavBar {
    if (!_customNavBar) {
        _customNavBar = [[UIView alloc] init];
        _customNavBar.backgroundColor = [UIColor colorWithHexString: @"#FFFFFF"];
    }
    return _customNavBar;
}

- (UILabel *)navTitleL {
    if (!_navTitleL) {
        _navTitleL = [UILabel new];
        _navTitleL.textAlignment = NSTextAlignmentCenter;
        _navTitleL.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _navTitleL.textColor = [UIColor colorWithHexString: @"#333333"];
    }
    return _navTitleL;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:kImageName(@"back_arrow") forState:UIControlStateNormal];
        if (@available(iOS 15.0, *)) {
            UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
            config.contentInsets = NSDirectionalEdgeInsetsMake(9, 14, 9, 4);
            _backBtn.configuration = config;
        } else {
            _backBtn.imageEdgeInsets = UIEdgeInsetsMake(9, 14, 9, 4);
        }
    }
    return _backBtn;
}

@end
