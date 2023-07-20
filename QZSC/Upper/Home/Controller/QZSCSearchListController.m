//
//  QZSCSearchListController.m
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

#import "QZSCSearchListController.h"
#import "QZSC-Swift.h"

@interface QZSCSearchListController ()<UITableViewDelegate, UITableViewDataSource, QZSCNormalSearchBarDelegate>

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) QZSCNormalSearchBar *searchBar;
@property(nonatomic, strong) QZSCGoodsListController *ctl;

@end

@implementation QZSCSearchListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavBar];
    [self setUI];
}

- (void)setNavBar {
    UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
    [back setImage:kImageName(@"back_arrow") forState:UIControlStateNormal];
    if (@available(iOS 15.0, *)) {
        UIButtonConfiguration *config = [UIButtonConfiguration plainButtonConfiguration];
        config.contentInsets = NSDirectionalEdgeInsetsMake(9, 14, 9, 4);
        back.configuration = config;
    } else {
        back.imageEdgeInsets = UIEdgeInsetsMake(9, 14, 9, 4);
    }
    [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kStatusBarHight);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(44);
        make.width.mas_equalTo(40);
    }];
    
    QZSCNormalSearchBar *searchBar = [[QZSCNormalSearchBar alloc] initWithFrame:CGRectZero];
    searchBar.placeHolder = @"请输入关键字~";
    searchBar.delegate = self;
    [self.view addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(back.mas_right).offset(10);
        make.centerY.equalTo(back);
        make.right.mas_equalTo(-16);
        make.height.mas_equalTo(34);
    }];
    _searchBar = searchBar;
}

- (void)setUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    _ctl = [[QZSCGoodsListController alloc] init];
    _ctl.isFromSearch = YES;
    _ctl.view.frame = CGRectMake(0, KNavBarFullHight, kScreenWidth, kScreenHeight - KNavBarFullHight);
    [self addChildViewController:_ctl];
    [self.view addSubview:_ctl.view];
    [_ctl didMoveToParentViewController:self];
}


- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidEndEditing:(QZSCNormalSearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
    [_ctl loadDataWithKeyWord:searchBar.text];
}



@end
