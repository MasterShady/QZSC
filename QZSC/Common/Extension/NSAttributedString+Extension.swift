//
//  NSAttributedString+Extension.swift
//  DF_MSZ
//
//  Created by zzk on 2022/12/21.
//

import UIKit

extension NSAttributedString {
    
    // 两个字符串拼接，不同的颜色样式
    // noraml前半段字符串，special后半段字符串
    public class func configSpecialStyle(normalStr: String, specialStr: String, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let fullStr = normalStr + specialStr
        let myAttribute = [NSAttributedString.Key.foregroundColor: textColor,
                           NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        let attString = NSMutableAttributedString(string: fullStr)
        attString.addAttributes(myAttribute, range: NSRange.init(location: normalStr.count, length: specialStr.count))
        return attString as! Self
    }
    
    // 查找 单个 特定文本，替换其颜色样式
    public class func replaceSingleSpecialStyle(originStr: String, specialStr: String, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let range = (originStr as NSString).range(of: specialStr)
        let attributedString = NSMutableAttributedString(string:originStr)
        let myAttribute = [NSAttributedString.Key.foregroundColor: textColor,
                           NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
        attributedString.addAttributes(myAttribute, range: range)
        return attributedString
    }
    
    // 查找 全部 特定文本，替换其颜色样式
    public class func replaceAllSpecialStyle(originStr: String, specialStr: String, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string:originStr)
        let ranges = originStr.matchStrRanges(specialStr)
        for r in ranges {
            let myAttribute = [NSAttributedString.Key.foregroundColor: textColor,
                               NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
            attributedString.addAttributes(myAttribute, range: r)
        }
        return attributedString
    }
    
    // 文字之间用 ｜ 分隔开，调整 ｜ 样式
    public class func replaceAllSpecialStyle(originStr: String, specialStr: String, font: UIFont, textColor: UIColor, offset: CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string:originStr)
        let ranges = originStr.matchStrRanges(specialStr)
        for r in ranges {
            let myAttribute = [NSAttributedString.Key.foregroundColor: textColor,
                               NSAttributedString.Key.font: font,
                               NSAttributedString.Key.baselineOffset: offset] as [NSAttributedString.Key: Any]
            attributedString.addAttributes(myAttribute, range: r)
        }
        return attributedString
    }
    
    // 中划横线文本
    public class func centerLineStyle(orininStr: String, font: UIFont, textColor: UIColor) -> NSAttributedString {
        let attribute = [NSAttributedString.Key.foregroundColor: textColor,
                         NSAttributedString.Key.font: font] as [NSAttributedString.Key: Any]
        let priceString = NSMutableAttributedString.init(string: orininStr, attributes: attribute)
        priceString.addAttribute(.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: orininStr.count))
        return priceString
    }
}
