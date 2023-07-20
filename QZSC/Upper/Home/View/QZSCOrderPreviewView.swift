//
//  QZSCOrderPreviewView.swift
//  QZSC
//
//  Created by zzk on 2023/7/18.
//

import UIKit
import RxCocoa
import RxSwift

class QZSCOrderPreviewView: UIView {

    private let dBag = DisposeBag()
    private let contentVH: CGFloat = kHomeIndicatorHeight() + 550

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        loadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        backgroundColor = .clear
        
        addSubview(bgV)
        addSubview(contentV)
        bgV.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        contentV.snp.makeConstraints { make in
            make.trailing.leading.bottom.equalToSuperview()
            make.height.equalTo(contentVH)
        }
        
        let titleLbl = UILabel.createSameLbl(text: "确认订单", color: COLOR000000, font: UIFont.semibold(16))
        contentV.addSubview(titleLbl)
        titleLbl.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(24)
            make.height.equalTo(22)
        }
        
        contentV.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.right.equalTo(0)
            make.centerY.equalTo(titleLbl)
            make.height.height.equalTo(22)
        }
        
        contentV.addSubview(sureBtn)
        sureBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-10 - kHomeIndicatorHeight())
            make.height.equalTo(44)
            make.right.equalTo(-16)
            make.width.equalTo(kScaleBasicWidth(144))
        }
        
        let leftTotalLbl = UILabel.createSameLbl(text: "合计:", color: COLOR333333, font: UIFont.semibold(14))
        contentV.addSubview(leftTotalLbl)
        leftTotalLbl.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.bottom.equalTo(-20 - kHomeIndicatorHeight())
        }
        
        contentV.addSubview(totalPriceLbl)
        totalPriceLbl.snp.makeConstraints { make in
            make.left.equalTo(leftTotalLbl.snp.right).offset(4)
            make.centerY.equalTo(sureBtn)
        }
        
        let addressBGView = UIView()
        addressBGView.backgroundColor = UIColor(hexString: "#F9F9F9")
        addressBGView.layer.cornerRadius = 8
        addressBGView.layer.masksToBounds = true
        contentV.addSubview(addressBGView)
        addressBGView.snp.makeConstraints { make in
            make.top.equalTo(titleLbl.snp.bottom).offset(12)
            make.left.equalTo(titleLbl)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(96)
        }
        
        addressBGView.addSubview(usernameLbl)
        usernameLbl.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(20)
        }
        
        addressBGView.addSubview(addressLbl)
        addressLbl.snp.makeConstraints { make in
            make.top.equalTo(usernameLbl.snp.bottom).offset(8)
            make.left.equalTo(usernameLbl)
            make.right.equalTo(-40)
        }
        
        addressBGView.addSubview(addressGoImgView)
        addressGoImgView.snp.makeConstraints { make in
            make.top.equalTo(addressLbl)
            make.right.equalTo(-12)
            make.width.height.equalTo(24)
        }
        
        addressBGView.addSubview(addressBtn)
        addressBtn.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentV.addSubview(picImgView)
        picImgView.snp.makeConstraints { make in
            make.top.equalTo(addressBGView.snp.bottom).offset(12)
            make.left.equalTo(addressBGView)
            make.width.height.equalTo(88)
        }
        
        contentV.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(picImgView)
            make.left.equalTo(picImgView.snp.right).offset(8)
            make.right.equalTo(-16)
        }
        
        let tagsLbl = UILabel.createSameLbl(text: "官方正版/顺丰包邮", color: COLOR868A96, font: UIFont.normal(12))
        contentV.addSubview(tagsLbl)
        tagsLbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(8)
            make.left.equalTo(nameLbl)
        }
        
        contentV.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.left.equalTo(nameLbl)
            make.top.equalTo(tagsLbl.snp.bottom).offset(10)
        }
        
        let dayLbl = UILabel()
        dayLbl.text = "/天"
        dayLbl.textColor = COLORB8BED0
        dayLbl.font = UIFont.normal(10)
        contentV.addSubview(dayLbl)
        dayLbl.snp.makeConstraints { make in
            make.left.equalTo(priceLbl.snp.right)
            make.bottom.equalTo(priceLbl).offset(-4)
        }
        
        let pinLbl = UILabel.createSameLbl(text: "品质保障", color: COLOR000000, font: UIFont.semibold(16))
        contentV.addSubview(pinLbl)
        pinLbl.snp.makeConstraints { make in
            make.top.equalTo(picImgView.snp.bottom).offset(24)
            make.left.equalTo(picImgView).offset(8)
            make.height.equalTo(22)
        }
        
        let pinImgView = UIImageView(image: UIImage(named: "order_tags_bg"))
        contentV.addSubview(pinImgView)
        pinImgView.snp.makeConstraints { make in
            make.top.equalTo(pinLbl.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(32)
        }
        
        let rentTimeLength = UILabel.createSameLbl(text: "租赁时长", color: COLOR000000, font: UIFont.semibold(16))
        contentV.addSubview(rentTimeLength)
        rentTimeLength.snp.makeConstraints { make in
            make.left.height.equalTo(pinLbl)
            make.top.equalTo(pinImgView.snp.bottom).offset(16)
        }
        
        let leftStartDayBgView = UIView()
        leftStartDayBgView.backgroundColor = COLORF8F9FA
        leftStartDayBgView.layer.cornerRadius = 4
        leftStartDayBgView.layer.masksToBounds = true
        contentV.addSubview(leftStartDayBgView)
        leftStartDayBgView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(rentTimeLength.snp.bottom).offset(12)
            make.width.equalTo(148)
            make.height.equalTo(50)
        }
        
        let startStr = Date().dateString(withFormat: "yyyy/MM/dd")
        let leftStartDayLbl = UILabel.createSameLbl(text: startStr, color: COLOR868A96, font: UIFont.semibold(16))
        leftStartDayBgView.addSubview(leftStartDayLbl)
        leftStartDayLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let rightEndDayBgView = UIView()
        rightEndDayBgView.backgroundColor = COLORF8F9FA
        rightEndDayBgView.layer.cornerRadius = 4
        rightEndDayBgView.layer.masksToBounds = true
        contentV.addSubview(rightEndDayBgView)
        rightEndDayBgView.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.width.height.equalTo(leftStartDayBgView)
        }
        
        let endStr = Date().dateString(withFormat: "yyyy/MM/dd")
        let rightEndDayLbl = UILabel.createSameLbl(text: endStr, color: COLOR868A96, font: UIFont.semibold(16))
        rightEndDayBgView.addSubview(rightEndDayLbl)
        rightEndDayLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        contentV.addSubview(totalDaylbl)
        totalDaylbl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(leftStartDayBgView).offset(-4)
        }
        
        let dayBgImgView = UIImageView(image: UIImage(named: "order_day_bg"))
        contentV.addSubview(dayBgImgView)
        dayBgImgView.snp.makeConstraints { make in
            make.top.equalTo(totalDaylbl.snp.bottom).offset(-6)
            make.centerX.equalTo(totalDaylbl)
            make.width.equalTo(50)
            make.height.equalTo(6)
        }
        
        addressBtn.rx.controlEvent(.touchUpInside).subscribe { _ in
        }
        cancelBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.dismissAnimation()
        }.disposed(by: dBag)
        sureBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            
        }.disposed(by: dBag)

    }
    
    func loadData() {
        
        let attrText = NSAttributedString.configSpecialStyle(normalStr: "¥", specialStr: "299", font: UIFont.semibold(28), textColor: COLOR000000)
        totalPriceLbl.attributedText = attrText
        
        let attrText1 = NSAttributedString.configSpecialStyle(normalStr: "¥", specialStr: "29.9", font: UIFont.semibold(18), textColor: COLOR000000)
        priceLbl.attributedText = attrText1
        
        usernameLbl.text = "像林京味的芹菜  18602934995"
        addressLbl.text = "越秀集团IP吉祥物-超级越越-古田路9号-品牌创意/版权…"
        
        nameLbl.text = "越秀集团IP吉祥物-超级越越-古田路9号-品牌创意/版权…"
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
        bgV.backgroundColor = .init(hexString: "#000000")
        bgV.alpha = 0.6
        return bgV
    }()
    
    private lazy var contentV: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var cancelBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "order_close"), for: .normal)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
            btn.configuration = config
        } else {
            btn.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 16, bottom: 8, right: 16)
        }
        return btn
    }()
    
    private lazy var sureBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("立即购买", for: .normal)
        btn.setTitleColor(COLORFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.semibold(14)
        btn.layer.cornerRadius = 22
        btn.layer.masksToBounds = true
        btn.backgroundColor = COLOR333333
        return btn
    }()
    
    lazy var totalPriceLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.normal(10)
        lbl.textColor = COLORB8BED0
        return lbl
    }()
    
    lazy var usernameLbl: UILabel = {
        let lbl = UILabel.createSameLbl(text: "", color: UIColor(hexString: "#676767"), font: UIFont.normal(14))
        return lbl
    }()
    
    lazy var addressLbl: UILabel = {
        let lbl = UILabel.createSameLbl(text: "", color: COLOR333333, font: UIFont.semibold(14))
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var addressGoImgView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "order_adress_go"))
        imgV.isHidden = false
        return imgV
    }()
    
    lazy var addressBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var picImgView: UIImageView = {
        let imgV = UIImageView()
        imgV.backgroundColor = COLOR999999
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
        imgV.contentMode = .scaleAspectFit
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = COLOR333333
        lbl.font = UIFont.semibold(14)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.normal(10)
        lbl.textColor = COLORB8BED0
        return lbl
    }()
    
    lazy var totalDaylbl: UILabel = {
        let lbl = UILabel.createSameLbl(text: "30日", color: COLOR000000, font: UIFont.semibold(14))
        return lbl
    }()
}
