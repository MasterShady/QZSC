//
//  QZSCGoodsListController.swift
//  QZSC
//
//  Created by zzk on 2023/7/17.
//

import UIKit
import MJRefresh

class QZSCGoodsListController: QZSCBaseController {
    
    var isCategory: Bool = true // true 分类; false 专区
    var dataList = [QZSCProductListModel]()
    
    @objc var isFromSearch: Bool = false
    
    private var key: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
        UMProgressManager.showLoadingAnimation()
        loadData()
    }
    
    func configUI() {
        view.backgroundColor = COLORF6F8FA
        let topBgImgView = UIImageView()
        topBgImgView.contentMode = .scaleAspectFill
        view.addSubview(topBgImgView)
        topBgImgView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(0)
            make.height.equalTo(kScaleBasicWidth(342))
        }
        
        let gradientView = UIView()
        gradientView.layer.cornerRadius = 12
        gradientView.layer.masksToBounds = true
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight + 80)
            make.leading.trailing.bottom.equalTo(0)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavBarFullHeight - 42)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [COLOR97FFF0.cgColor, COLORF6F8FA.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        if isCategory {
            navTitle = "分类名称"
            topBgImgView.image = UIImage(named: "category_top_bg")
            gradientView.isHidden = true
        } else {
            navTitle = "专区名称"
            topBgImgView.image = UIImage(named: "topic_top_bg")
        }
        
        navBar.isHidden = isFromSearch
        topBgImgView.isHidden = isFromSearch
        gradientView.isHidden = isFromSearch
        
        view.addSubview(table)
        let originY = (isFromSearch ? 0 : kNavBarFullHeight)
        table.snp.makeConstraints { make in
            make.top.equalTo(originY)
            make.bottom.leading.trailing.equalTo(0)
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
        QZSCHomeViewModel.loadHomeProductList(keyWord: key) { list in
            UMProgressManager.hide()
            self.dataList = list
            self.table.mj_footer?.isHidden = (list.count != 20)
            self.table.mj_header?.endRefreshing()
            self.table.reloadData()
            self.configNoData()
        }
    }
    
    @objc func loadDataWith(keyWord: String) {
        key = keyWord
        QZSCHomeViewModel.loadHomeProductList(keyWord: keyWord) { list in
            UMProgressManager.hide()
            self.dataList = list
            self.table.mj_footer?.isHidden = (list.count != 20)
            self.table.mj_header?.endRefreshing()
            self.table.reloadData()
            self.configNoData()
        }
    }
    
    func configNoData() {
        if self.dataList.count > 0 {
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
        table.backgroundColor = .clear
        return table
    }()
}

extension QZSCGoodsListController: UITableViewDelegate, UITableViewDataSource {
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
