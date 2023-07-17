//
//  QZSCHomeListCell.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/17.
//

import UIKit

class QZSCHomeListCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configUI()
        configData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configData() {
        picImgView.backgroundColor = COLOR999999
        
        let attrText = NSAttributedString.configSpecialStyle(normalStr: "¥", specialStr: "29.9", font: UIFont.semibold(18), textColor: COLOR000000)
        priceLbl.attributedText = attrText
        
        nameLbl.text = "越秀集团IP吉祥物-超级越越-古田路9号-品牌创意/版权…"
    }
    
    func configUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        let bgView = UIView()
        bgView.backgroundColor = COLORFFFFFF
        bgView.layer.cornerRadius = 8
        bgView.layer.masksToBounds = true
        contentView.addSubview(bgView)
        bgView.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.top.equalTo(4)
            make.bottom.equalTo(-4)
            make.width.equalTo(kScreenWidth - 32)
        }
        
        bgView.addSubview(picImgView)
        picImgView.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(88)
        }
        
        let newImgView = UIImageView(image: UIImage(named: "home_cell_new_bg"))
        picImgView.addSubview(newImgView)
        newImgView.snp.makeConstraints { make in
            make.top.left.equalTo(0)
            make.width.equalTo(36)
            make.height.equalTo(14)
        }
        
        let newLbl = UILabel()
        newLbl.text = "NEW！"
        newLbl.font = UIFont.medium(10)
        newLbl.textColor = COLOR333333
        newImgView.addSubview(newLbl)
        newLbl.snp.makeConstraints { make in
            make.left.equalTo(4)
            make.centerY.equalToSuperview()
        }
        
        bgView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(picImgView).offset(1)
            make.left.equalTo(picImgView.snp.right).offset(8)
            make.right.equalTo(-12)
            make.height.lessThanOrEqualTo(40)
        }
        
        let tagImgView1 = UIImageView(image: UIImage(named: "home_cell_cwjs"))
        bgView.addSubview(tagImgView1)
        tagImgView1.snp.makeConstraints { make in
            make.left.equalTo(nameLbl)
            make.top.equalTo(nameLbl.snp.bottom).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        let tagImgView2 = UIImageView(image: UIImage(named: "home_cell_xpss"))
        bgView.addSubview(tagImgView2)
        tagImgView2.snp.makeConstraints { make in
            make.left.equalTo(tagImgView1.snp.right).offset(5)
            make.width.height.top.equalTo(tagImgView1)
        }
        
        bgView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.left.equalTo(nameLbl)
            make.bottom.equalTo(picImgView)
        }
        
        let dayLbl = UILabel()
        dayLbl.text = "/天"
        dayLbl.textColor = COLORB8BED0
        dayLbl.font = UIFont.normal(10)
        bgView.addSubview(dayLbl)
        dayLbl.snp.makeConstraints { make in
            make.left.equalTo(priceLbl.snp.right)
            make.bottom.equalTo(priceLbl).offset(-4)
        }
    }

    // MARK: - lazy
    lazy var picImgView: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        imgV.layer.cornerRadius = 8
        imgV.layer.masksToBounds = true
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
}
