
import UIKit

class MineAddressNewViewController: QZSCBaseController {
    var phoneTF:UITextField!
    var nameTF:UITextField!
    var addressTF:UITextField!
    var onswitch:UISwitch!
    var cityLB:UILabel!
    
    var is_default: Int = 0
    
    var myCity: String = ""
    var myProvince: String = ""
    var myArea: String = ""
    
    var uid: Int = 0
    
    var uname: String = ""
    
    var phone: String = ""
    
    var location_desc: String = ""
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        AddressNewUI()
        self.navTitle = "新建地址"
        self.view.backgroundColor = UIColor(hexString: "#FFFFFF")
        if(myCity.count > 0){
            phoneTF.text = phone
            nameTF.text = uname
            
            addressTF.text = location_desc
            
        }
    }
    func AddressNewUI(){
        
        let nameView = UIView.init(frame: CGRect.zero)
        nameView.backgroundColor = UIColor.white
         
         self.view.addSubview(nameView)
        nameView.snp.makeConstraints { make in
             make.left.right.equalToSuperview()
             make.top.equalTo(NAV_HEIGHT)
             make.height.equalTo(SCALE_HEIGTHS(value: 62))
         }
         
       let  nameLB = UILabel.init(frame: CGRect.zero)
        nameLB.text = "收货人"
        nameLB.textColor = UIColor(hexString: "333333")
        nameLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        nameView.addSubview(nameLB)
         
        nameLB.snp.makeConstraints { make in
             make.left.equalTo(SCALE_WIDTHS(value: 15))
             make.width.equalTo(SCALE_WIDTHS(value: 100))
             make.centerY.equalToSuperview()
         }
         
        nameTF = UITextField.init(frame: CGRect.zero)
        nameTF.borderStyle = UITextField.BorderStyle.none
        nameTF.backgroundColor = UIColor(hexString: "FFFFFF")
        nameTF.placeholder = "请填写姓名"
        nameTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        nameTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        nameTF.keyboardType = UIKeyboardType.numberPad
        nameTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        nameView.addSubview(nameTF);
        nameTF.snp.makeConstraints { make in
             make.height.equalTo(SCALE_HEIGTHS(value: 30))
             make.left.equalTo(nameLB.snp.right).offset(SCALE_WIDTHS(value: 10))
             make.centerY.equalToSuperview()
             make.right.equalTo(-SCALE_WIDTHS(value: 15))
         }
         let nameLine = UIView.init(frame: CGRect.zero)
        nameLine.backgroundColor = UIColor(hexString: "EDEDED ")
        nameView.addSubview(nameLine)
        nameLine.snp.makeConstraints { make in
             make.bottom.equalToSuperview()
             make.left.equalTo(SCALE_WIDTHS(value: 16))
             make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
         }
        
        
       let phoneView = UIView.init(frame: CGRect.zero)
        phoneView.backgroundColor = UIColor.white
        
        self.view.addSubview(phoneView)
        phoneView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(nameView.snp.bottom)
            make.height.equalTo(SCALE_HEIGTHS(value: 62))
        }
        
      let  phoneLB = UILabel.init(frame: CGRect.zero)
        phoneLB.text = "手机号码"
        phoneLB.textColor = UIColor(hexString: "333333")
        phoneLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        phoneView.addSubview(phoneLB)
        
        phoneLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.width.equalTo(SCALE_WIDTHS(value: 100))
            make.centerY.equalToSuperview()
        }
        
        phoneTF = UITextField.init(frame: CGRect.zero)
        phoneTF.borderStyle = UITextField.BorderStyle.none
        phoneTF.backgroundColor = UIColor(hexString: "FFFFFF")
        phoneTF.placeholder = "请填写手机号码"
        phoneTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        phoneTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
        phoneTF.keyboardType = UIKeyboardType.numberPad
        phoneTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        phoneView.addSubview(phoneTF);
        
        phoneTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 30))
            make.left.equalTo(phoneLB.snp.right).offset(SCALE_WIDTHS(value: 10))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-SCALE_WIDTHS(value: 15))
        }
        let phoneLine = UIView.init(frame: CGRect.zero)
        phoneLine.backgroundColor = UIColor(hexString: "EDEDED ")
        phoneView.addSubview(phoneLine)
        phoneLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
        
        
        let cityView = UIView.init(frame: CGRect.zero)
        cityView.backgroundColor = UIColor.white
        cityView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(cityViewTapAction)))
         
         self.view.addSubview(cityView)
        cityView.snp.makeConstraints { make in
             make.left.right.equalToSuperview()
             make.top.equalTo(phoneView.snp.bottom)
             make.height.equalTo(SCALE_HEIGTHS(value: 62))
         }
         
       let  regionLB = UILabel.init(frame: CGRect.zero)
        regionLB.text = "所在地区"
        regionLB.textColor = UIColor(hexString: "333333")
        regionLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        cityView.addSubview(regionLB)

        regionLB.snp.makeConstraints { make in
             make.left.equalTo(SCALE_WIDTHS(value: 15))
             make.width.equalTo(SCALE_WIDTHS(value: 100))
             make.centerY.equalToSuperview()
         }
        
         cityLB = UILabel.init(frame: CGRect.zero)
        cityLB.text = myCity.count == 0 ? "请选择" : myCity
        cityLB.textColor = myCity.count == 0 ? UIColor(hexString: "999999"): UIColor.black
        cityLB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
         cityView.addSubview(cityLB)

        cityLB.snp.makeConstraints { make in
            make.left.equalTo(regionLB.snp.right).offset(SCALE_WIDTHS(value: 10))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
              make.centerY.equalToSuperview()
          }
        let rightImage = UIImageView.init(frame: CGRect.zero)
        let rightimage = UIImage(named:"icon_right")
        rightImage.image = rightimage
        cityView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 13))
            make.height.equalTo(SCALE_WIDTHS(value: 14))
            make.width.equalTo(SCALE_WIDTHS(value: 14))
            make.centerY.equalToSuperview()
        }
        
        let cityLine = UIView.init(frame: CGRect.zero)
        cityLine.backgroundColor = UIColor(hexString: "EDEDED ")
        cityView.addSubview(cityLine)
        cityLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
        
        
        let addressView = UIView.init(frame: CGRect.zero)
        addressView.backgroundColor = UIColor.white
         self.view.addSubview(addressView)
        addressView.snp.makeConstraints { make in
             make.left.right.equalToSuperview()
             make.top.equalTo(cityView.snp.bottom)
             make.height.equalTo(SCALE_HEIGTHS(value: 62))
         }
         
       let  addressLB = UILabel.init(frame: CGRect.zero)
        addressLB.text = "详细地址"
        addressLB.textColor = UIColor(hexString: "333333")
        addressLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        addressView.addSubview(addressLB)

        addressLB.snp.makeConstraints { make in
             make.left.equalTo(SCALE_WIDTHS(value: 15))
             make.width.equalTo(SCALE_WIDTHS(value: 100))
             make.centerY.equalToSuperview()
         }
        
        addressTF = UITextField.init(frame: CGRect.zero)
        addressTF.borderStyle = UITextField.BorderStyle.none
        addressTF.backgroundColor = UIColor(hexString: "FFFFFF")
        addressTF.placeholder = "街道、楼牌号等"
        addressTF.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        addressTF.clearButtonMode = .whileEditing  //编辑时出现清除按钮
