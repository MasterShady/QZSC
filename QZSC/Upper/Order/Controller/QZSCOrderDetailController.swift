//
//  QZSCOrderDetailController.swift
//  QZSC
//
//  Created by lsy on 2023/7/18.
//

import UIKit

class QZSCOrderDetailController: QZSCBaseController {
    var data: OrderListModel?
    var goodsView:UIView!
    var messageView:UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navTitle = "订单详情"
        self.view.backgroundColor = UIColor(hexString: "#F4F6F9")
        detailUI()
        messageUI()
//        serviceViewUI()
        
        configData()

        // Do any additional setup after loading the view.
    }
    
    func configData(){
        guard let data = data else {return}
        nameLbl.text = data.goods_info?.name
        icon.kf.setImage(with: URL(string: QZSCAppEnvironment.shared.imageUrlApi + data.goods_info!.list_pic))
        
        let row = "¥" + data.price + "/天"
        let attrStr = NSMutableAttributedString(string: row)
        attrStr.setAttributes([
            .foregroundColor: UIColor.init(hexString: "#B8BED0"),
            .font: UIFont.systemFont(ofSize: 10)
        ], range: .init(location: 0, length: row.count))
        
        attrStr.setAttributes([
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ], range: (row as NSString).range(of: data.price))
        
        priceLbl.attributedText = attrStr
    }
    
    func detailUI(){
        
        let leftImage = UIImageView(image: UIImage(named: "orderBg"))
        self.view.addSubview(leftImage)
        leftImage.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(SCALE_HEIGTHS(value: 342))
            
        }
        
        let stateLB = UILabel()
        stateLB.text = "租赁中"
        stateLB.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        stateLB.textColor = UIColor(hexString: "333333")
        self.view.addSubview(stateLB)
        stateLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 24))
            make.top.equalTo(SCALE_HEIGTHS(value: 30) + NAV_HEIGHT)
        }
        
        goodsView = UIView()
        
        goodsView.backgroundColor = UIColor(hexString: "#FFFFFF")
        goodsView.layer.cornerRadius = SCALE_WIDTHS(value: 8)
        goodsView.layer.masksToBounds = true
        
        self.view.addSubview(goodsView)
        goodsView.snp.makeConstraints { make in
            make.top.equalTo(SCALE_HEIGTHS(value: 88) + NAV_HEIGHT)
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 112))
        }
        
