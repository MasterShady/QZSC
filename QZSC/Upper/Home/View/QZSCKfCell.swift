//
//  QZSCKfCell.swift
//  QZSC
//
//  Created by fanyebo on 2023/7/19.
//

import UIKit

class QZSCKfCell: UITableViewCell {
    
    var data: String? {
        didSet {
            descL.text = data
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(imgV)
        contentView.addSubview(descL)
        
        imgV.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(14)
            make.height.width.equalTo(40)
        }
        descL.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(imgV.snp.right).offset(18)
            make.right.equalTo(-14)
            make.bottom.equalTo(-15)
            make.height.greaterThanOrEqualTo(20)
        }
    }
    
    // MARK: - lazy
    private lazy var imgV: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "kf_icon"))
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    private lazy var descL: UILabel = {
        let lbl = UILabel()
        lbl.textColor = COLOR333333
        lbl.font = UIFont.normal(14)
        return lbl
    }()
}

class QZSCSpeakCell: UITableViewCell {

    var data: String? {
        didSet {
            descL.text = data
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        selectionStyle = .none
        backgroundColor = .clear
        
        contentView.addSubview(imgV)
        contentView.addSubview(descL)
        
        imgV.snp.makeConstraints { make in
            make.right.equalTo(-14)
            make.height.width.equalTo(40)
            make.centerY.equalToSuperview()
        }

        descL.snp.makeConstraints { make in
            make.top.equalTo(20)
            make.right.equalTo(imgV.snp.left).offset(-18)
            make.width.lessThanOrEqualToSuperview().offset(-150)
            make.bottom.equalTo(-20)
            make.height.greaterThanOrEqualTo(20)
        }
    }
    
    // MARK: - lazy
    private lazy var imgV: UIImageView = {
        let imgV = UIImageView()
        imgV.image = UIImage(named: "spearker_icon")
        imgV.layer.cornerRadius = 20
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    private lazy var descL: UILabel = {
        let lbl = UILabel()
        lbl.textColor = COLOR333333
        lbl.font = UIFont.normal(14)
        lbl.numberOfLines = 0
        return lbl
    }()

}
