//
//  QZSCOrderAccomplishVC.swift
//  QZSC
//
//  Created by LN C on 2023/7/21.
//

import UIKit
import JXPagingView
import JXSegmentedView
import MJRefresh
class QZSCOrderAccomplishVC: QZSCBaseVC {
    var scrollCallBack: ((UIScrollView) -> ())?
    var TitleString:String!
    var pageId = 1
    var topBgView:UIView!
    var dataList:Array<OrderListModel> = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "F6F6F6")
        creatUI()
        loadData()
     
    }
    func loadData(){
        if !QZSCLoginManager.shared.isLogin{
            self.OrderAllTableView.mj_header?.endRefreshing()
            self.dataList = []
            self.configNoData()
            self.OrderAllTableView.reloadData()
            return
        }
        QZSCOrderViewModel.loadOrderList(status: 2) { dataList in
            self.OrderAllTableView.mj_header?.endRefreshing()
            self.dataList = dataList
            self.configNoData()
            self.OrderAllTableView.reloadData()
            
        }
    }
   
    
    func configNoData() {
        if self.dataList.count > 0 {
            self.OrderAllTableView.hideStatus()
        } else {
            self.OrderAllTableView.showStatus(.noData)
        }
    }
    
    //创建UI
    private func creatUI() {
        view.addSubview(OrderAllTableView)
        OrderAllTableView.register(OrderCell.self, forCellReuseIdentifier: NSStringFromClass(OrderCell.self))
        
        OrderAllTableView.snp.makeConstraints { make in
            let topInset = self.hidenBar ? 0 : UIDevice.vg_navigationFullHeight()
            make.edges.equalTo(UIEdgeInsets(top:topInset , left: 0, bottom: 0, right: 0))
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
            
            self.loadData()
        })
//        OrderAllTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {  [unowned self] in
//            self.OrderAllTableView.mj_header?.endRefreshing()
//            self.OrderAllTableView.mj_footer?.endRefreshing()
//
//        })
        return OrderAllTableView
    }()
    
}
    
extension QZSCOrderAccomplishVC:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(OrderCell.self), for: indexPath) as! OrderCell
       
        cell.data = self.dataList[indexPath.row]
        cell.rightBtn.tag = indexPath.row
        cell.rightBtn.addTarget(self, action: #selector(rightBtnClick(btn:)), for: .touchUpInside)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCALE_HEIGTHS(value: 250.0)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let VC = QZSCOrderDetailController()
        VC.data = dataList[indexPath.row]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    //新增收货地址
    @objc private func rightBtnClick(btn:UIButton) {
        
        let alertController = UIAlertController(title: "", message: "确认取消订单?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "我再想想", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (ACTION) in
            QZSCOrderViewModel.loadOrderCancel(order_id: self.dataList[btn.tag].id) { code in
                if(code == true){
                    self.loadData()
                }
            }
        }
               alertController.addAction(cancelAction);
               alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
        
    }
}



extension QZSCOrderAccomplishVC :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
}
