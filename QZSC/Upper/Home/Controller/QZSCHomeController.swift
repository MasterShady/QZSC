//
//  QZSCHomeController.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import UIKit
import MJRefresh
import Alamofire

class QZSCHomeController: QZSCBaseController {
    
    var dataList = [QZSCProductListModel]()
    private let manager = NetworkReachabilityManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
        listenerNetWork()
    }
    
    func configUI() {
        view.backgroundColor = COLORF6F8FA
        navBar.isHidden = true
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(-kTabbarHeight())
        }
        
        table.mj_header = MJRefreshNormalHeader(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.loadData()
        })
        table.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: { [weak self] in
            guard let `self` = self else { return }
            self.table.mj_footer?.endRefreshingWithNoMoreData()
        })
        table.mj_footer?.isHidden = true
    }
    
    func loadData() {
        QZSCHomeViewModel.loadHomeProductList { list in
            UMProgressManager.hide()
            self.dataList = list
            self.table.mj_footer?.isHidden = (list.count != 20)
            self.table.mj_header?.endRefreshing()
            self.configNoData()
            self.table.reloadData()
        }
    }
    
    func configNoData() {
        if self.dataList.count > 0 {
            self.table.hideStatus()
        } else {
            self.table.showStatus(.noData, offset: CGPoint(x: 0, y: 100))
        }
    }
    
    func listenerNetWork() {
        manager?.startListening(onUpdatePerforming: {[weak self] stute in
            switch stute {
            case .unknown:
                printLog("========= unknown")
            case .notReachable:
                break
            case .reachable(_):
                UMProgressManager.showLoadingAnimation()
                self?.loadData()
                printLog("========= reachable")
            }
        })
    }

    // MARK: - lazy
    lazy var table: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.rowHeight = 128
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.register(QZSCHomeListCell.self)
        table.contentInsetAdjustmentBehavior = .never
        table.tableHeaderView = headerView
        table.backgroundColor = .clear
        return table
    }()

    lazy var headerView: QZSCHomeHeaderView = {
        let h = 336 + kStatusBarHeight
        let header = QZSCHomeHeaderView(frame: CGRectMake(0, 0, kScreenWidth, h))
        return header
    }()
}

extension QZSCHomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(QZSCHomeListCell.self)
        cell.data = dataList[safety: indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctl = QZSCGoodsDetailsController()
        ctl.produceId = dataList[indexPath.row].id
        QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
    }
}
