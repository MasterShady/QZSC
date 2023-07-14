//
//  QZSCBaseController.swift
//  QZSC
//
//  Created by umer on 2022/6/13.
//  Copyright © 2022 UmerQs. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class QZSCBaseController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    var navTitle: String? {
        didSet {
            navTitleLbl?.text = navTitle
        }
    }
    
    var navTitleLbl: UILabel? { // 导航栏标题
        willSet {
            if let lbl = newValue {
                navTitleLbl?.removeFromSuperview()
                navBar.addSubview(lbl)
                lbl.snp.makeConstraints { make in
                    make.bottom.equalTo(0)
                    make.centerX.equalTo(navBar)
                    make.height.equalTo(kNavBarHeight)
                    make.width.equalTo(kScreenWidth - 90)
                }
            }
        }
    }
    
    var leftBtn: UIButton? { // 导航栏左侧按钮
        willSet {
            if let btn = newValue {
                leftBtn?.removeFromSuperview()
                navBar.addSubview(btn)
                btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.leftBtnClick()
                }).disposed(by: disposeBag)
                btn.snp.makeConstraints { make in
                    make.left.bottom.equalTo(0)
                    make.height.width.equalTo(kNavBarHeight)
                }
            }
        }
    }
    
    var rightBtn: UIButton? { // 导航栏右侧按钮
        willSet {
            if let btn = newValue {
                rightBtn?.removeFromSuperview()
                navBar.addSubview(btn)
                btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
                    guard let `self` = self else { return }
                    self.rightBtnClick()
                }).disposed(by: disposeBag)
                btn.snp.makeConstraints { make in
                    make.right.equalTo(-10)
                    make.bottom.equalTo(0)
                    make.height.width.equalTo(kNavBarHeight)
                }
            }
        }
    }
    
    // 通用回调刷新
    var complete: ((Any?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
        setNavBarUI()
    }
    
    // 自定义导航栏样式按钮，可重写该方法
    func setNavBarUI() {
        view.addSubview(navBar)
        navBar.snp.makeConstraints { make in
            make.top.left.right.equalTo(0)
            make.height.equalTo(kNavBarFullHeight)
        }
        
        if isPushed && !isRootOfNavigation { // ture：是push出来的ctl
            leftBtn = UIButton(type: .custom)
            leftBtn?.setImage(UIImage(named: "nav_back_black"), for: .normal)
            if #available(iOS 15.0, *) {
                var config = UIButton.Configuration.plain()
                config.imagePlacement = .trailing
                config.contentInsets = .init(top: 9, leading: 17, bottom: 9, trailing: 1)
                leftBtn?.configuration = config
            } else {
                leftBtn?.imageEdgeInsets = UIEdgeInsets.init(top: 9, left: 17, bottom: 9, right: 1)
            }
        }
        
        navTitleLbl = UILabel()
        navTitleLbl?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        navTitleLbl?.textColor = COLOR333333
        navTitleLbl?.textAlignment = .center
    }
    
    // 隐藏导航栏
    func hideNavBar() {
        navBar.isHidden = true
    }
    
    // MARK: - Override
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.bringSubviewToFront(navBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - click
    func leftBtnClick() { // 点击返回，可重写该方法
        if isPushed {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func rightBtnClick() {
        
    }

    // MARK: - lazy
    lazy var navBar: UIView = {
        let content = UIView()
        content.backgroundColor = .white
        return content
    }()
}
