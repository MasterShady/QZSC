

import UIKit

class MineAddressCell: UITableViewCell {
    
    var nameLB:UILabel!
    var phoneLB:UILabel!
    var addressLB:UILabel!
    var revampImage:UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addressUI()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var addressList:AddressListModel?{
        didSet{
            nameLB.text = addressList?.uname
            phoneLB.text = addressList?.phone
            addressLB.text = addressList?.address_area
                .appending(addressList!.address_detail)
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