//        icon.kf.setImage(with: URL(string: LolmDFHttpConfig.shared.getImgHost() + list!.goods_info!.list_pic))
        icon.backgroundColor = UIColor.cyan
        goodsView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.top.equalTo(SCALE_WIDTHS(value: 17))
            make.left.equalTo(SCALE_WIDTHS(value: 12))
            make.height.equalTo(SCALE_HEIGTHS(value: 88))
            make.width.equalTo(SCALE_HEIGTHS(value: 88))

        }
        nameLbl.text = "越秀集团IP吉祥物-超级越越-…"
        goodsView.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.top.equalTo(SCALE_WIDTHS(value: 15))
            make.left.equalTo(icon.snp.right).offset(12)
            make.right.equalTo(-12)
        }
        
        let lbl = UILabel()
        lbl.text = ""
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textColor = .init(hexString: "#A1A0AB")
        goodsView.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(5)
            make.left.equalTo(nameLbl)
        }
        
        let tagImgView1 = UIImageView(image: UIImage(named: "home_cell_cwjs"))
        goodsView.addSubview(tagImgView1)
        tagImgView1.snp.makeConstraints { make in
            make.left.equalTo(nameLbl)
            make.top.equalTo(lbl.snp.bottom).offset(5)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        
        let tagImgView2 = UIImageView(image: UIImage(named: "home_cell_xpss"))
        goodsView.addSubview(tagImgView2)
        tagImgView2.snp.makeConstraints { make in
            make.left.equalTo(tagImgView1.snp.right).offset(5)
            make.width.height.top.equalTo(tagImgView1)
        }
        
        
        let attrStr = NSAttributedString.replaceSingleSpecialStyle(originStr: "¥29.9/天", specialStr: "29.9", font: UIFont.systemFont(ofSize: 18, weight: .semibold), textColor: .init(hexString: "#000000"))
        priceLbl.attributedText = attrStr
        goodsView.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.equalTo(tagImgView1.snp.bottom).offset(5)
            make.left.equalTo(lbl)
        }
        
    }
    
    func messageUI(){
        
        let titleLB = UILabel()
        titleLB.text = "订单信息"
        titleLB.font =  UIFont.systemFont(ofSize: 16, weight: .semibold)
        titleLB.textColor = .init(hexString: "#333333")
        self.view.addSubview(titleLB)
        titleLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 24))
            make.top.equalTo(goodsView.snp.bottom).offset(SCALE_HEIGTHS(value: 16))

        }
        
         messageView = UIView()
        messageView.backgroundColor = UIColor(hexString: "#FFFFFF")
        messageView.layer.cornerRadius = SCALE_WIDTHS(value: 8)
        messageView.layer.masksToBounds = true

        self.view.addSubview(messageView)
        messageView.snp.makeConstraints { make in
            make.top.equalTo(titleLB.snp.bottom).offset(SCALE_HEIGTHS(value: 12))
            make.left.equalTo(SCALE_WIDTHS(value: 16))
            make.right.equalTo(-SCALE_WIDTHS(value: 16))
            make.height.equalTo(SCALE_HEIGTHS(value: 152))
        }
        
        showCellViewUI(rightTitle: "订单编号", contentStr: data!.order_sn, top: 0)
        showCellViewUI(rightTitle: "创建时间", contentStr: data!.create_time, top: 35)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let startDate = dateFormatter.date(from: data!.start_date)!
        let endDate = dateFormatter.date(from: data!.end_date)!
        showCellViewUI(rightTitle: "租赁时长", contentStr: "\(startDate.dateString(withFormat: "YYYY/MM/dd"))-\(endDate.dateString(withFormat: "YYYY/MM/dd"))", top: 70)
        
        showCellViewUI(rightTitle: "需要支付", contentStr: String(format: "¥%.2f", data!.amount), top: 105)
        
                let button =  UIButton()
                button.backgroundColor = .clear
                button.layer.cornerRadius = SCALE_HEIGTHS(value: 22)
                button.layer.borderWidth = 1
                button.layer.borderColor = UIColor(hexString: "#868A96").cgColor
                button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
                button.setTitle("取消订单", for: .normal)
                button.addTarget(self, action: #selector(BtnClickAction), for: .touchUpInside)
                button.setTitleColor(UIColor(hexString: "#333333"), for: .normal)
                self.view.addSubview(button)
                button.snp.makeConstraints { make in
                    make.right.equalTo(-SCALE_WIDTHS(value: 16))
                    make.left.equalTo(SCALE_WIDTHS(value: 16))
                    make.top.equalTo(messageView.snp.bottom).offset(SCALE_HEIGTHS(value: 75))
                    make.height.equalTo(SCALE_HEIGTHS(value: 44))
                }
        

    }
    
    @objc private func BtnClickAction() {
        
        let alertController = UIAlertController(title: "", message: "确认取消订单?", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "我再想想", style: UIAlertAction.Style.cancel, handler: nil )
        let okAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (ACTION) in
            QZSCOrderViewModel.loadOrderCancel(order_id: self.data!.id) { code in
                if(code == true){
                    UMToast.show("取消成功")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
               alertController.addAction(cancelAction);
               alertController.addAction(okAction);
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showCellViewUI(rightTitle: String,contentStr:String,top:CGFloat) {
        let collectView = UIView.init(frame: CGRect.zero)
        messageView.addSubview(collectView)
        collectView.backgroundColor = UIColor.white
        collectView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(SCALE_HEIGTHS(value: top))
            make.height.equalTo(SCALE_HEIGTHS(value: 45))
        }
        let collectLB = UILabel.init(frame: CGRect.zero)
        collectLB.text = rightTitle
        collectLB.textColor = UIColor(hexString: "#868A96")
        collectLB.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        collectView.addSubview(collectLB)
        collectLB.snp.makeConstraints { make in
            make.left.equalTo(SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
        let rightLB = UILabel.init(frame: CGRect.zero)
        
        rightLB.text = contentStr
        rightLB.textColor = UIColor(hexString: "#333333")
        rightLB.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        collectView.addSubview(rightLB)
        rightLB.snp.makeConstraints { make in
            make.right.equalTo(-SCALE_WIDTHS(value: 10))
            make.centerY.equalTo(collectView).offset(SCALE_WIDTHS(value: 0))
        }
    }
    
    lazy var icon: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .cyan
        imageView.layer.cornerRadius = SCALE_HEIGTHS(value: 8)
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        
        lbl.textColor = .init(hexString: "#333333")
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        lbl.numberOfLines = 2
        return lbl
    }()
    
    lazy var typeLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .white
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        lbl.backgroundColor = .init(hexString: "#858CFF")
        lbl.layer.cornerRadius = 4
        lbl.layer.masksToBounds = true
        return lbl
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .init(hexString: "#B8BED0")
        lbl.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        return lbl
    }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
