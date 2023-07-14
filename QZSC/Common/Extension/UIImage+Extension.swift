//
//  UIImage+Extension.swift
//  DF_MSZ
//
//  Created by fanyebo on 2022/12/21.
//

import UIKit

extension UIImage {
    
    // 加载不同moudle模块的png图片
    public static func image(named name: String, bundleName resourceBundle: String) -> UIImage? {
        let resourceBundlePath = Bundle.main.path(forResource: resourceBundle, ofType: "bundle")
        if let path = resourceBundlePath {
            return UIImage(named: name, in: Bundle.init(path: path), compatibleWith: nil)
        }
        return nil
    }
    
    // 将颜色转换为image
    public static func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    // 将string转换为image
    public static func imageWithString(_ str: String, _ attributes: [NSAttributedString.Key: Any], _ size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        (str as NSString).draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height), withAttributes: attributes)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    // 将view转换为iamge
    public static func imageWithView(_ view: UIView) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(view.size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        guard let cont = context else { return nil }
        view.layer.render(in: cont)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage{
     func resizeImage() -> UIImage{
         
         let maxWidth: CGFloat = 160
         let maxHeight: CGFloat = 160
       let width:CGFloat = self.size.width
       let height:CGFloat = self.size.height
       let scale:CGFloat = width/height
       var sizeChange:CGSize = CGSize()
       if width <= maxWidth && height <= maxHeight{
       //图片宽或者高均小于或等于1280时图片尺寸保持不变，不改变图片大小
           return self
       }else if width > maxWidth || height > maxHeight {
           if scale <= 2 && scale >= 1 {
               //比例为1和2之间,宽比高长
               let changedWidth:CGFloat = maxHeight
               let changedheight:CGFloat = changedWidth / scale
               sizeChange = CGSize(width: changedWidth, height: changedheight)
           }else if scale >= 0.5 && scale <= 1 {
                //比例为0.5和1之间,高比宽长
               let changedheight:CGFloat = maxHeight
               let changedWidth:CGFloat = changedheight * scale
               sizeChange = CGSize(width: changedWidth, height: changedheight)
           }else if width > maxWidth && height > maxHeight {
               //宽高都大于1280
               if scale > 2 {
                   //高的值比较小
                   let changedheight:CGFloat = maxHeight
                   let changedWidth:CGFloat = changedheight * scale
                   sizeChange = CGSize(width: changedWidth, height: changedheight)
               }else if scale < 0.5{
                   //宽的值比较小
                   let changedWidth:CGFloat = maxWidth
                   let changedheight:CGFloat = changedWidth / scale
                   sizeChange = CGSize(width: changedWidth, height: changedheight)
               }
           }else {
               //d, 宽或者高，只有一个大于1280，并且宽高比超过2
               if self.size.width>self.size.height{
                   //宽比高长,选择高压缩,640可以自己调整(超长图的宽高尽量小点,避免尺寸太大,比如说12400*1280)
                   if self.size.height>80{
                       let changedheight:CGFloat = 80
                       let changedWidth:CGFloat = changedheight * scale
                       sizeChange = CGSize(width: changedWidth, height: changedheight)
                   }else{
                       return self
                   }
               }else{
                   //高比宽长,选择宽压缩
                   if self.size.width>80{
                       let changedWidth:CGFloat = 80
                       let changedheight:CGFloat = changedWidth / scale
                       sizeChange = CGSize(width: changedWidth, height: changedheight)
                   }else{
                       return self
                   }
               }
           }
       }
       //下面流程化操作
       UIGraphicsBeginImageContext(sizeChange)
       self.draw(in: CGRect(x: 0, y: 0, width: sizeChange.width, height: sizeChange.height))
       guard let resizedImg = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
       UIGraphicsEndImageContext()
       return resizedImg
     }
}
