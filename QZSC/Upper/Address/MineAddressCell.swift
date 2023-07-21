

import UIKit

class MineAddressCell: UITableViewCell {
    
    var nameLB:UILabel!
    var phoneLB:UILabel!
    var addressLB:UILabel!
    var revampImage:UIButton!
    var newImgView: UIImageView!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addressUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addressList:AddressListModel?{
        didSet{
            guard let data = addressList else { return }
            nameLB.text = data.uname
            phoneLB.text = data.phone
            addressLB.text = data.address_area
                .appending(data.address_detail)
            newImgView.isHidden = (data.is_default != 1)
        }
    }
    
    func addressUI(){
        
        nameLB = UILabel(frame: CGRect.zero)
        
        nameLB.textColor = UIColor(hexString: "333333")
        nameLB.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        contentView.addSubview(nameLB)
        nameLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.top.equalTo(SCALE_HEIGTHS(value: 15))
        }
        
        phoneLB = UILabel(frame: CGRect.zero)
        
        phoneLB.textColor = UIColor(hexString: "333333")
        phoneLB.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
//        phoneLB.lineBreakMode = .byTruncatingMiddle
        contentView.addSubview(phoneLB)
        phoneLB.snp.makeConstraints { make in
            make.left.equalTo(nameLB.snp.right).offset(SCALE_WIDTHS(value: 15))
            make.top.equalTo(SCALE_HEIGTHS(value: 15))
//            make.width.equalTo(SCALE_WIDTHS(value: 85))
        }
        
        
        
        addressLB = UILabel(frame: CGRect.zero)
        addressLB.textColor = UIColor(hexString: "999999")
        addressLB.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        contentView.addSubview(addressLB)
        addressLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.right.equalTo(-SCALE_WIDTHS(value: 15))
            make.top.equalTo(nameLB.snp.bottom).offset(SCALE_HEIGTHS(value: 10))
        }
        
        revampImage = UIButton(frame: CGRect.zero)
        
        revampImage.setBackgroundImage(UIImage(named: "xiugai"), for: .normal)
        contentView.addSubview(revampImage)
        revampImage.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 18))
            make.height.equalTo(SCALE_WIDTHS(value: 18))
            make.width.equalTo(SCALE_WIDTHS(value: 18))
            make.centerY.equalToSuperview()
        }
        
        newImgView = UIImageView(image: UIImage(named: "home_cell_new_bg"))
        newImgView.isHidden = true
        contentView.addSubview(newImgView)
        newImgView.snp.makeConstraints { make in
            make.left.equalTo(phoneLB.snp.right).offset(4)
            make.centerY.equalTo(phoneLB)
            make.width.equalTo(32)
            make.height.equalTo(18)
        }
        
        let newLbl = UILabel()
        newLbl.text = "默认"
        newLbl.font = UIFont.medium(10)
        newLbl.textColor = COLOR333333
        newImgView.addSubview(newLbl)
        newLbl.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        let line = UIView(frame: CGRect.zero)
        line.backgroundColor = UIColor(hexString: "EDEDED")
        contentView.addSubview(line)
        line.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 15))
            make.right.equalTo(-SCALE_WIDTHS(value: 15))
            make.bottom.equalToSuperview()
            make.height.equalTo(SCALE_WIDTHS(value: 1))
        }
        
    }
   
}
