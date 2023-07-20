//
//  QZSCSettingViewController.swift
//  QZSC
//
//  Created by LN C on 2023/7/20.
//

import UIKit

class QZSCSettingViewController: QZSCBaseController {

    var cacheView:UIView!
    var aboutUsView:UIView!
    var privacyView:UIView!
    var cancelView:UIView!
    var bottomView:UIView!
    var cacheLB:UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "设置"
        cacheViewUI()
        cancelViewUI()
        privacyViewUI()
        aboutUsViewUI()
        botViewUI()

        // Do any additional setup after loading the view.
    }
    func cacheViewUI(){
         cacheView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(cacheView)
        cacheView.isUserInteractionEnabled = true
        cacheView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cacheViewClickAction)))
        cacheView.backgroundColor = UIColor(hexString: "FFFFFF")
        cacheView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(NAV_HEIGHT)
            make.height.equalTo(SCALE_HEIGTHS(value: 55))
        }
        
        
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "清除缓存"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cacheView.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 15))
            make.centerY.equalTo(cacheView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
        let rightImage = UIImageView.init(frame: CGRect.zero)
        let rightimage = UIImage(named:"home_arrow_go")
        rightImage.image = rightimage
        cacheView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 13))
            make.height.equalTo(SCALE_WIDTHS(value: 14))
            make.width.equalTo(SCALE_WIDTHS(value: 14))
            make.centerY.equalTo(cacheView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
         cacheLB = UILabel.init(frame: CGRect.zero)
        cacheLB.text = getCacheFileSize()
        cacheLB.textColor = UIColor(hexString: "999999")
        cacheLB.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        cacheView.addSubview(cacheLB)
        cacheLB.snp.makeConstraints { make in
            make.right.equalTo(rightImage.snp.right).offset(-SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(cacheView).offset(SCALE_WIDTHS(value: 0))
        }
        let lineView = UIView()
        cacheView.addSubview(lineView)
         lineView.backgroundColor = UIColor(hexString: "#EEEEEE")
         lineView.snp.makeConstraints { make in
             make.bottom.equalToSuperview()
             make.left.equalTo(SCALE_WIDTHS(value: 14))
             make.right.equalTo(-SCALE_WIDTHS(value: 14))
             make.height.equalTo(SCALE_HEIGTHS(value: 0.5))
        }
    }
    
   
    
    func privacyViewUI(){
        privacyView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(privacyView)
        privacyView.isUserInteractionEnabled = true
        privacyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyViewClickAction)))
        privacyView.backgroundColor = UIColor(hexString: "FFFFFF")
        privacyView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cancelView.snp.bottom).offset(SCALE_HEIGTHS(value: 0))
            make.height.equalTo(SCALE_HEIGTHS(value: 55))
        }
        
        
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "隐私政策"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        privacyView.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 15))
            make.centerY.equalTo(privacyView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
        let rightImage = UIImageView.init(frame: CGRect.zero)
        let rightimage = UIImage(named:"home_arrow_go")
        rightImage.image = rightimage
        privacyView.addSubview(rightImage)
        rightImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 13))
            make.height.equalTo(SCALE_WIDTHS(value: 14))
            make.width.equalTo(SCALE_WIDTHS(value: 14))
            make.centerY.equalTo(privacyView).offset(SCALE_WIDTHS(value: 0))
        }
        let lineView = UIView()
        privacyView.addSubview(lineView)
         lineView.backgroundColor = UIColor(hexString: "#EEEEEE")
         lineView.snp.makeConstraints { make in
             make.bottom.equalToSuperview()
             make.left.equalTo(SCALE_WIDTHS(value: 14))
             make.right.equalTo(-SCALE_WIDTHS(value: 14))
             make.height.equalTo(SCALE_HEIGTHS(value: 0.5))
        }
    }
    func cancelViewUI(){
        cancelView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(cancelView)
        cancelView.isUserInteractionEnabled = true
        cancelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelViewClickAction)))
        cancelView.backgroundColor = UIColor(hexString: "FFFFFF")
        cancelView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cacheView.snp.bottom).offset(SCALE_HEIGTHS(value: 0))
            make.height.equalTo(SCALE_HEIGTHS(value: 55))
        }
        
        
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "账号注销"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        cancelView.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 15))
            make.centerY.equalTo(cancelView).offset(SCALE_WIDTHS(value: 0))
        }
       let lineView = UIView()
        cancelView.addSubview(lineView)
        lineView.backgroundColor = UIColor(hexString: "#EEEEEE")
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(SCALE_WIDTHS(value: 14))
            make.right.equalTo(-SCALE_WIDTHS(value: 14))
            make.height.equalTo(SCALE_HEIGTHS(value: 0.5))
       }
    }
    
    func botViewUI()  {
         bottomView = UIView()
        self.view.addSubview(bottomView)
        bottomView.backgroundColor = UIColor.clear
        bottomView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 85))
        }
        
       let logoutBtn = UIButton.init(frame: CGRect.zero)
        logoutBtn.backgroundColor = UIColor.clear
        
        logoutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        logoutBtn.setTitleColor(UIColor(hexString: "#F6194F"), for: .normal)
        logoutBtn.setTitle("退出登录", for: .normal)
        logoutBtn.addTarget(self, action: #selector( logoutBtnClickAction), for: .touchUpInside)
        bottomView.addSubview(logoutBtn);
        logoutBtn.snp.makeConstraints { make in
            make.height.equalTo(SCALE_HEIGTHS(value: 48))
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 39))
            make.right.equalToSuperview().offset(-SCALE_WIDTHS(value: 39))
            make.centerY.equalTo( bottomView).offset(-SCALE_WIDTHS(value: 10))
        }
        
    }
    
    func aboutUsViewUI(){
        aboutUsView = UIView.init(frame: CGRect.zero)
        self.view.addSubview(aboutUsView)
        aboutUsView.isUserInteractionEnabled = true
        aboutUsView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(aboutUsViewClickAction)))
        aboutUsView.backgroundColor = UIColor(hexString: "FFFFFF")
        aboutUsView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(privacyView.snp.bottom).offset(SCALE_HEIGTHS(value: 0))
            make.height.equalTo(SCALE_HEIGTHS(value: 55))
        }
        
        
        let LB = UILabel.init(frame: CGRect.zero)
        LB.text = "关于我们"
        LB.textColor = UIColor(hexString: "333333")
        LB.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        aboutUsView.addSubview(LB)
        LB.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SCALE_WIDTHS(value: 15))
            make.centerY.equalTo(aboutUsView).offset(SCALE_WIDTHS(value: 0))
        }
        
        
        let lineView = UIView()
        aboutUsView.addSubview(lineView)
         lineView.backgroundColor = UIColor(hexString: "#EEEEEE")
         lineView.snp.makeConstraints { make in
             make.bottom.equalToSuperview()
             make.left.equalTo(SCALE_WIDTHS(value: 14))
             make.right.equalTo(-SCALE_WIDTHS(value: 14))
             make.height.equalTo(SCALE_HEIGTHS(value: 0.5))
        }
    }
    
    //关于我们
    @objc private func aboutUsViewClickAction() {
       
        
    }
    
    //清除缓存
    @objc private func cacheViewClickAction() {
        print("点击清除缓存")
        cacheLB.text = clearFileCache()
        
    }
    
    //隐私协议
    @objc private func privacyViewClickAction() {
        print("点击隐私协议")
        
        let MineWKWebVC = QZSCWebController()
        MineWKWebVC.urlStr = QZSCAppEnvironment.shared.privacyUrl
          self.navigationController?.pushViewController(MineWKWebVC, animated: true)
        
    }
    
    // 注销账号
    @objc private func cancelViewClickAction() {
        
        let alertController = UIAlertController(title: "", message: "确认注销账号?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "我再想想", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "删除", style: UIAlertAction.Style.default) { (ACTION) in
            
            //写删除逻辑
               }
               alertController.addAction(cancelAction);
               alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
        
       
    }
    
    //退出登录
    @objc private func logoutBtnClickAction() {
        
        QZSCLoginManager.shared.logOut()
        self.navigationController?.popViewController(animated: true)
        
    }
    func getCacheFileSize() -> String{
        var foldSize: UInt64 = 0
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                let folder = try? FileManager.default.attributesOfItem(atPath: temPath) as NSDictionary
                if let c = folder?.fileSize() {
                    foldSize += c
                }
            }
        }
        //保留2位小数
        if foldSize > 1024*1024 {
            
            return String(format: "%.2f", Double(foldSize)/1024.0/1024.0) + "MB"
        }
        else if foldSize > 1024 {
            return String(format: "%.2f", Double(foldSize)/1024.0) + "KB"
        }else {
            return String(foldSize) + "B"
        }
    }
    
    
    func clearFileCache() -> String {
        let filePath: String = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first ?? ""
        if let files = FileManager.default.subpaths(atPath: filePath) {
            for path in files {
                let temPath: String = filePath+"/"+path
                if FileManager.default.fileExists(atPath: temPath) {
                    try? FileManager.default.removeItem(atPath: temPath)
                }
            }
        }
        return getCacheFileSize()
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
