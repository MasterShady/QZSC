//
//  QZSCPhoneLoginViewController.swift
//  QZSC
//
//  Created by lsy on 2023/7/17.
//

import UIKit
import ActiveLabel
import JXSegmentedView
class QZSCPhoneLoginViewController: UIViewController {

    var phoneTF:UITextField!
    var loginBtn:UIButton!
    var selectedBtn:UIButton!
    var accounTnumberView:UIView!
    var codeView:UIView!
    var phoneString:String!
    var codeLoginBtn:UIButton!
    var _timer:DispatchSource!
    var codeString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        codeString = ""
        accounTnumberUI()

        // Do any additional setup after loading the view.
    }
    
    func accounTnumberUI(){
        
        accounTnumberView = UIView.init(frame: CGRect.zero)
        accounTnumberView.backgroundColor = UIColor.clear
        self.view.addSubview(accounTnumberView)
        accounTnumberView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        phoneTF = UITextField.init(frame: CGRect.zero)
        phoneTF.borderStyle = UITextField.BorderStyle.none
        phoneTF.leftView = UIView.init(frame: CGRectMake(0, 0, 26, 0))
        phoneTF.leftViewMode = .always
        phoneTF.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        phoneTF.layer.masksToBounds = true
        phoneTF.backgroundColor = UIColor(hexString: "#F5F7F7")
        phoneTF.placeholder = "请输入用户名/手机号码"
        phoneTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        phoneTF.keyboardType = UIKeyboardType.numberPad
        phoneTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        accounTnumberView.addSubview(phoneTF);
        
        phoneTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalToSuperview()
            make.top.equalTo(SCALE_HEIGTHS(value: 41))
        }
        
        loginBtn = UIButton.init(frame: CGRect.zero)
        loginBtn.backgroundColor = UIColor(hexString: "#000000")
        loginBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        loginBtn.layer.masksToBounds = true
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        loginBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.addTarget(self, action: #selector(loginBtnClickAction), for: .touchUpInside)
        accounTnumberView.addSubview(loginBtn);
        loginBtn.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(phoneTF.snp.bottom).offset(SCALE_HEIGTHS(value: 50))
        }
        
        let protocolView = UIView.init(frame: CGRect.zero)
        accounTnumberView.addSubview(protocolView)
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
    
    func codeViewUI(){
        codeView = UIView.init(frame: CGRect.zero)
        codeView.backgroundColor = UIColor.clear
        self.view.addSubview(codeView)
        codeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "验证码已发送到"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        codeView.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.top.equalTo(SCALE_HEIGTHS(value: 53))
            make.left.equalTo(SCALE_WIDTHS(value: 31))
        }
        
        let phoneLB = UILabel.init(frame: CGRect.zero)
        phoneLB.text = phoneString
        phoneLB.textColor = UIColor(hexString: "333333")
        phoneLB.font = UIFont.systemFont(ofSize: 21, weight: .medium)
        codeView.addSubview(phoneLB)
        phoneLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 31))
            make.top.equalTo(LB.snp.bottom).offset(SCALE_HEIGTHS(value: 10))
        }
        
        let verifyCodeView = TDWVerifyCodeView.init(inputTextNum: 6)
        codeView.addSubview(verifyCodeView)
        verifyCodeView.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.right.equalTo(-SCALE_WIDTHS(value: 15))
            make.top.equalTo(phoneLB.snp.bottom).offset(SCALE_HEIGTHS(value: 30))
            make.height.equalTo(SCALE_HEIGTHS(value: 50))
        }
        verifyCodeView.textFiled.becomeFirstResponder()
        
        // 监听验证码输入的过程
        verifyCodeView.textValueChange = { str in
            // 要做的事情
            if str.count > 0{
                self._timer.cancel();
                self.codeLoginBtn.setTitle("登录", for: .normal)
                self.codeLoginBtn.isEnabled = true
                self.codeLoginBtn.layer.backgroundColor = UIColor(hexString: "#000000").cgColor
            }
            self.codeString = str
        }
        
        // 监听验证码输入完成
        verifyCodeView.inputFinish = { str in
            // 要做的事情
        }
        
        codeLoginBtn = UIButton.init(frame: CGRect.zero)
        codeLoginBtn.backgroundColor = UIColor(hexString: "A1A0AB")
        codeLoginBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        codeLoginBtn.layer.masksToBounds = true
        codeLoginBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        codeLoginBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        codeLoginBtn.setTitle("登录", for: .normal)
        codeLoginBtn.addTarget(self, action: #selector(codeLoginBtnClickAction), for: .touchUpInside)
//        loginBtn.setTitle("登录", for: .disabled)
        codeView.addSubview(codeLoginBtn);
        codeLoginBtn.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 52))
            make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.centerX.equalTo( self.view).offset(SCALE_WIDTHS(value: 0))
            make.top.equalTo(verifyCodeView.snp.bottom).offset(SCALE_HEIGTHS(value: 20))
        }
        
        let delayLB = UILabel.init(frame: CGRect.zero)
        delayLB.text = "可能会有延后，请耐心等待…"
        delayLB.textColor = UIColor(hexString: "A1A0AB")
        delayLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        codeView.addSubview(delayLB)
        delayLB.snp.makeConstraints { make in
            make.top.equalTo(codeLoginBtn.snp.bottom).offset(SCALE_HEIGTHS(value: 10))
            make.centerX.equalToSuperview()
        }
    }
    
    //勾选协议
    @objc private func selectedBtnClickAction() {
        
        selectedBtn.isSelected = !selectedBtn.isSelected
    }
    
    //登录按钮
    @objc private func codeLoginBtnClickAction() {
        
        if codeString.count == 0{
            countDown(59, btn: codeLoginBtn)
            return
        }
        if codeString.count == 6{
            UMToast.show("登录失败，请使用密码登录")
        }else{
            UMToast.show("请输入验证码")
        }
        
        
    }
    
    //登录按钮点击事件
    @objc private func loginBtnClickAction() {
        
        if((self.phoneTF.text?.count ?? 0) != 11){
            UMToast.show("请输入正确手机号码")
            return
        }
        
        if (selectedBtn.isSelected == true){
            phoneString = phoneTF.text
            accounTnumberView.removeFromSuperview()
            codeViewUI()
            countDown(59, btn: codeLoginBtn)
        } else{
            UMToast.show("请先勾选协议")
        }
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //倒计时验证码
       func countDown(_ timeOut: Int, btn: UIButton){
              //倒计时时间
              var timeout = timeOut
              let queue:DispatchQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
               _timer = DispatchSource.makeTimerSource(flags: [], queue: queue) as! DispatchSource
              _timer.scheduleRepeating(wallDeadline: DispatchWallTime.now(), interval: .seconds(1))
              //每秒执行
              _timer.setEventHandler(handler: { () -> Void in
                  if(timeout<=0){ //倒计时结束，关闭
                      self._timer.cancel();
                      DispatchQueue.main.sync(execute: { () -> Void in
                          btn.setTitle("重新发送", for: .normal)
                          btn.isEnabled = true
                          btn.layer.backgroundColor = UIColor(hexString: "#000000").cgColor
                      })
                  }else{//正在倒计时
                      let seconds = timeout
                      DispatchQueue.main.sync(execute: { () -> Void in
                          let str = String(describing: seconds)
                          btn.setTitle("重新发送(\(str))S", for: .normal)
                          btn.isEnabled = false
                          btn.layer.backgroundColor = UIColor(hexString: "A1A0AB").cgColor
                      })
                      timeout -= 1;
                  }
              })
              _timer.resume()
          }



}

extension QZSCPhoneLoginViewController :JXSegmentedListContainerViewListDelegate{
    func listView() -> UIView {
        return self.view
    }
    
    
}
