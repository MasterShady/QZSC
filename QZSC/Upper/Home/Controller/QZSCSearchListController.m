//
//  QZSCSearchListController.m
//  QZSC
//
//  Created by fanyebo on 2023/7/19.
//

#import "QZSCSearchListController.h"
#import "QZSC-Swift.h"

@interface QZSCSearchListController ()<UITableViewDelegate, UITableViewDataSource, QZSCNormalSearchBarDelegate>

@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) QZSCNormalSearchBar *searchBar;

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
    
    _table = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.rowHeight = 128;
    _table.showsVerticalScrollIndicator = NO;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_table registerClass:[QZSCHomeListCell self] forCellReuseIdentifier:NSStringFromClass([QZSCHomeListCell class])];
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNavBarFullHight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(kScreenHeight - KNavBarFullHight);
    }];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBarDidEndEditing:(QZSCNormalSearchBar *)searchBar {
    NSLog(@"%@", searchBar.text);
}

#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSCHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QZSCHomeListCell class]) forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSCGoodsDetailsController *ctl = [[QZSCGoodsDetailsController alloc] init];
    [self.navigationController pushViewController:ctl animated:YES];
}


@end
