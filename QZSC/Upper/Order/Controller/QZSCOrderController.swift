//
//  QZSCOrderController.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import UIKit
import JXSegmentedView
class QZSCOrderController: QZSCBaseController {
    private let sectionItems = ["全部","待付款","租赁中","已完成"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "FFFFFF")
        
        self.navTitle = "租赁订单"
        mian()
        
    }

    func mian(){
        view.addSubview(segmentedV)
         view.addSubview(listContainerView)
        segmentedDS.titles = sectionItems
        segmentedV.dataSource = segmentedDS
        segmentedV.listContainer = listContainerView
        segmentedV.defaultSelectedIndex = 0
        segmentedV.reloadData()
     
    }
    lazy var listContainerView: JXSegmentedListContainerView = {
          let lv = JXSegmentedListContainerView(dataSource: self)
          lv.frame = CGRect(x: 0, y:NAV_HEIGHT + SCALE_HEIGTHS(value: 35) , width: SCREEN_WIDTH, height: SCREEN_HEIGHT - NAV_HEIGHT - SCALE_HEIGTHS(value: 50) - TABLEBAR_HEIGHT)
          return lv
    }()
    private lazy var segmentedV: JXSegmentedView = {
        let segment = JXSegmentedView(frame: CGRect(x: 0, y: NAV_HEIGHT, width: SCREEN_WIDTH, height: SCALE_HEIGTHS(value: 35)))
           segment.backgroundColor = .clear
           segment.indicators = [sliderView]
           return segment
       }()
    private lazy var segmentedDS: JXSegmentedTitleDataSource = {
            let source = JXSegmentedTitleDataSource()
        source.titleNormalFont = UIFont.systemFont(ofSize: 13, weight: .regular)
        source.titleSelectedFont = UIFont.systemFont(ofSize: 15, weight: .semibold)
                source.titleNormalColor = UIColor(hexString: "A1A0AB")
                source.titleSelectedColor = UIColor(hexString: "333333")
            return source
        }()
    
    lazy var sliderView: JXSegmentedIndicatorLineView = {
           let view = JXSegmentedIndicatorLineView()
           view.indicatorColor = UIColor(hexString: "FF1E54")//横线颜色
           view.indicatorWidth = 14 //横线宽度
           view.indicatorHeight = 3 //横线高度
           view.verticalOffset = 0 //垂直方向偏移
        view.indicatorCornerRadius = 2
           return view
    }()
    

}

extension QZSCOrderController: JXSegmentedListContainerViewDataSource {
    //MARK: JXSegmentedViewDelegate
       //点击标题 或者左右滑动都会走这个代理方法
       func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
           //这里处理左右滑动或者点击标题的事件
           
       }
       //MARK:JXSegmentedListContainerViewDataSource
       func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
           sectionItems.count
       }
       
       func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
//           let vc = MineMarginViewController()
//           return vc as! JXSegmentedListContainerViewListDelegate
           if index == 0 {
               let vc = QZSCOrderAllViewController()
               return vc
           }
           else if index == 1 {
               let vc = QZSCOrderAllViewController()
               return vc
           }
           else if index == 2 {
               let vc = QZSCOrderAllViewController()
               return vc
           }
          
           else {
               let vc = QZSCOrderAllViewController()
               return vc
           }
       }

}
