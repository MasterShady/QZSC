//
//  QZSCOrderAllViewController.swift
//  QZSC
//
//  Created by lsy on 2023/7/18.
//

import UIKit
import JXPagingView
import JXSegmentedView
import MJRefresh
class QZSCOrderAllViewController: UIViewController {
    var scrollCallBack: ((UIScrollView) -> ())?
    var TitleString:String!
    var pageId = 1
    var topBgView:UIView!
    //    var dataList:[GEMJ_GameItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "F6F6F6")
        creatUI()
     
    }
   
    
//    func configNoData() {
//        if self.lists.count > 0 {
//            self.OrderAllTableView.hideStatus()
//        } else {
//            self.OrderAllTableView.showStatus(.noData)
//        }
//    }
    
    //创建UI
    private func creatUI() {
        
        
        view.addSubview(OrderAllTableView)
        OrderAllTableView.register(OrderCell.self, forCellReuseIdentifier: NSStringFromClass(OrderCell.self))
        
        OrderAllTableView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
    }
    lazy var OrderAllTableView:UITableView = {
        let OrderAllTableView = UITableView(frame: CGRect.zero, style: .plain)
        OrderAllTableView.backgroundColor = UIColor(hexString: "F6F6F6")
        OrderAllTableView.estimatedRowHeight = 0.0
        OrderAllTableView.estimatedSectionFooterHeight = 0.0
        OrderAllTableView.estimatedSectionHeaderHeight = 0.0
        OrderAllTableView.separatorStyle = .none
        OrderAllTableView.delegate = self
        OrderAllTableView.dataSource = self
        OrderAllTableView.backgroundColor = .clear
        if #available(iOS 15.0, *) {
            OrderAllTableView.sectionHeaderTopPadding = 0.0
        } else {
            // Fallback on earlier versions
        };
//        OrderAllTableView.emptyDataSetSource = self
//        OrderAllTableView.emptyDataSetDelegate = self
        OrderAllTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.OrderAllTableView.mj_header?.endRefreshing()
//            self.loadData()
        })
        OrderAllTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {  [unowned self] in
//            self.OrderAllTableView.mj_header?.endRefreshing()
//            self.OrderAllTableView.mj_footer?.endRefreshing()
            //            self.queryData(false, isMore: true)
        })
        return OrderAllTableView
    }()
    
}
    
extension QZSCOrderAllViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(OrderCell.self), for: indexPath) as! OrderCell
       
//        cell.data = lists[indexPath.row]
//        cell.rightBtn.addBlock(for: .touchUpInside) { _ in
//            let ctl = HomeDeviceDetailsVC()
//            ctl.device_Id = String(self.lists[indexPath.row].goods_info!.id)
//            ControllerUtils.currentNavVC()?.pushViewController(ctl, animated: true)
//        }
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCALE_HEIGTHS(value: 250.0)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = QZSCOrderDetailController()
//        VC.list = lists[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    
}



extension QZSCOrderAllViewController :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}
