//
//  QZSCLoginController.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/14.
//

import UIKit
import JXSegmentedView
class QZSCLoginController: QZSCBaseController {
    var BgView:UIImageView!
    private let LoginItems = ["账密登录","手机登录"]
    override func viewDidLoad() {
        super.viewDidLoad()
        MineUI()

        
    }
    
    func MineUI(){
        self.navBar.backgroundColor = UIColor.clear
        self.rightBtn?.setTitle("注册", for: .normal)
        self.rightBtn?.addTarget(self, action: #selector(registerClickAction), for: .touchUpInside)
    
        self.BgView = UIImageView(image: UIImage(named: "login_bg"))
        self.BgView.isUserInteractionEnabled = true
        self.view.addSubview(self.BgView)
        self.BgView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.BgView.addSubview(segmentedV)
        self.BgView.addSubview(listContainerView)
        segmentedDS.titles = LoginItems
        segmentedV.dataSource = segmentedDS
        segmentedV.listContainer = listContainerView
        //禁止容器页左右滑动
        listContainerView.scrollView.isScrollEnabled = false
        segmentedV.defaultSelectedIndex = 0
        
        segmentedV.reloadData()
    }
    
    
    
    @objc private func registerClickAction() {
        
        
        let RegisterVC = QZSCRegisterViewController()
        QZSCControllerTool.currentNavVC()?.pushViewController(RegisterVC, animated: true)
    }

    lazy var listContainerView: JXSegmentedListContainerView = {
          let lv = JXSegmentedListContainerView(dataSource: self)
          lv.backgroundColor = UIColor(hexString: "#FFFFFF")
        lv.layer.cornerRadius = SCALE_WIDTHS(value: 12)
        lv.layer.masksToBounds = true
          lv.frame = CGRect(x: SCALE_WIDTHS(value: 15), y:NAV_HEIGHT + SCALE_HEIGTHS(value: 90) , width: SCREEN_WIDTH - SCALE_WIDTHS(value: 30), height: SCREEN_HEIGHT - NAV_HEIGHT - SCALE_HEIGTHS(value: 90))
          return lv
    }()


    private lazy var segmentedV: JXSegmentedView = {
        let segment = JXSegmentedView(frame: CGRect(x: 0, y: NAV_HEIGHT + SCALE_HEIGTHS(value: 40), width: SCALE_WIDTHS(value: 220), height: SCALE_HEIGTHS(value: 35)))
           segment.backgroundColor = .clear
           return segment
       }()
    private lazy var segmentedDS: JXSegmentedTitleDataSource = {
            let source = JXSegmentedTitleDataSource()
                source.titleNormalFont = UIFont.systemFont(ofSize: 19, weight: .regular)
                source.titleSelectedFont = UIFont.systemFont(ofSize: 24, weight: .semibold)
                source.titleNormalColor = UIColor(hexString: "333333")
                source.titleSelectedColor = UIColor(hexString: "333333")
            return source
        }()
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension QZSCLoginController: JXSegmentedListContainerViewDataSource {
    //MARK: JXSegmentedViewDelegate
       //点击标题 或者左右滑动都会走这个代理方法
       func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
           //这里处理左右滑动或者点击标题的事件
           
       }
       //MARK:JXSegmentedListContainerViewDataSource
       func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
           LoginItems.count
       }
       
       func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
//           let vc = MineMarginViewController()
//           return vc as! JXSegmentedListContainerViewListDelegate
           if index == 0 {
               let vc = QZSCAccounTnumberView()
               return vc
           }
           else {
               let vc = QZSCPhoneLoginViewController()
               return vc
           }
       }

}