//        addressTF.keyboardType = UIKeyboardType.numberPad
        addressTF.returnKeyType = UIReturnKeyType.done //表示完成输入
        addressView.addSubview(addressTF);
        
        addressTF.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 30))
            make.left.equalTo(addressLB.snp.right).offset(SCALE_WIDTHS(value: 10))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-SCALE_WIDTHS(value: 15))
        }
        let addressLine = UIView.init(frame: CGRect.zero)
        addressLine.backgroundColor = UIColor(hexString: "EDEDED ")
        addressView.addSubview(addressLine)
        addressLine.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
        
        
        
        
        let defaultView  = UIView.init(frame: CGRect.zero)
        defaultView.backgroundColor = UIColor(hexString: "F6F8FC")
        defaultView.layer.cornerRadius = SCALE_WIDTHS(value: 12)
        defaultView.layer.masksToBounds = true
         self.view.addSubview(defaultView)
        defaultView.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 14))
            make.right.equalTo(-SCALE_WIDTHS(value: 14))
            make.top.equalTo(addressView.snp.bottom).offset(SCALE_HEIGTHS(value: 30))
             make.height.equalTo(SCALE_HEIGTHS(value: 82))
         }
        
        let  defaultLB = UILabel.init(frame: CGRect.zero)
        defaultLB.text = "设置默认地址"
        defaultLB.textColor = UIColor(hexString: "333333")
        defaultLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        defaultView.addSubview(defaultLB)

        defaultLB.snp.makeConstraints { make in
              make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.centerY.equalToSuperview().offset(-SCALE_HEIGTHS(value: 10))
          }
        
        let  hintLB = UILabel.init(frame: CGRect.zero)
        hintLB.text = "每次下单会默认推荐该地址"
        hintLB.textColor = UIColor(hexString: "999999")
        hintLB.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        defaultView.addSubview(hintLB)

        hintLB.snp.makeConstraints { make in
              make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.centerY.equalToSuperview().offset(SCALE_HEIGTHS(value: 10))
          }
        
           onswitch = UISwitch()
        defaultView.addSubview(onswitch)
        //        Apple官方说明，对UISwitch设置大小是无效的，其永远保持在(51,31)的大小
        onswitch.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 15))
            make.centerY.equalToSuperview()
        }
        onswitch.isOn = is_default == 0 ? false : true
                onswitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75);//可以使用transform修改switch的大小
