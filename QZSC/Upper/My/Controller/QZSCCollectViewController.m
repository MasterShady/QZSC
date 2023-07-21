//
//  QZSCCollect ViewController.m
//  QZSC
//
//  Created by lsy on 2023/7/19.
//

#import "QZSCCollectViewController.h"
#import "Masonry.h"
#import "CommonDefine.h"
#import "MJRefresh.h"
#import "QZSC-Swift.h"
#import "QZSCControllerManager.h"
#import "UIDevice+Addition.h"
#import "NetWorkManager.h"
#import "YYModel.h"

@interface QZSCCollectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) NSArray<QZSCProductListModel *> *dataList;
@property(nonatomic, strong) UITableView *table;
@end

@implementation QZSCCollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navTitle = @"收藏";
    [self setUI];
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
    
    __weak typeof (self) weakSelf = self;
    _table.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf getCollectionList];
    }];
    
    [_table.mj_header beginRefreshing];
}




- (void)getCollectionList{
    __weak typeof (self) weakSelf = self;
    [NetWorkManager postWithUrlString:@"/qzsc/userCollect" parameters:@{} complete:^(NetWorkCommonObject * _Nonnull object) {
        if (object.state == NetWork_Success) {
            weakSelf.dataList = [NSArray yy_modelArrayWithClass:QZSCProductListModel.class json:object.data];
            [weakSelf.table reloadData];
        } else {
            
        }
        [weakSelf.table.mj_header endRefreshing];
    }];
    
}


#pragma mark - UITableViewDelegate, UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSCHomeListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QZSCHomeListCell class]) forIndexPath:indexPath];
    cell.data = self.dataList[indexPath.row];
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    QZSCProductListModel *model = self.dataList[indexPath.row];
    QZSCGoodsDetailsController *vc = [[QZSCGoodsDetailsController alloc] init];
    vc.produceId = model.id;
    [self.navigationController pushViewController:vc animated:true];
    
    
}

@end
