//
//  QZSCAccounTnumberView.swift
//  QZSC
//
//  Created by LN C on 2023/7/17.
//

import UIKit
import ActiveLabel
import JXSegmentedView
class QZSCAccounTnumberView: UIViewController {

    var phoneTF:UITextField!
    var passwordTF:UITextField!
    var loginBtn:UIButton!
    var selectedBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        accounTnumberUI()
    }
    func accounTnumberUI(){
        phoneTF = UITextField.init(frame: CGRect.zero)
        phoneTF.borderStyle = UITextField.BorderStyle.none
        phoneTF.leftView = UIView.init(frame: CGRectMake(0, 0, 26, 0))
        phoneTF.leftViewMode = .always
        phoneTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        phoneTF.layer.masksToBounds = true
        phoneTF.backgroundColor = UIColor(hexString: "#F5F7F7")
        phoneTF.placeholder = "请输入用户名/手机号码"
        phoneTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        phoneTF.keyboardType = UIKeyboardType.numberPad
        phoneTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        view.addSubview(phoneTF);
        
        phoneTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalToSuperview()
            make.top.equalTo(SCALE_HEIGTHS(value: 41))
        }
        
        passwordTF = UITextField.init(frame: CGRect.zero)
        passwordTF.borderStyle = UITextField.BorderStyle.none
        passwordTF.backgroundColor = UIColor(hexString: "#F5F7F7")
        passwordTF.leftView = UIView.init(frame: CGRectMake(0, 0, 26, 0))
        passwordTF.leftViewMode = .always
        passwordTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        passwordTF.layer.masksToBounds = true
        passwordTF.isSecureTextEntry = true
        passwordTF.placeholder = "请输入密码"
        passwordTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        passwordTF.keyboardType = UIKeyboardType.numberPad
        passwordTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        view.addSubview(passwordTF);
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(phoneTF.snp.bottom).offset(SCALE_HEIGTHS(value: 16))
        }
//        let pswLB = UILabel.init(frame: CGRect.zero)
//        pswLB.text = "忘记密码"
//        pswLB.textColor = UIColor(hexString: "999999")
//        pswLB.font = UIFont.font(size: 13, alias: .pfRegular)
//        view.addSubview(pswLB)
//        pswLB.snp.makeConstraints { make in
//            make.top.equalTo(passwordTF.snp.bottom).offset(SCALE_HEIGTHS(value: 12))
//            make.right.equalTo(passwordTF.snp.right).offset(-SCALE_WIDTHS(value: 5))
//        }
        
        loginBtn = UIButton.init(frame: CGRect.zero)
        loginBtn.backgroundColor = UIColor(hexString: "#000000")
        loginBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        loginBtn.layer.masksToBounds = true
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loginBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClickAction), for: .touchUpInside)
        view.addSubview(loginBtn);
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(passwordTF.snp.bottom).offset(SCALE_HEIGTHS(value: 50))
        }
        
        let protocolView = UIView.init(frame: CGRect.zero)
        view.addSubview(protocolView)
        protocolView.snp.makeConstraints { make in
//            make.height.equalTo(SCALE_HEIGTHS(value: 20))
//            make.width.equalTo(SCALE_WIDTHS(value: 120))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(loginBtn.snp.bottom).offset(SCALE_HEIGTHS(value: 15))
        }
        
         selectedBtn = UIButton.init(frame: CGRect.zero)
          
        selectedBtn.setImage(UIImage(named: "mine_unselected"), for: .normal)
        selectedBtn.setImage(UIImage(named: "mine_selected"), for: .selected)
        selectedBtn.addTarget(self, action: #selector(selectedBtnClickAction), for: .touchUpInside)
        protocolView.addSubview(selectedBtn)
        selectedBtn.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.centerY.equalTo( protocolView).offset(SCALE_WIDTHS(value: 0))
            make.width.equalTo(SCALE_HEIGTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 12))
        }
        
        let protocolLB = ActiveLabel()
        
        let platformType = ActiveType.custom(pattern: "\\s平台服务协议\\b")
        let privacyType = ActiveType.custom(pattern: "\\s隐私政策\\b")
        protocolLB.enabledTypes.append(platformType)
        protocolLB.enabledTypes.append(privacyType)
        protocolLB.customize { label in
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
            label.textColor = UIColor(hexString: "A1A0AB")
            label.text = "我已阅读并同意 平台服务协议 和 隐私政策 "
            label.customColor[platformType] = UIColor(hexString: "333333")
            label.customColor[privacyType] = UIColor(hexString: "333333")
            label.handleCustomTap(for: platformType) { str in
                let MineWKWebVC = QZSCWebController()
                MineWKWebVC.urlStr = "https://cwz.wasawasa.cn/cwz_protocol.html"
                  self.navigationController?.pushViewController(MineWKWebVC, animated: true)
              
            }
            label.handleCustomTap(for: privacyType) { str in
                let MineWKWebVC = QZSCWebController()
                MineWKWebVC.urlStr = "https://cwz.wasawasa.cn/cwz_privacies.html"
                  self.navigationController?.pushViewController(MineWKWebVC, animated: true)
            }
        }
        protocolView.addSubview(protocolLB)
        protocolLB.snp.makeConstraints { make in
            make.left.equalTo(selectedBtn.snp.right).offset(SCALE_WIDTHS(value: 8))
            make.centerY.equalTo(protocolView).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(SCALE_WIDTHS(value: 0))
            make.bottom.equalTo(SCALE_WIDTHS(value: 0))
            make.right.equalToSuperview()
        }
    }
    
    //勾选协议
    @objc private func selectedBtnClickAction() {
        
        selectedBtn.isSelected = !selectedBtn.isSelected
    }
    
    //登录按钮点击事件
    @objc private func loginBtnClickAction() {
        
        if((self.phoneTF.text?.count ?? 0) != 11){
            UMToast.show("请输入正确手机号码")
            return
        }
        if((self.passwordTF.text?.count ?? 0) == 0){
            UMToast.show("请输入密码")
            return
        }
        
        if (selectedBtn.isSelected == true){
            
        } else{
            UMToast.show("请先勾选协议")
        }
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

extension QZSCAccounTnumberView :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    
}
