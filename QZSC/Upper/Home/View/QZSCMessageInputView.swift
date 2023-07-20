//
//  QZSCMessageInputView.swift
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

import Foundation
import RxCocoa
import RxSwift

class QZSCMessageInputView: UIView {
    
    private let dBag = DisposeBag()
    
    var refreshHandle: (() -> ())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        backgroundColor = .white
        
        addSubview(inputTF)
        addSubview(sendBtn)
        
        sendBtn.snp.makeConstraints { make in
            make.top.equalTo(10)
            make.right.equalTo(-14)
            make.width.equalTo(52)
            make.height.equalTo(30)
        }
        inputTF.snp.makeConstraints { make in
            make.centerY.equalTo(sendBtn)
            make.left.equalTo(14)
            make.right.equalTo(sendBtn.snp.left).offset(-10)
            make.height.equalTo(34)
        }
    }
    
    // MARK: - lazy
    private lazy var sendBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("发送", for: .normal)
        btn.setTitleColor(COLORFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.normal(14)
        btn.backgroundColor = COLOR00CDCE
        btn.layer.cornerRadius = 15
        btn.layer.masksToBounds = true
        btn.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            if let content = self.inputTF.text, content.isNil {
                return
            }
            guard let content = self.inputTF.text else { return }
            if content.isNil {
                return
            }
            QZSCHomeViewModel.sendAsk(message: content) { result in
                self.inputTF.text = ""
                QZSCKfManager.shared.addNewHistoryMessage(message: content.removeAllSapce)
                self.refreshHandle?()
            }
            
        }).disposed(by: dBag)
        return btn
    }()
    
    private lazy var inputTF: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.medium(14)
        tf.textColor = COLOR333333
        tf.placeholder = "请输入~"
        tf.layer.cornerRadius = 17
        tf.layer.masksToBounds = true
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor = COLORA1A0AB.cgColor
        tf.leftViewMode = .always
        tf.rightViewMode = .always
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 16))
        tf.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 16))
        return tf
    }()
}