//                onswitch.setOn(true, animated: true)
                onswitch.thumbTintColor = UIColor.white//滑块上小圆点的颜色
                onswitch.onTintColor = UIColor(hexString: "#000000")//设置开启状态显示的颜色
                onswitch.tintColor = UIColor(hexString: "999999")//设置关闭状态的颜色
                
                onswitch.addTarget(self, action: #selector(switchClick), for: .valueChanged)
        
        let addressBtn = UIButton.init(frame: CGRect.zero)
        addressBtn.backgroundColor = UIColor(hexString: "#000000")
        addressBtn.layer.cornerRadius = SCALE_HEIGTHS(value: 12)
        addressBtn.layer.masksToBounds = true
        addressBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        addressBtn.setTitleColor(UIColor(hexString: "#FFFFFF"), for: .normal)
        addressBtn.setTitle(self.uid != 0 ? "修改收货地址" : "新增收货地址", for: .normal)
        addressBtn.addTarget(self, action: #selector(addressBtnClickAction), for: .touchUpInside)
         
        self.view.addSubview(addressBtn);
        addressBtn.snp.makeConstraints { make in
             make.height.equalTo(SCALE_HEIGTHS(value: 48))
             make.width.equalTo(SCALE_WIDTHS(value: 263))
            make.bottom.equalTo(-TABLEBAR_HEIGHT)
            make.centerX.equalToSuperview()
             
         }
        
    }
    
    
    
    @objc func switchClick(){
        if(onswitch.isOn == false){
            is_default = 0
        } else{
            is_default = 1
        }
            
            
        }
    
    //新增收货地址
    @objc private func addressBtnClickAction() {
        if(nameTF.text?.count == 0){
            
            UMToastManager.showToast("请填写收货人姓名")
            return
        }
        
        if(phoneTF.text?.count == 0){
            UMToastManager.showToast("请填写手机号码")
            return
        }
        
        if(self.myCity.count == 0){
            UMToastManager.showToast("请选择所在地区")
            return
        }
        
        if(addressTF.text?.count == 0){
            UMToastManager.showToast("请填写详细地址")
            return
        }
        
        
        if( self.uid != 0){
            QZSCAddressViewModel.loadUpdateAddress(uname: nameTF.text!, phone: phoneTF.text!, address_area: self.myCity, address_detail: addressTF.text!, is_default: is_default, address_id: uid) { code in
                if (code == true){
                    UMToastManager.showToast("修改成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)

                    }
                }
            }
           
        }else {
            QZSCAddressViewModel.loadAddAddress(uname: nameTF.text!, phone: phoneTF.text!, address_area: self.myCity, address_detail: addressTF.text!, is_default: is_default) { code in
                if (code == true){
                    UMToastManager.showToast("添加成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)

                    }
                }
            }
        }
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
   
    
    
    
    
   
    
    
    @objc private func cityViewTapAction() {
        let address = KLCityPickerView()
        address.areaPickerViewWithProvince(province: myProvince, city: myCity, area: myArea) { (province, city, area) in
            if(province.count == 0){
                if (area.count == 0){
                    self.myCity = "北京市东城区"
                }else{
                    self.myCity = "北京市" + area
                }
                
            } else {
                self.myCity = province + city + area
            }
            
            self.cityLB.text = self.myCity
        
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
