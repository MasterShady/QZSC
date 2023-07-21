//
//  QZSCCheckInController.swift
//  QZSC
//
//  Created by zzk on 2023/7/14.
//

import UIKit
import RxCocoa
import RxSwift
import CLImagePickerTool

class QZSCCheckInController: QZSCBaseController {
    
    var dataList: [UIImage] = [UIImage]()
    var lists: [Bool] = [Bool]() // 记录当前图片是否为空白添加占位图
    
    let dBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        configUI()
        configData()
    }
    
    func configData() {
        dataList.append(UIImage(named: "checkin_upload_empty")!)
        lists.append(true)
        collection.reloadData()
    }
    
    func configHasUploadUI() {
        for subView in view.subviews {
            subView.removeFromSuperview()
        }
        
        setNavBarUI()
        navTitle = "商家入驻"
        
        let lbl = UILabel.createSameLbl(text: "等待审核中", color: COLORA1A0AB, font: UIFont.semibold(18))
        view.addSubview(lbl)
        lbl.snp.makeConstraints { make in
            make.top.equalTo(300)
            make.centerX.equalToSuperview()
        }
    }
    
    func configUI() {
        navTitle = "商家入驻"
        
        let topBgImgView = UIImageView(image: UIImage(named: "checkin_top_bg"))
        view.addSubview(topBgImgView)
        var originY = -kStatusBarHeight - 15
        if kStatusBarHeight > 20 {
            originY = 0
        }
        topBgImgView.snp.makeConstraints { make in
            make.top.equalTo(originY)
            make.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(342)
        }
        
        let h = kScreenHeight - kNavBarFullHeight - kTabbarHeight() - 90
        
        let gradientView = UIView()
        gradientView.layer.cornerRadius = 24
        gradientView.layer.masksToBounds = true
        view.addSubview(gradientView)
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight + 90)
            make.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(h + kTabbarHeight())
        }
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: h + kTabbarHeight())
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.colors = [UIColor(hexString: "#AFFAFF").cgColor, COLORF6F8FA.cgColor]
        gradientView.layer.addSublayer(gradientLayer)
        
        view.addSubview(scroll)
        scroll.snp.makeConstraints { make in
            make.top.equalTo(kNavBarFullHeight + 90)
            make.left.equalTo(0)
            make.width.equalTo(kScreenWidth)
            make.height.equalTo(h)
        }
        
        let infoLbl = UILabel.createSameLbl(text: "必填项目", color: COLOR000000, font: UIFont.semibold(18))
        scroll.addSubview(infoLbl)
        infoLbl.snp.makeConstraints { make in
            make.top.equalTo(16)
            make.left.equalTo(32)
            make.height.equalTo(25)
        }
        
        let infoBgView = UIView()
        infoBgView.backgroundColor = COLORFFFFFF
        infoBgView.layer.cornerRadius = 8
        infoBgView.layer.masksToBounds = true
        scroll.addSubview(infoBgView)
        infoBgView.snp.makeConstraints { make in
            make.top.equalTo(infoLbl.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(238)
        }
        
        let applyLbl = UILabel.createSameLbl(text: "入驻申请描述", color: COLOR000000, font: UIFont.semibold(16))
        infoBgView.addSubview(applyLbl)
        applyLbl.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(16)
            make.height.equalTo(22)
        }
        
        infoBgView.addSubview(applyTV)
        applyTV.snp.makeConstraints { make in
            make.top.equalTo(applyLbl.snp.bottom).offset(8)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(44)
        }
        
        let phoneLbl = UILabel.createSameLbl(text: "联系方式", color: COLOR000000, font: UIFont.semibold(16))
        infoBgView.addSubview(phoneLbl)
        phoneLbl.snp.makeConstraints { make in
            make.top.equalTo(applyTV.snp.bottom).offset(16)
            make.left.height.equalTo(applyLbl)
        }
        
        infoBgView.addSubview(phoneTF)
        phoneTF.snp.makeConstraints { make in
            make.top.equalTo(phoneLbl.snp.bottom).offset(8)
            make.left.right.equalTo(applyTV)
            make.height.equalTo(22)
        }
        
        let typeLbl = UILabel.createSameLbl(text: "商品品类", color: COLOR000000, font: UIFont.semibold(16))
        infoBgView.addSubview(typeLbl)
        typeLbl.snp.makeConstraints { make in
            make.top.equalTo(phoneTF.snp.bottom).offset(16)
            make.left.height.equalTo(applyLbl)
        }
        
        infoBgView.addSubview(typeTF)
        typeTF.snp.makeConstraints { make in
            make.top.equalTo(typeLbl.snp.bottom).offset(16)
            make.left.right.height.equalTo(phoneTF)
        }
        
        let otherLbl = UILabel.createSameLbl(text: "选填项目", color: COLOR000000, font: UIFont.semibold(18))
        scroll.addSubview(otherLbl)
        otherLbl.snp.makeConstraints { make in
            make.top.equalTo(infoBgView.snp.bottom).offset(16)
            make.left.equalTo(32)
            make.height.equalTo(25)
        }
        
        let otherInfoBgView = UIView()
        otherInfoBgView.backgroundColor = COLORFFFFFF
        otherInfoBgView.layer.cornerRadius = 8
        otherInfoBgView.layer.masksToBounds = true
        scroll.addSubview(otherInfoBgView)
        otherInfoBgView.snp.makeConstraints { make in
            make.top.equalTo(otherLbl.snp.bottom).offset(12)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(276)
        }
        
        let productLbl = UILabel.createSameLbl(text: "商品图片（最多3张）", color: COLOR333333, font: UIFont.semibold(16))
        otherInfoBgView.addSubview(productLbl)
        productLbl.snp.makeConstraints { make in
            make.top.equalTo(12)
            make.left.equalTo(16)
            make.height.equalTo(22)
        }
        
        otherInfoBgView.addSubview(collection)
        collection.snp.makeConstraints { make in
            make.top.equalTo(productLbl.snp.bottom).offset(12)
            make.left.equalTo(productLbl)
            make.height.equalTo(90)
            make.width.equalTo(kScreenWidth - 64)
        }
        
        let cerLbl = UILabel.createSameLbl(text: "营业执照", color: COLOR333333, font: UIFont.semibold(16))
        otherInfoBgView.addSubview(cerLbl)
        cerLbl.snp.makeConstraints { make in
            make.top.equalTo(collection.snp.bottom).offset(6)
            make.left.height.equalTo(productLbl)
        }
        
        otherInfoBgView.addSubview(cerImgView)
        cerImgView.snp.makeConstraints { make in
            make.left.equalTo(cerLbl)
            make.top.equalTo(cerLbl.snp.bottom).offset(12)
            make.width.height.equalTo(80)
        }
        
        let joinBtn = UIButton(type: .custom)
        joinBtn.setTitle("提交申请", for: .normal)
        joinBtn.setTitleColor(COLORFFFFFF, for: .normal)
        joinBtn.titleLabel?.font = UIFont.semibold(14)
        joinBtn.backgroundColor = COLOR333333
        joinBtn.layer.cornerRadius = 24
        joinBtn.layer.masksToBounds = true
        view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints { make in
            make.bottom.equalTo(-kTabbarHeight() - 12)
            make.left.equalTo(16)
            make.width.equalTo(kScreenWidth - 32)
            make.height.equalTo(48)
        }
        joinBtn.rx.controlEvent(.touchUpInside).subscribe { [weak self] _ in
            guard let `self` = self else { return }
            if !QZSCLoginManager.shared.autoOpenLogin() {
                return
            }
            guard let phone = self.phoneTF.text else { return }
            guard let type = self.typeTF.text else { return }
            if self.applyTV.text.isNil {
                UMToast.show("申请描述不能为空")
                return
            }
            if phone.isNil {
                UMToast.show("联系方式不能为空")
                return
            }
            if type.isNil {
                UMToast.show("商品类别不能为空")
                return
            }
            QZSCCheckInViewModel.uploadBusinessCheckInDetails(desc: self.applyTV.text,
                                                              contack_num: phone,
                                                              good_type: type) { result in
                self.configHasUploadUI()
            }
        }.disposed(by: dBag)
        
        let tap1 = UITapGestureRecognizer()
        cerImgView.addGestureRecognizer(tap1)
        tap1.rx.event.subscribe { [weak self] _ in
            guard let `self` = self else { return }
            self.tool.cl_setupImagePickerWith(MaxImagesCount: 1) { (assets, cutImg) in
                self.cerImgView.image = cutImg
            }
        }.disposed(by: dBag)
        
        view.layoutIfNeeded()
        let contentH = otherInfoBgView.y + otherInfoBgView.height + 80
        let maxH = max(contentH, h + 1)
        scroll.contentSize = CGSize(width: kScreenWidth, height: maxH)
    }

    // MARK: -lazy
    lazy var scroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.showsVerticalScrollIndicator = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.contentInsetAdjustmentBehavior = .never
        return scroll
    }()
    
    lazy var applyTV: QZSCCustomTextView = {
        let tf = QZSCCustomTextView()
        tf.placeholder = "请填写15字以上描述，以便我们更好地为您提供帮助～"
        tf.placeholderColor = COLOR868A96
        tf.font = UIFont.normal(16)
        tf.textColor = COLOR333333
        return tf
    }()
    
    lazy var phoneTF: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.normal(16)
        let attr = NSAttributedString(string: "请填写您的微信或者手机号码", attributes: [NSAttributedString.Key.foregroundColor: COLOR868A96, NSAttributedString.Key.font: UIFont.normal(16)])
        tf.attributedPlaceholder = attr
        return tf
    }()
    
    lazy var typeTF: UITextField = {
        let tf = UITextField()
        tf.font = UIFont.normal(16)
        let attr = NSAttributedString(string: "请填写您的经营品类", attributes: [NSAttributedString.Key.foregroundColor: COLOR868A96, NSAttributedString.Key.font: UIFont.normal(16)])
        tf.attributedPlaceholder = attr
        return tf
    }()
    
    lazy var cerImgView: UIImageView = {
        let imgV = UIImageView(image: UIImage(named: "checkin_upload_empty"))
        imgV.isUserInteractionEnabled = true
        imgV.contentMode = .scaleAspectFill
        imgV.layer.cornerRadius = 4
        imgV.layer.masksToBounds = true
        return imgV
    }()
    
    lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let coll = UICollectionView(frame: .zero, collectionViewLayout: layout)
        coll.isScrollEnabled = false
        coll.dataSource = self
        coll.delegate = self
        coll.register(QZSCChenkInUploadImageCell.self)
        return coll
    }()
    
    private lazy var tool: CLImagePickerTool = {
        let tool = CLImagePickerTool()
        tool.isHiddenVideo = true
        tool.cameraOut = true
        tool.singleImageChooseType = .singlePicture
        tool.singleModelImageCanEditor = true
        return tool
    }()
}

extension QZSCCheckInController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(dataList.count, 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(QZSCChenkInUploadImageCell.self, indexPath: indexPath)
        cell.contentImg = dataList[indexPath.row]
        cell.showDelete = lists[indexPath.row]
        cell.deleteBlock = { [weak self] in
            guard let `self` = self else { return }
            self.dataList.remove(at: indexPath.row)
            self.lists.remove(at: indexPath.row)
            collectionView.reloadData()
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let result = lists[indexPath.row]
        if result {
            self.tool.cl_setupImagePickerWith(MaxImagesCount: 1) { [weak self] (assets, cutImg) in
                guard let `self` = self else { return }
                guard let img = cutImg else { return }
                self.dataList.insert(img, at: 0)
                self.lists.insert(false, at: 0)
                collectionView.reloadData()
            }
        }
    }
}
