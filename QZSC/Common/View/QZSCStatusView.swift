//
//  QZSCStatusView.swift
//  DF_MSZ
//
//  Created by fanyebo on 2022/12/21.
//

import UIKit
import CoreTelephony

public enum QZSCStatusType {
    case noData          // 通用 没有数据
    
    public var toast: String {
        switch self {
        case .noData:
            return "暂无管理动态，请先绑定账号"
        }
    }
    
    public var imageName: String {
        switch self {
        case .noData:
            return "no_empty"
        }
    }
}

public class QZSCStatusView: UIView {
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        networkState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public convenience init(_ superView: UIView) {
        self.init(frame: superView.bounds)
    }
    
    func addSubviews() {
        addSubview(imageV)
        addSubview(titleL)
        addSubview(setBtn)
        
        imageV.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.width.height.equalTo(120)
        }
        titleL.snp.makeConstraints { make in
            make.top.equalTo(imageV.snp.bottom).offset(17)
            make.centerX.equalToSuperview()
            make.width.lessThanOrEqualToSuperview().offset(-50)
        }
        setBtn.snp.makeConstraints { make in
            make.top.equalTo(titleL.snp.bottom).offset(10)
            make.centerX.equalTo(imageV)
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
    }
    
    func networkState() {
        let cellular = CTCellularData();
        cellular.cellularDataRestrictionDidUpdateNotifier = { (state) in
            var _isRestricted = true;
            if (state == .notRestricted) {
                _isRestricted = false
            }
            DispatchQueue.main.async {
                if _isRestricted {
                    self.setBtn.isHidden = false;
                    self.titleL.text = String(format: "无法连接网络, 请检查\n 1.Wi-Fi或蜂窝移动数据是否开启且可用\n 2.在\"设置 -> %@\"中允许访问无限数据", kAppName)
                } else {
                    self.setBtn.isHidden = true
                    self.titleL.text = "暂无数据"
                }
            }
        }
    }
    
    public func showInView(_ sview: UIView, _ type: QZSCStatusType, offset: CGPoint = .zero) {
        sview.addSubview(self)
        sview.sendSubviewToBack(self)
        
        imageV.image = UIImage(named: type.imageName)
        titleL.text = type.toast
        
        
        imageV.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(offset.x)
            make.centerY.equalToSuperview().offset(-50 + offset.y)
        }
        titleL.snp.updateConstraints { make in
            make.centerX.equalToSuperview().offset(offset.x)
        }
    }
    
    @objc dynamic func setBtnClick() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
    
    private lazy var imageV: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .center
        return imgV
    }()
    
    private lazy var titleL: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.init(hexString: "A5A5A5")
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var setBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("去设置", for: .normal)
        btn.setTitleColor(COLORFFFFFF, for: .normal)
        btn.backgroundColor = .blue
        btn.titleLabel?.font = .normal(14)
        btn.layer.cornerRadius = 20;
        btn.layer.masksToBounds = true;
        btn.isHidden = true;
        btn.addTarget(self, action: #selector(setBtnClick), for: .touchUpInside)
        return btn
    }()
}

extension UIView {
    
    // 无数据时，空白占位界面
    public func showStatus(_ type: QZSCStatusType) {
        showStatus(type, offset: .zero)
    }
    
    // 无数据时，空白占位界面，offset: 中心偏移
    public func showStatus(_ type: QZSCStatusType, offset: CGPoint) {
        let view = self.viewWithTag(9988)
        if let sview = view as? QZSCStatusView {
            if sview.superview == nil { // 没有父视图，重新添加
                sview.showInView(self, type, offset: offset)
            }
        } else { // 没有，重新创建
            let sview = QZSCStatusView(self)
            sview.tag = 9988
            sview.showInView(self, type, offset: offset)
        }
    }
    
    // 删除隐藏存在的 空白界面
    public func hideStatus() {
        let view = self.viewWithTag(9988)
        if let sview = view as? QZSCStatusView {
            if sview.superview != nil { // 没有父视图，重新添加
                sview.removeFromSuperview()
            }
        }
    }
    
}
