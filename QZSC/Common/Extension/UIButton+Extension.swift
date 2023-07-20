//
//  UIButton+Extension.swift
//  DF_MSZ
//
//  Created by zzk on 2022/12/21.
//

import UIKit

@objc public enum ButtonImagePosition: Int {
    case left
    case top
    case bottom
    case right
    case rightBottom
}

@objc public extension UIButton {
    func resizeImagePosition(poistion: ButtonImagePosition, space: CGFloat = 5) {
        /**
         *  知识点：titleEdgeInsets是title相对于其上下左右的inset，跟tableView的contentInset是类似的，
         *  如果只有title，那它上下左右都是相对于button的，image也是一样；
         *  如果同时有image和label，那这时候image的上左下是相对于button，右边是相对于label的；title的上右下是相对于button，左边是相对于image的。
         *  titleEdgeInsets、imageEdgeInsets将在iOS 15.0版本以上被废弃
         */
//        if #available(iOS 15.0, *) {
//            var config = UIButton.Configuration.tinted()
//            switch poistion {
//            case .left:
//                config.imagePlacement = .leading
//            case .right:
//                config.imagePlacement = .trailing
//            case .top:
//                config.imagePlacement = .top
//            case .bottom:
//                config.imagePlacement = .bottom
//            case .rightBottom:
//                config.imagePlacement = .bottom
//            }
//            config.imagePadding = space
//            self.configuration = config
//            return
//        }
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWidth = imageView?.image?.size.width ?? 0.0
        let imageHeight = imageView?.image?.size.height ?? 0.0

        // iOS 8以后直接去 size 会取不到值
        let labelWidth = self.titleLabel?.intrinsicContentSize.width ?? 0.0
        let labelHeight = self.titleLabel?.intrinsicContentSize.height ?? 0.0

        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.zero
        var labelEdgeInsets = UIEdgeInsets.zero

        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch poistion {
        case .top:
            imageEdgeInsets = UIEdgeInsets(top: -labelHeight - space / 2.0, left: 0, bottom: 0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth, bottom: -imageHeight - space / 2.0, right: 0)
        case .left:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space / 2.0, bottom: 0, right: space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space / 2.0, bottom: 0, right: -space / 2.0)
        case .bottom:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -labelHeight - space / 2.0, right: -labelWidth)
            labelEdgeInsets = UIEdgeInsets(top: -imageHeight - space / 2.0, left: -imageWidth, bottom: 0, right: 0)
        case .right:
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
        case .rightBottom:
            if imageHeight < labelHeight {
                imageEdgeInsets = UIEdgeInsets(top: labelHeight - imageHeight, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            } else {
                imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth + space / 2.0, bottom: 0, right: -labelWidth - space / 2.0)
            }
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - space / 2.0, bottom: 0, right: imageWidth + space / 2.0)
        }

        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
    }

}


extension UIButton {
    /// 登录注册页通用 登录/注册 按钮
    class func createCommonLoginModuleBtn(title: String?) -> UIButton {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(COLORFFFFFF, for: .normal)
        btn.titleLabel?.font = UIFont.medium(16)
        btn.layer.cornerRadius = 8
        btn.layer.masksToBounds = true
        btn.backgroundColor = COLOR333333
        return btn
    }
}
