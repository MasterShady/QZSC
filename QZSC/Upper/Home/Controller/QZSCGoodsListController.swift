//
//  QZSCGoodsListController.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/17.
//

import UIKit
import Alamofire

class QZSCGoodsListController: QZSCBaseController {
    
    var isCategory: Bool = true // true 分类; false 专区
    private let manager = NetworkReachabilityManager()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
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
        
        
        view.addSubview(table)
        table.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight)
            make.bottom.leading.trailing.equalTo(0)
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
                break
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
        table.backgroundColor = .clear
        return table
    }()
}

extension QZSCGoodsListController: UITableViewDelegate, UITableViewDataSource {
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
