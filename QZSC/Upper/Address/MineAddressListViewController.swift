

import UIKit
import MJRefresh

class MineAddressListViewController: QZSCBaseController {
  
    var dataList:Array<AddressListModel> = []
    var pageId = 1
    
    var isFromConfirmVC: Bool = false
    var didSelectComplete: ((AddressListModel) -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.queryAddressList(isMore: true)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "我的地址"
        self.view.backgroundColor = UIColor(hexString: "#FFFFFF")
        AddressListTableView.register(MineAddressCell.self, forCellReuseIdentifier: NSStringFromClass(MineAddressCell.self))
        self.view.addSubview(AddressListTableView)
        AddressListTableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(NAV_HEIGHT)
        }
        
        let addressBtn = UIButton.init(frame: CGRect.zero)
        addressBtn.backgroundColor = UIColor(hexString: "#000000")
        addressBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 12)
        addressBtn.layer.masksToBounds = true
        addressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .semibold)
        addressBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        addressBtn.setTitle("新增收货地址", for: .normal)
        addressBtn.addTarget(self, action: #selector( addressBtnClickAction), for: .touchUpInside)
         
        self.view.addSubview(addressBtn);
        addressBtn.snp.makeConstraints { make in
             make.height.equalTo(SCALE_HEIGTHS(value: 48))
             make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.bottom.equalTo(-TABLEBAR_HEIGHT)
            make.centerX.equalToSuperview()
             
         }
        
        
    }
    
    
    lazy var AddressListTableView:UITableView = {
        let addressListTableView = UITableView(frame: CGRect.zero, style: .grouped)
        addressListTableView.estimatedRowHeight = 0.0
        addressListTableView.estimatedSectionFooterHeight = 0.0
        addressListTableView.estimatedSectionHeaderHeight = 0.0
        addressListTableView.separatorStyle = .none
        addressListTableView.delegate = self
        addressListTableView.dataSource = self
        addressListTableView.backgroundColor = .clear
        
        addressListTableView.mj_header = MJRefreshNormalHeader(refreshingBlock: { [unowned self] in
                        
            self.queryAddressList(isMore: true)
            
            
            
        })
//        addressListTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {  [unowned self] in
//            self.queryAddressList(isMore: true)
//
//        })
        return addressListTableView
    }()
    
    //新增收货地址
    @objc private func addressBtnClickAction() {
        let addressVC = MineAddressNewViewController()
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    
    
    func queryAddressList(isMore:Bool = false) {

        if isMore == false {

            pageId = 1

            AddressListTableView.mj_footer?.resetNoMoreData()
        }
        
        QZSCAddressViewModel.loadAddressList { data in
            self.AddressListTableView.mj_header?.endRefreshing()
            QZSCAddressManager.shared.defaultAddressModel = data.filter { $0.is_default == 1 }.first
            self.dataList = data
            self.AddressListTableView.reloadData()
            self.configNoData()
            self.AddressListTableView.reloadData()
        }

      
    }
    func configNoData() {
        if self.dataList.count > 0 {
            self.AddressListTableView.hideStatus()
        } else {
            self.AddressListTableView.showStatus(.noData, offset: CGPoint(x: 0, y: -100))
        }
    }
    
  
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MineAddressListViewController:UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:MineAddressCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MineAddressCell.self), for: indexPath) as! MineAddressCell
        cell.addressList = dataList[indexPath.row]
        cell.selectionStyle = .none
        cell.revampImage.tag = indexPath.row
        cell.revampImage.addTarget(self, action: #selector(revampBtnAction(btn:)), for: .touchUpInside)
        
        
        return cell
    }
    
    @objc func revampBtnAction(btn:UIButton){
        let addressVC = MineAddressNewViewController()
        addressVC.myCity = dataList[btn.tag].address_area
        addressVC.phone = dataList[btn.tag].phone
        addressVC.uname = dataList[btn.tag].uname
        addressVC.location_desc = dataList[btn.tag].address_area
        addressVC.is_default = dataList[btn.tag].is_default
        addressVC.uid = dataList[btn.tag].id
        self.navigationController?.pushViewController(addressVC, animated: true)
        
    }

   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SCALE_HEIGTHS(value: 80)
    }
        
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromConfirmVC {
            let data = dataList[indexPath.row]
            didSelectComplete?(data)
            QZSCControllerTool.currentNavVC()?.popViewController(animated: true)
            return
        }
        
        let data = self.dataList[indexPath.row]
        let DetailVC = MineAddressNewViewController()
        DetailVC.uid = data.uid
        DetailVC.uname = data.uname
        DetailVC.phone = data.phone
        DetailVC.address = data.address_area
        DetailVC.location_desc = data.address_detail
        DetailVC.is_default = data.is_default
        DetailVC.address_id = data.id
        self.navigationController?.pushViewController(DetailVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

            let deleteAction = UIContextualAction(style: .normal, title: "删除") { [weak self] (action, view, resultClosure) in
                guard self != nil else {
                    return
                }
                // 在这里实现删除的效果
                
                QZSCAddressViewModel.loadDelAddress(address_id: (self?.dataList[indexPath.row].id)!) { code in
                    if(code == true){
                        self?.queryAddressList(isMore: true)
                    }
                }
               
            }
            deleteAction.backgroundColor = .red
            let actions = UISwipeActionsConfiguration(actions: [deleteAction])
            actions.performsFirstActionWithFullSwipe = false; // 禁止侧滑到最左边触发删除回调事件
            return actions
        }
    
    
    
    
   
}
