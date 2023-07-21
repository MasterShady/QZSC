//
//  QZSCHomeHeaderView.swift
//  QZSC
//
//  Created by zzk on 2023/7/17.
//

import UIKit
import RxCocoa
import RxSwift

class QZSCHomeHeaderView: UIView {
    
    let categoryTitles = ["好物种草·", "好物种草·", "好物种草·", "好物种草·"]
    let dBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configUI()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData() {
        let originSX = 16
        for (i, title) in categoryTitles.enumerated() {
            let view = UIView()
            view.backgroundColor = COLORFFFFFF
            view.layer.cornerRadius = 8
            view.layer.masksToBounds = true
            let originX = originSX + (140 + 8) * i
            view.frame = CGRectMake(CGFloat(originX), 0, 140, 46)
            scroll.addSubview(view)
            let lbl = UILabel.createSameLbl(text: title, color: COLOR333333, font: UIFont.semibold(14))
            view.addSubview(lbl)
            lbl.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            let dot = UIView()
            dot.layer.borderWidth = 1.5
            dot.layer.borderColor = COLOR000000.cgColor
            dot.backgroundColor = .white
            dot.layer.cornerRadius = 2
            dot.layer.masksToBounds = true
            view.addSubview(dot)
            dot.snp.makeConstraints { make in
                make.bottom.equalTo(lbl.snp.top).offset(-2)
                make.right.equalTo(lbl.snp.left).offset(-2)
                make.width.height.equalTo(4)
            }
            let tap = UITapGestureRecognizer()
            view.addGestureRecognizer(tap)
            tap.rx.event.subscribe { _ in
                let ctl = QZSCGoodsListController()
                QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
            }.disposed(by: dBag)
        }
        
        let contentW = 16 + (140 + 8) * categoryTitles.count
        let maxW = max(Int(kScreenWidth) - 16 + 1, contentW + 1)
        scroll.contentSize = CGSize(width: maxW, height: 46)
    }
    
    func configUI() {
        let bgImgView = UIImageView(image: UIImage(named: "home_top_bg"))
        bgImgView.isUserInteractionEnabled = true
        addSubview(bgImgView)
        bgImgView.snp.makeConstraints { make in
            make.top.trailing.leading.equalTo(0)
            make.height.equalTo(342)
        }
        
        let titleLbl = UILabel.createSameLbl(text: kAppName, color: COLOR333333, font: UIFont.semibold(28))
        addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(kStatusBarHeight + 10)
        }
        
        let searchTF = UITextField()
        searchTF.delegate = self
        searchTF.backgroundColor = COLORFFFFFF
        searchTF.layer.cornerRadius = 16
        searchTF.layer.masksToBounds = true
        let placeholder = NSAttributedString(string: "搜索一些你喜欢的东西吧～", attributes: [NSAttributedString.Key.foregroundColor: COLORAFAFAF, NSAttributedString.Key.font: UIFont.normal(12)])
        searchTF.attributedPlaceholder = placeholder
        searchTF.leftViewMode = .always
        searchTF.rightViewMode = .always
        let leftView = UIView(frame: CGRectMake(0, 0, 44, 32))
        let searchImgView = UIImageView(image: UIImage(named: "home_search"))
        searchImgView.frame = CGRect(x: 16, y: 6, width: 21, height: 21)
        leftView.addSubview(searchImgView)
        searchTF.leftView = leftView
        let rightView = UIView(frame: CGRectMake(0, 0, 60, 32))
        let searchBtn = UIButton(type: .custom)
        searchBtn.frame = CGRect(x: 4, y: 2, width: 56, height: 28)
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.setTitleColor(COLORFFFFFF, for: .normal)
        searchBtn.isUserInteractionEnabled = false
        searchBtn.backgroundColor = COLOR333333
        searchBtn.layer.cornerRadius = 14
        searchBtn.layer.masksToBounds = true
        searchBtn.titleLabel?.font = UIFont.semibold(12)
        rightView.addSubview(searchBtn)
        searchTF.rightView = rightView
        addSubview(searchTF)
        searchTF.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(10)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(32)
        }
        let searchTap = UITapGestureRecognizer()
        searchTF.addGestureRecognizer(searchTap)
        searchTap.rx.event.subscribe { _ in
            let ctl = QZSCSearchListController()
            QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        }.disposed(by: dBag)
        
        let leftImgView = UIImageView(image: UIImage(named: "home_top_msxp"))
        leftImgView.isUserInteractionEnabled = true
        addSubview(leftImgView)
        leftImgView.snp.makeConstraints { make in
            make.top.equalTo(searchTF.snp.bottom).offset(8)
            make.left.equalTo(searchTF)
            make.width.equalTo(168)
            make.height.equalTo(128)
        }
        let leftTap = UITapGestureRecognizer()
        leftImgView.addGestureRecognizer(leftTap)
        leftTap.rx.event.subscribe { _ in
            let ctl = QZSCGoodsListController()
            ctl.isCategory = false
            ctl.navTitle = "秒杀新品"
            QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        }.disposed(by: dBag)
        
        let rtImgView = UIImageView(image: UIImage(named: "home_top_xpbp"))
        rtImgView.isUserInteractionEnabled = true
        addSubview(rtImgView)
        rtImgView.snp.makeConstraints { make in
            make.top.equalTo(leftImgView).offset(8)
            make.right.equalTo(-16)
            make.width.equalTo(168)
            make.height.equalTo(56)
        }
        let rtImgTap = UITapGestureRecognizer()
        rtImgView.addGestureRecognizer(rtImgTap)
        rtImgTap.rx.event.subscribe { _ in
            let ctl = QZSCGoodsListController()
            ctl.isCategory = false
            ctl.navTitle = "新品爆品"
            QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        }.disposed(by: dBag)
        
        let rbImgView = UIImageView(image: UIImage(named: "home_top_dbfl"))
        rbImgView.isUserInteractionEnabled = true
        addSubview(rbImgView)
        rbImgView.snp.makeConstraints { make in
            make.top.equalTo(rtImgView.snp.bottom).offset(kScaleBasicWidth(8))
            make.right.width.height.equalTo(rtImgView)
        }
        let rbImgTap = UITapGestureRecognizer()
        rbImgView.addGestureRecognizer(rbImgTap)
        rbImgTap.rx.event.subscribe { _ in
            let ctl = QZSCGoodsListController()
            ctl.isCategory = false
            ctl.navTitle = "多爆福利"
            QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        }.disposed(by: dBag)
        
        addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.equalTo(leftImgView.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 16)
            make.height.equalTo(46)
        }
        
        let firstNumLbl = UILabel.createSameLbl(text: "人气NO.1", color: COLOR000000, font: UIFont.semibold(16))
        addSubview(firstNumLbl)
        firstNumLbl.snp.makeConstraints { make in
            make.left.equalTo(24)
            make.top.equalTo(scroll.snp.bottom).offset(20)
        }
    }
    
    // MARK: - lazy
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        return scroll
    }()
}

extension QZSCHomeHeaderView: UITextFieldDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
