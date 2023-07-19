//
//  QZSCHomeController.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/14.
//

import UIKit

class QZSCHomeController: QZSCBaseController {
    
    var lists = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
    }
    
    func configUI() {
        view.backgroundColor = COLORF6F8FA
        navBar.isHidden = true
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.bottom.equalTo(-kTabbarHeight())
        }
    }
    
    func configNoData() {
        if self.lists.count > 0 {
            self.table.hideStatus()
        } else {
            self.table.showStatus(.noData, offset: CGPoint(x: 0, y: -100))
        }
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(QZSCHomeListCell.self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctl = QZSCGoodsDetailsController()
        QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
    }
}
