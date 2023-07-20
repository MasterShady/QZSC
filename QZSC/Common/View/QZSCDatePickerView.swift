//
//  QZSCDatePickerView.swift
//  QZSC
//
//  Created by zzk on 2023/2/21.
//

import UIKit
import RxCocoa
import RxSwift

class QZSCDatePickerView: UIView {

    private let disBag = DisposeBag()
    private let contentVH: CGFloat = kStatusBarHeight + 310
    
    var defaultDate: Date? {
        didSet {
            if let date = defaultDate {
                picker.setDate(date, animated: false)
            }
        }
    }
    
    var minDate: Date? {
        didSet {
            picker.minimumDate = minDate
        }
    }
    
    var maxDate: Date? {
        didSet {
            picker.maximumDate = maxDate
        }
    }
    
    var dateMode: UIDatePicker.Mode = .date {
        didSet {
            picker.datePickerMode = dateMode
        }
    }
    
    var sureComplete: ((Date) -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .clear
        
        addSubview(bgV)
        addSubview(contentV)
        contentV.addSubview(cancelBtn)
        contentV.addSubview(sureBtn)
        contentV.addSubview(tipsL)
        contentV.addSubview(picker)
        
        bgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentV.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(contentVH)
        }
        cancelBtn.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(80)
        }
        sureBtn.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.width.height.centerY.equalTo(cancelBtn)
        }
        tipsL.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(cancelBtn)
            make.left.lessThanOrEqualTo(cancelBtn.snp.right).offset(10)
            make.right.lessThanOrEqualTo(sureBtn.snp.left).offset(-10)
        }
        picker.snp.makeConstraints { make in
            make.top.equalTo(cancelBtn.snp.bottom)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(0)
        }
        
        cancelBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.dismissAnimation()
        }.disposed(by: disBag)
        sureBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.sureComplete?(self.picker.date)
            self.dismissAnimation()
        }.disposed(by: disBag)
    }
    
    func showAnimation() {
        bgV.alpha = 0
        contentV.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: contentVH)
        UIView.animate(withDuration: 0.5) {
            self.bgV.alpha = 0.6
            self.contentV.frame = CGRect(x: 0, y: kScreenHeight - self.contentVH, width: kScreenWidth, height: self.contentVH)
        }
    }
    
    func dismissAnimation() {
        bgV.alpha = 0
        UIView.animate(withDuration: 0.2) {
            self.contentV.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: self.contentVH)
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
    
    // MARK: - Override
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let roundLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 16, height: 16))
        roundLayer.path = path.cgPath
        contentV.layer.mask = roundLayer
    }

    // MARK: - lazy
    private lazy var bgV: UIView = {
        let bgV = UIView()
        bgV.backgroundColor = COLOR000000
        bgV.alpha = 0.6
        return bgV
    }()
    
    private lazy var contentV: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var tipsL: UILabel = {
        let lbl = UILabel()
        lbl.text = "请选择日期"
        lbl.textColor = COLORA1A0AB
        lbl.font = UIFont.normal(16)
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(COLOR999999, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("确定", for: .normal)
        btn.setTitleColor(COLOR333333, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()

    private lazy var picker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.locale = .init(identifier: "zh_CN")
        if #available(iOS 13.4, *) {
            picker.preferredDatePickerStyle = .wheels
        }
        return picker
    }()
}
