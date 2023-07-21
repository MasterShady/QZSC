//
//  QZSCGoodsDetailsController.swift
//  QZSC
//
//  Created by zzk on 2023/7/17.
//

import UIKit
import RxCocoa
import RxSwift
import WebKit

class QZSCGoodsDetailsController: QZSCBaseController {
    @objc var produceId: Int = 0
    private var data: QZSCProductDetailsInfoModel?
    let dBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configNavUI()
        configUI()
        configData()
        loadData()
    }
    
    func configData() {
        let attrText = NSAttributedString.configSpecialStyle(normalStr: "¥", specialStr: "29.9", font: UIFont.semibold(18), textColor: COLOR000000)
        priceLbl.attributedText = attrText
        
        topBgImgView.backgroundColor = .yellow
        
        nameLbl.text = "越秀集团IP吉祥物-超级越越-古田路9号-品牌创意/版权…"
        
        //loadContentHtml()
    }
    
    func loadData() {
        UMProgressManager.showLoadingAnimation()
        QZSCHomeViewModel.loadHomeProductDetails(productId: produceId) { info in
            UMProgressManager.hide()
            guard let goods_info = info else { return }
            self.data = goods_info
            self.nameLbl.text = goods_info.name
            self.topBgImgView.kf.setImage(with: URL(string: QZSCAppEnvironment.shared.imageUrlApi + goods_info.list_pic))
            let attrText = NSAttributedString.configSpecialStyle(normalStr: "¥", specialStr: goods_info.price, font: UIFont.semibold(18), textColor: COLOR000000)
            self.priceLbl.attributedText = attrText
            self.collectBtn.isSelected = goods_info.is_collect
            self.tejiaBgImgView.isHidden = !goods_info.is_specail_price
            self.loadContentHtml()
        }
    }
    
    private func loadContentHtml() {
        let htmlString1 = """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>图文详情</title>

            <style>
                * {
                    margin: 0;
                    padding: 0;
                }
                div {
                    width: width;
                    margin-bottom: 10px;
                    font-weight: normal;
                    color: #333333;
                }
                li {
                    list-style: none;
                }
                ul {
                    margin: 0;
                    padding: 0;
                }
                img {
                    display: block;
                    vertical-align: middle;
                    width: 100%;
                }
            </style>
        </head>
        <body>
            <ul>
        """
        let htmlString2 = """
                </ul>
        </body>
        </html>
        """
        var contentStr = ""
        data!.content_pics.forEach { path in
            let url = QZSCAppEnvironment.shared.imageUrlApi + path
            let liTag1 = """
                <li><img src="
            """
            let liTag2 = """
                " alt=""></li>
            """
            contentStr = contentStr + liTag1 + url + liTag2
        }
        let resultHtml = htmlString1 + contentStr + htmlString2
        webView.loadHTMLString(resultHtml, baseURL: nil)
    }
    
    func configNavUI() {
        navBar.isHidden = true
    }
    
    func configUI() {
        view.backgroundColor = COLORF6F8FA
        
        // 底部工具栏
        let bottomBar = UIView()
        bottomBar.backgroundColor = COLORFFFFFF
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { make in
            make.trailing.bottom.leading.equalTo(0)
            make.height.equalTo(kHomeIndicatorHeight() + 64)
        }
        
        let btnWidth = kScaleBasicWidth(280)
        let buyBtn = UIButton(type: .custom)
        buyBtn.setTitle("立即购买", for: .normal)
        buyBtn.setTitleColor(COLORFFFFFF, for: .normal)
        buyBtn.titleLabel?.font = UIFont.semibold(14)
        buyBtn.backgroundColor = COLOR333333
        buyBtn.layer.cornerRadius = 22
        buyBtn.layer.masksToBounds = true
        bottomBar.addSubview(buyBtn)
        buyBtn.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.top.equalTo(10)
            make.width.equalTo(btnWidth)
            make.height.equalTo(44)
        }
        buyBtn.rx.controlEvent(.touchUpInside).subscribe { _ in
            let preview = QZSCOrderPreviewView(frame: UIScreen.main.bounds)
            preview.productInfo = self.data
            self.view.addSubview(preview)
            preview.showAnimation()
        }.disposed(by: dBag)
        
        let shopCarBtn = UIButton(type: .custom)
        shopCarBtn.setTitle("加入购物车", for: .normal)
        shopCarBtn.setTitleColor(COLOR333333, for: .normal)
        shopCarBtn.titleLabel?.font = UIFont.normal(14)
        shopCarBtn.layer.cornerRadius = 22
        shopCarBtn.layer.masksToBounds = true
        shopCarBtn.layer.borderWidth = 1
        shopCarBtn.layer.borderColor = UIColor(hexString: "#868A96").cgColor
        shopCarBtn.isHidden = true
        bottomBar.addSubview(shopCarBtn)
        shopCarBtn.snp.makeConstraints { make in
            make.right.equalTo(buyBtn.snp.left).offset(-8)
            make.top.width.height.equalTo(buyBtn)
        }
        shopCarBtn.rx.controlEvent(.touchUpInside).subscribe { _ in
            
        }.disposed(by: dBag)
        
        let kfBtn = UIButton(type: .custom)
        kfBtn.frame = CGRectMake(0, 0, 40, 64)
        kfBtn.setTitle("客服", for: .normal)
        kfBtn.setImage(UIImage(named: "home_kf"), for: .normal)
        kfBtn.setTitleColor(COLOR000000, for: .normal)
        kfBtn.titleLabel?.font = UIFont.normal(10)
        kfBtn.resizeImagePosition(poistion: .top, space: 5)
        bottomBar.addSubview(kfBtn)
        let originX = (kScreenWidth - kScaleBasicWidth(280) - 16 - 40) / 2
        kfBtn.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(originX)
            make.width.equalTo(40)
            make.height.equalTo(64)
        }
        kfBtn.rx.controlEvent(.touchUpInside).subscribe { _ in
            let ctl = QZSCKfController()
            QZSCControllerTool.currentNavVC()?.pushViewController(ctl, animated: true)
        }.disposed(by: dBag)
        
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.bottom.equalTo(bottomBar.snp.top)
        }
        
        scroll.addSubview(topBgImgView)
        topBgImgView.snp.makeConstraints { make in
            make.top.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(300 + kNavBarFullHeight)
        }
        
        let goBackBtn = UIButton(type: .custom)
        goBackBtn.setImage(UIImage(named: "home_back"), for: .normal)
        scroll.addSubview(goBackBtn)
        goBackBtn.snp.makeConstraints { make in
            make.top.equalTo(kStatusBarHeight + 12)
            make.left.equalTo(16)
            make.width.height.equalTo(24)
        }
        goBackBtn.rx.controlEvent(.touchUpInside).subscribe { _ in
            self.navigationController?.popViewController(animated: true)
        }.disposed(by: dBag)
        
        scroll.addSubview(collectBtn)
        collectBtn.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 40)
            make.top.width.height.equalTo(goBackBtn)
        }
        collectBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            QZSCHomeViewModel.collectProduct(productId: self.produceId, isCollect: !self.collectBtn.isSelected) { result in
                self.collectBtn.isSelected = !self.collectBtn.isSelected
                let msg = (self.collectBtn.isSelected ? "收藏成功" : "取消收藏成功")
                UMToast.show(msg)
            }
        }.disposed(by: dBag)
        
        let gradientView = UIView()
        scroll.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight + 220)
            make.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(80)
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 80)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor(hexString: "#FFFFFF", alpha: 0).cgColor, COLORF6F8FA.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        scroll.addSubview(infoBgView)
        scroll.addSubview(priceLbl)
        priceLbl.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight + 240)
            make.left.equalTo(32)
            make.height.equalTo(40)
        }
        
        let dayLbl = UILabel()
        dayLbl.text = "/天"
        dayLbl.textColor = COLORB8BED0
        dayLbl.font = UIFont.normal(10)
        scroll.addSubview(dayLbl)
        dayLbl.snp.makeConstraints { make in
            make.left.equalTo(priceLbl.snp.right)
            make.bottom.equalTo(priceLbl).offset(-12)
        }
        
        scroll.addSubview(tejiaBgImgView)
        tejiaBgImgView.snp.makeConstraints { make in
            make.centerY.equalTo(priceLbl)
            make.left.equalTo(dayLbl.snp.right).offset(5)
            make.width.equalTo(46)
            make.height.equalTo(24)
        }

        let tejiaLbl = UILabel()
        tejiaLbl.text = "特价"
        tejiaLbl.font = UIFont.semibold(12)
        tejiaLbl.textColor = COLOR000000
        tejiaBgImgView.addSubview(tejiaLbl)
        tejiaLbl.snp.makeConstraints { make in
            make.height.equalTo(17)
            make.center.equalToSuperview()
        }
        
        let tagBtn1 = UIButton(type: .custom)
        tagBtn1.setTitle("潮玩市集", for: .normal)
        tagBtn1.setTitleColor(COLORD48600, for: .normal)
        tagBtn1.isUserInteractionEnabled = false
        tagBtn1.layer.borderWidth = 1
        tagBtn1.layer.borderColor = UIColor(hexString: "#FFE900").cgColor
        tagBtn1.layer.cornerRadius = 2
        tagBtn1.layer.masksToBounds = true
        tagBtn1.backgroundColor = UIColor(hexString: "#FFFDE4")
        tagBtn1.titleLabel?.font = UIFont.normal(10)
        scroll.addSubview(tagBtn1)
        tagBtn1.snp.makeConstraints { make in
            make.left.equalTo(priceLbl)
            make.top.equalTo(priceLbl.snp.bottom).offset(8)
            make.width.equalTo(48)
            make.height.equalTo(18)
        }
        
        let tagBtn2 = UIButton(type: .custom)
        tagBtn2.setTitle("新品上市", for: .normal)
        tagBtn2.setTitleColor(COLOR00CDCE, for: .normal)
        tagBtn2.isUserInteractionEnabled = false
        tagBtn2.layer.borderWidth = 1
        tagBtn2.layer.borderColor = UIColor(hexString: "#00FEFF").cgColor
        tagBtn2.layer.cornerRadius = 2
        tagBtn2.layer.masksToBounds = true
        tagBtn2.backgroundColor = UIColor(hexString: "#E5FFFF")
        tagBtn2.titleLabel?.font = UIFont.normal(10)
        scroll.addSubview(tagBtn2)
        tagBtn2.snp.makeConstraints { make in
            make.left.equalTo(tagBtn1.snp.right).offset(6)
            make.centerY.width.height.equalTo(tagBtn1)
        }
        
        scroll.addSubview(nameLbl)
        nameLbl.snp.makeConstraints { make in
            make.left.equalTo(32)
            make.top.equalTo(tagBtn1.snp.bottom).offset(16)
            make.width.equalTo(kScreenWidth - 64)
        }
        
        let tagBgImgView = UIImageView(image: UIImage(named: "home_tag_bg"))
        let imgWidth = kScreenWidth - 64
        let imgHeight = (imgWidth / 312) * 32
        scroll.addSubview(tagBgImgView)
        tagBgImgView.snp.makeConstraints { make in
            make.top.equalTo(nameLbl.snp.bottom).offset(12)
            make.left.right.equalTo(nameLbl)
            make.height.equalTo(imgHeight)
        }
        
        let leftLocactionLbl = UILabel.createSameLbl(text: "配送至", color: COLOR868A96, font: UIFont.normal(14))
        scroll.addSubview(leftLocactionLbl)
        leftLocactionLbl.snp.makeConstraints { make in
            make.top.equalTo(tagBgImgView.snp.bottom).offset(12)
            make.left.equalTo(tagBgImgView)
            make.height.equalTo(20)
        }
        
        let rightLocactionGoImgView = UIImageView(image: UIImage(named: "home_arrow_go"))
        scroll.addSubview(rightLocactionGoImgView)
        rightLocactionGoImgView.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 48)
            make.centerY.equalTo(leftLocactionLbl)
            make.width.height.equalTo(16)
        }
        
        let locationLbl = UILabel.createSameLbl(text: "全国", color: COLOR333333, font: UIFont.semibold(14))
        scroll.addSubview(locationLbl)
        locationLbl.snp.makeConstraints { make in
            make.left.equalTo(leftLocactionLbl.snp.right).offset(20)
            make.centerY.equalTo(leftLocactionLbl)
        }
        
        let leftFreightLbl = UILabel.createSameLbl(text: "运费", color: COLOR868A96, font: UIFont.normal(14))
        scroll.addSubview(leftFreightLbl)
        leftFreightLbl.snp.makeConstraints { make in
            make.top.equalTo(leftLocactionLbl.snp.bottom).offset(12)
            make.left.height.equalTo(leftLocactionLbl)
        }
        
        let rightFreightGoImgView = UIImageView(image: UIImage(named: "home_arrow_go"))
        scroll.addSubview(rightFreightGoImgView)
        rightFreightGoImgView.snp.makeConstraints { make in
            make.left.equalTo(kScreenWidth - 48)
            make.centerY.equalTo(leftFreightLbl)
            make.width.height.equalTo(16)
        }
        
        let freightLbl = UILabel.createSameLbl(text: "免运费", color: COLOR333333, font: UIFont.semibold(14))
        scroll.addSubview(freightLbl)
        freightLbl.snp.makeConstraints { make in
            make.left.equalTo(locationLbl)
            make.centerY.equalTo(leftFreightLbl)
        }
        infoBgView.snp.makeConstraints { make in
            make.top.equalTo(priceLbl).offset(-20)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.bottom.equalTo(leftFreightLbl).offset(24)
        }
        
        
        let detailsLbl = UILabel.createSameLbl(text: "图文详情", color: COLOR333333, font: UIFont.semibold(16))
        scroll.addSubview(detailsLbl)
        detailsLbl.snp.makeConstraints { make in
            make.top.equalTo(infoBgView.snp.bottom).offset(16)
            make.left.equalTo(24)
            make.height.equalTo(22)
        }
        
        scroll.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(detailsLbl.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(800)
        }
    }

    // MARK: - lazy
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    lazy var topBgImgView: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
    lazy var collectBtn: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: "home_collect_nor"), for: .normal)
        btn.setImage(UIImage(named: "home_collect_sel"), for: .selected)
        return btn
    }()
    
    lazy var infoBgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = COLORFFFFFF
        return view
    }()
    
    lazy var priceLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.normal(10)
        lbl.textColor = COLORB8BED0
        return lbl
    }()
    
    lazy var tejiaBgImgView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "home_tejia_bg"))
        return imgV
    }()
    
    lazy var nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = COLOR333333
        lbl.font = UIFont.semibold(16)
        lbl.numberOfLines = 0
        return lbl
    }()
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let wb = WKWebView(frame: .zero, configuration: webConfiguration)
        wb.scrollView.isScrollEnabled = false
        wb.navigationDelegate = self
        wb.scrollView.bounces = false
        wb.scrollView.showsVerticalScrollIndicator = false
        wb.scrollView.showsHorizontalScrollIndicator = false
        return wb
    }()
}

extension QZSCGoodsDetailsController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        var webH = 0.0
        // 获取内容实际高度
        webView.evaluateJavaScript("document.body.scrollHeight") { [unowned self] (result, error) in
            if let tempH = result as? Double {
                webH = tempH
            }

            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                let originX = webView.y
                let h = max(kScreenHeight - kHomeIndicatorHeight() - 64.0, originX + webH)
                self.scroll.contentSize = CGSize(width: kScreenWidth, height: h + 1)
                self.webView.snp.updateConstraints { make in
                    make.height.equalTo(webH)
                }
            }
        }
        
    }
    
}
