//
//  QZSCRegisterViewController.swift
//  QZSC
//
//  Created by LN C on 2023/7/18.
//

import UIKit
import ActiveLabel
class QZSCRegisterViewController: QZSCBaseController {

    var phoneTF:UITextField!
    var codeTF:UITextField!
    var codeBtn:UIButton!
    var loginBtn:UIButton!
    var selectedBtn:UIButton!
    var passwordTF:UITextField!
    var inviteTF:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        RegisterUI()
    }
    
    func RegisterUI(){
        let bgimage = UIImageView.init(frame: CGRect.zero)
        bgimage.image = UIImage(named: "login_bg")
        self.view.addSubview(bgimage)
        bgimage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "注册"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        self.view.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.top.equalTo(NAV_HEIGHT + SCALE_HEIGTHS(value: 35))
        }
        
        let whiteView = UIView.init(frame: CGRect.zero)
        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = SCALE_HEIGTHS(value: 14)
        whiteView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        whiteView.layer.masksToBounds = true
        view.addSubview(whiteView)
        whiteView.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.right.equalTo(-SCALE_WIDTHS(value: 15))
            make.bottom.equalToSuperview()
            make.top.equalTo(NAV_HEIGHT + SCALE_HEIGTHS(value: 90))
        }
        
        phoneTF = UITextField.init(frame: CGRect.zero)
        phoneTF.borderStyle = UITextField.BorderStyle.none
        phoneTF.leftView = UIView.init(frame: CGRectMake(0, 0, 20, 0))
        phoneTF.leftViewMode = .always
        phoneTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        phoneTF.layer.masksToBounds = true
        phoneTF.backgroundColor = UIColor(hexString:"#F5F7F7")
        phoneTF.placeholder = "请输入手机号码"
        phoneTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        phoneTF.keyboardType = UIKeyboardType.numberPad
        phoneTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        whiteView.addSubview(phoneTF);
        
        phoneTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(SCALE_HEIGTHS(value: 41))
        }
        
        //        codeTF = UITextField.init(frame: CGRect.zero)
        //        codeTF.borderStyle = UITextField.BorderStyle.none
        //        codeTF.backgroundColor = UIColor.hexColor("FAFAFA")
        //        codeTF.leftView = UIView.init(frame: CGRectMake(0, 0, 20, 0))
        //        codeTF.leftViewMode = .always
        //        codeTF.layer.cornerRadius = SCALE_HEIGTHS(value: 14)
        //        codeTF.layer.masksToBounds = true
        //        codeTF.placeholder = "请输入短信验证码"
        //        codeTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        //        codeTF.keyboardType = UIKeyboardType.numberPad
        //        codeTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        //        whiteView.addSubview(codeTF);
        //
        //        codeTF.snp.makeConstraints { make in
        //            make.height.equalTo(SCALE_HEIGTHS(value: 52))
        //            make.width.equalTo(SCALE_WIDTHS(value: 263))
        //            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
        //            make.top.equalTo(phoneTF.snp.bottom).offset(SCALE_HEIGTHS(value: 16))
        //        }
        //
        //        codeBtn = UIButton.init(frame: CGRect.zero)
        //
        //        codeBtn.titleLabel?.font = UIFont.font(size: 12.0, alias: .pfMedium)
        //        codeBtn.setTitleColor(UIColor(hexString: "333333"), for: .normal)
        //        codeBtn.setTitle("获取验证码", for: .normal)
        //        codeBtn.addTarget(self, action: #selector(loginBtnClickAction), for: .touchUpInside)
        //        codeTF.addSubview(codeBtn);
        //        codeBtn.snp.makeConstraints { make in
        //            make.right.equalTo(codeTF.snp.right).offset(-SCALE_WIDTHS(value: 10))
        //            make.centerY.equalTo( codeTF).offset(SCALE_WIDTHS(value: 0))
        //            make.width.equalTo(SCALE_WIDTHS(value: 100))
        //            make.height.equalTo(SCALE_HEIGTHS(value: 22))
        //        }
        
        
        passwordTF = UITextField.init(frame: CGRect.zero)
        passwordTF.borderStyle = UITextField.BorderStyle.none
        passwordTF.backgroundColor = UIColor(hexString:"#F5F7F7")
        passwordTF.leftView = UIView.init(frame: CGRectMake(0, 0, 20, 0))
        passwordTF.leftViewMode = .always
        passwordTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        passwordTF.layer.masksToBounds = true
        passwordTF.isSecureTextEntry = true
        passwordTF.placeholder = "请设置密码"
        passwordTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        passwordTF.keyboardType = UIKeyboardType.numberPad
        passwordTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        whiteView.addSubview(passwordTF);
        
        passwordTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(phoneTF.snp.bottom).offset(SCALE_HEIGTHS(value: 16))
        }
        
        //inviteTF
        inviteTF = UITextField.init(frame: CGRect.zero)
        inviteTF.borderStyle = UITextField.BorderStyle.none
        inviteTF.backgroundColor = UIColor(hexString:"#F5F7F7")
        inviteTF.leftView = UIView.init(frame: CGRectMake(0, 0, 20, 0))
        inviteTF.leftViewMode = .always
        inviteTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        inviteTF.layer.masksToBounds = true
        inviteTF.placeholder = "请输入邀请码（选填）"
        inviteTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        inviteTF.keyboardType = UIKeyboardType.numberPad
        inviteTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        whiteView.addSubview(inviteTF);
        
        inviteTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(passwordTF.snp.bottom).offset(SCALE_HEIGTHS(value: 16))
        }
        
        loginBtn = UIButton.init(frame: CGRect.zero)
        loginBtn.backgroundColor = UIColor(hexString: "#000000")
        loginBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        loginBtn.layer.masksToBounds = true
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loginBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        loginBtn.setTitle("立即注册", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClickAction), for: .touchUpInside)
        whiteView.addSubview(loginBtn);
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(inviteTF.snp.bottom).offset(SCALE_HEIGTHS(value: 35))
        }
        
        
        
        
        let protocolView = UIView.init(frame: CGRect.zero)
        whiteView.addSubview(protocolView)
        protocolView.snp.makeConstraints { make in
            
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(loginBtn.snp.bottom).offset(SCALE_HEIGTHS(value: 18))
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
                MineWKWebVC.urlStr = QZSCAppEnvironment.shared.protocolUrl
                  self.navigationController?.pushViewController(MineWKWebVC, animated: true)
              
            }
            label.handleCustomTap(for: privacyType) { str in
                let MineWKWebVC = QZSCWebController()
                MineWKWebVC.urlStr = QZSCAppEnvironment.shared.privacyUrl
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
        
        if(self.phoneTF.text?.count  == 0){
            UMToast.show("请输入手机号")
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
