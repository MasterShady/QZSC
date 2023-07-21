//
//  OrderCell.swift
//  QZSC
//
//  Created by lsy on 2023/7/18.
//

import UIKit

class OrderCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        self.backgroundColor = .clear
        uiConfigure()
        myAutoLayout()
    }
    var data: OrderListModel? {
        didSet {
            icon.kf.setImage(with: URL(string: QZSCAppEnvironment.shared.imageUrlApi + data!.goods_info!.list_pic))
            leftLabel.text = data?.goods_cate_name
            nameLbl.text = data?.goods_info?.name
            
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func uiConfigure() {
        contentView.addSubview(self.BgView)
        
        
    }
    func myAutoLayout() {
        BgView .snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.top.equalTo(SCALE_WIDTHS(value: 8))
            make.bottom.equalToSuperview()
            
        }
        
        BgView.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 43))
        }
        
        topView.addSubview(leftLabel)
        leftLabel.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.centerY.equalToSuperview()
        }
        
        topView.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.centerY.equalToSuperview()
        }
        
        topView.addSubview(lineView)
        lineView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.equalTo(SCALE_WIDTHS(value: 12))
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
    
        
        BgView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(SCALE_WIDTHS(value: 18))
            make.left.equalTo(SCALE_WIDTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 88))
            make.width.equalTo(SCALE_HEIGTHS(value: 88))

        }
        BgView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom).offset(SCALE_WIDTHS(value: 18))
            make.left.equalTo(icon.snp.right).offset(6)
            make.right.equalTo(-12)
            make.height.equalTo(42)
        }
        
        BgView.addSubview(propertyLB)
        propertyLB.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(6)
            make.top.equalTo(nameLbl.snp.bottom).offset(5)
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
        }
        BgView.addSubview(orderTimeLB)
        orderTimeLB.snp.makeConstraints { make in
            make.left.equalTo(icon.snp.right).offset(6)
            make.top.equalTo(propertyLB.snp.bottom).offset(5)
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
        }
        
        BgView.addSubview(rentTimeLB)
        rentTimeLB.snp.makeConstraints { make in
            make.top.equalTo(icon.snp.bottom).offset(14)
            make.left.equalTo(SCALE_WIDTHS(value: 12))
        }
        
        
        
        BgView.addSubview(priceLabel)
        priceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rentTimeLB)
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
        }
        
        BgView.addSubview(lineView2)
        lineView2.snp.makeConstraints { make in
            make.bottom.equalTo(-SCALE_HEIGTHS(value:56))
            make.left.equalTo(SCALE_WIDTHS(value: 12))
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 1))
        }
        
        BgView.addSubview(rightBtn)
        rightBtn.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 12))
            make.bottom.equalTo(-SCALE_HEIGTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 32))
            make.width.equalTo(SCALE_WIDTHS(value: 100))
        }
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    lazy var BgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = SCALE_WIDTHS(value: 8)
        view.layer.masksToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds  = true
        imageView.backgroundColor = .cyan
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    lazy var stateLabel: UILabel = {
        let label =  UILabel()
        
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hexString: "#08C9CA")
        label.text = "租赁中"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    lazy var leftLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = UIColor(hexString: "#000000")
        label.text = "越秀集团分类"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#EEEEEE")
        return view
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hexString: "#333333")
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.text = "越秀集团IP吉祥物-超级越越-古田路9号-品牌创意/版权…"
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var propertyLB: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hexString: "#868A96")
        label.text = "商品属性：属性1 | 属性2｜属性3"
        return label
    }()
    
    
    lazy var orderTimeLB: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hexString: "#868A96")
        label.text = "订单时间：2023/07/12 11:30"
        return label
    }()
    
    lazy var rentTimeLB: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hexString: "#868A96")
        label.text = "租赁时长：07/12-08/03 合计30日"
        return label
    }()
    
    
    
    lazy var priceLabel: UILabel = {
        let label =  UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = UIColor(hexString: "#333333")
        label.text = "合计：¥70.0"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    lazy var lineView2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hexString: "#EEEEEE")
        return view
    }()
    
    lazy var rightBtn: UIButton = {
        let button =  UIButton()
        button.backgroundColor = .clear
        button.layer.cornerRadius = SCALE_HEIGTHS(value: 16)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(hexString: "#868A96").cgColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
        button.setTitle("取消订单", for: .normal)
        return button
    }()
    
    
    
    
}
