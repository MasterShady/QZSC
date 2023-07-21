//
//  QZSCfootprintViewController.m
//  QZSC
//
//  Created by lsy on 2023/7/19.
//

#import "QZSCfootprintViewController.h"
#import "Masonry.h"
#import "CommonDefine.h"
#import "MJRefresh.h"
#import "QZSC-Swift.h"
#import "QZSCControllerManager.h"
#import "UIDevice+Addition.h"
#import "NetWorkManager.h"
#import "YYModel.h"
@interface QZSCfootprintViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *table;
//@property(nonatomic, strong) NSArray<QZSCProductListModel *> *dataList;

@end

@implementation QZSCfootprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"足迹";
    [self setUI];
    [NetWorkManager postWithUrlString:@"/qzsc/userFootprint" parameters:@{@"day_type":@"0"} complete:^(NetWorkCommonObject * _Nonnull object) {
        if (object.state == NetWork_Success) {
            QZSCProductListModel *userInfo = [QZSCProductListModel yy_modelWithJSON:object.data];
            
            
        } else {
           
        }
    }];
    
    // Do any additional setup after loading the view.
}

- (void)setUI {
   
    _table = [[UITableView alloc] initWithFrame:CGRectMake(KNavBarFullHight, 0, kScreenWidth, kScreenHeight - KNavBarFullHight) style:UITableViewStylePlain];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.rowHeight = 128;
    _table.showsVerticalScrollIndicator = NO;
    _table.showsHorizontalScrollIndicator = NO;
    [_table registerClass:[QZSCHomeListCell class] forCellReuseIdentifier:NSStringFromClass([QZSCHomeListCell class])];
    _table.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(KNavBarFullHight);
        make.left.right.bottom.mas_equalTo(0);
    }];
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
       
    }];
}





#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSCHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QZSCHomeListCell class])];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
