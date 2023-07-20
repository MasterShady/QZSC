//
//  String+Extension.swift
//  DF_MSZ
//
//  Created by zzk on 2022/12/21.
//

import UIKit
import CommonCrypto

extension String {
    
    // 获取字符串 文字宽度
    public func textSize(_ font: UIFont, height: CGFloat) -> CGSize {
        return self.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                                 attributes: [.font: font],
                                 context: nil).size
    }
    
    // 获取字符串 文字高度
    public func textSize(_ font: UIFont, width: CGFloat) -> CGSize {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin,
                                 attributes: [.font: font],
                                 context: nil).size
    }
    
    // 字符串 转 Int
    public func toInt() -> Int {
        return Int(self) ?? 0
    }
    
    // 判断字符串全部为中文, true：全中文；false：不是全中文
    public func isPureChinese() -> Bool {
        let match: String = "[\\u4e00-\\u9fa5]+$"
        let predicate = NSPredicate(format: "SELF matches %@", match)
        return predicate.evaluate(with: self)
    }
    
    // 邮箱正则表达式验证
    public func validateEmail() -> Bool {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: self)
    }
    
    // 手机号码正则表达式验证
    public func validateMobile() -> Bool {
        let phoneRegex: String = "^1[3|4|5|7|8][0-9]\\d{8}$"
//        let phoneRegex: String = "^\\d{11}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    
    // 手机号码加密：138****1214
    public func phoneNumberEncry() -> String {
        guard self.validateMobile() else { // 不是手机号码，直接返回
            return self
        }
        let start = self.index(self.startIndex, offsetBy: 3)
        let end = self.index(self.startIndex, offsetBy: 7)
        let range = Range(uncheckedBounds: (start, end))
        return self.replacingCharacters(in: range, with: "****")
    }
    
    /// 字符串的匹配范围
    /// - Parameters:
    ///    - matchStr: 要匹配的字符串
    /// - Returns: 返回所有字符串范围
    @discardableResult
    public func matchStrRanges(_ matchStr: String) -> [NSRange] {
        var selfStr = self as NSString
        var withStr = Array(repeating: "X", count: (matchStr as NSString).length).joined(separator: "") //辅助字符串
        if matchStr == withStr { withStr = withStr.lowercased() } //临时处理辅助字符串差错
        var allRange = [NSRange]()
        while selfStr.range(of: matchStr).location != NSNotFound {
            let range = selfStr.range(of: matchStr)
            allRange.append(NSRange(location: range.location,length: range.length))
            selfStr = selfStr.replacingCharacters(in: NSMakeRange(range.location, range.length), with: withStr) as NSString
        }
        return allRange
    }
    
    /// 是否为http链接或内部链接ics
    public var isLink: Bool {
        guard let _ = self.removingPercentEncoding else { return false }
        return self.hasPrefix("http://") || self.hasPrefix("https://") || self.hasPrefix("ics://")
    }
    
}

extension String {
    /*
     *去掉首尾空格
     */
    public var removeHeadAndTailSpace: String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    public var removeHeadAndTailSpacePro: String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    public var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    public func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
    
    public var isNil: Bool {
        return self.removeAllSapce.isEmpty
    }
}


extension String {
    /// 从字符串中解析出参数，仅以 ?的有无 为有无参数的判断依据
    ///
    /// 如 http://www.baidu.com/?search=a -> 解析出参数为 [search:a],
    ///    ics://jobDetail?jobWid=xxx&type=2 -> 解析出参数为 [jobWid:xxx, type:2],
    ///    1287ksjduwe2?t=16892736 -> 解析出参数为 [t:16892736]
    ///
    /// - Returns: 返回所有解析出的参数字典
    public var urlParameters: [String: String] {
        var params = [String: String]()
        guard let destStr = self.removingPercentEncoding else { return params }
        guard let start = destStr.range(of: "?") else { return params }

        let paramsStr = String(destStr[start.upperBound ..< destStr.endIndex])
        
        if paramsStr.contains("&") {
            //多个参数
            let kvPair = paramsStr.components(separatedBy: "&")
            for item in kvPair {
                let arr = item.components(separatedBy: "=")
                if arr.count == 2 {
                    let key = arr.first?.removingPercentEncoding
                    let value = arr.last?.removingPercentEncoding
                    if let `key` = key, let `value` = value {
                        params[key] = value
                    }
                }
            }
        } else {
            //单个参数
            let arr = paramsStr.components(separatedBy: "=")
            if arr.count == 2 {
                let key = arr.first?.removingPercentEncoding
                let value = arr.last?.removingPercentEncoding
                if let `key` = key, let `value` = value {
                    params[key] = value
                }
            }
        }
        
        return params
    }
    
    /// 从类似URL的字符串中解析出domain和path字符串，即 :// 到 ?(若有) 之间的字符串，仅以 :// 的有无为是否可解析的判断依据
    /// 如 http://www.baidu.com/?search=a  -> 解析出 www.baidu.com/
    ///    http://www.baidu.com?search=a  -> 解析出 www.baidu.com
    ///    ics://jobDetail?jobWid=xxx&type=2 -> 解析出 jobDetail
    ///    1287ksjduwe2?t=16892736 -> 无法解析
    public var urlDomain: String {
        guard let destStr = self.removingPercentEncoding else { return "" }
        guard let start = destStr.range(of: "://") else { return "" }
        
        var result = String(destStr[start.upperBound ..< destStr.endIndex])
        if let end = result.range(of: "?") {
            result = String(result[destStr.startIndex ..< end.lowerBound])
        }
        return result
    }
    
    /// 替换参数,没有则添加
    public func replaceUrlParameter(replacementKey key: String, value: String) -> String {
        guard let destUrl = self.removingPercentEncoding else { return self }
        
        var params = destUrl.urlParameters
        params[key] = value
        var domain = self
        if let start = domain.range(of: "?") {
            domain = String(destUrl[destUrl.startIndex ..< start.lowerBound])
        }
        
        var url = "\(domain)"
        var query = [String]()
        for (_, value) in params.enumerated() {
            let str = "\(value.key)=\(value.value)"
            query.append(str)
        }
        
        if query.count > 0 {
            url += "?\(query.joined(separator: "&"))"
        }
        
        return url
    }
    
    /// 截取到任意位置
    public func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    public func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    public func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    public subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    public subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
   
    subscript(_ i: Int) -> String? {
        let startIndex = self.index(self.startIndex, offsetBy: i)
        let str = String(self[startIndex])
        return str
    }
}

extension String {
    public var md5OrSha256: String {
        guard let cStr = self.cString(using: String.Encoding.utf8), cStr.isEmpty else {
            return ""
        }
        guard #available(iOS 13.0, *) else {
            // MD5 iOS 13.0版本以上已被废弃
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
            CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
            let md5String = NSMutableString();
            for i in 0 ..< 16{
                md5String.appendFormat("%02x", buffer[i]) //需要字母大写，则改为 %02X 即可
            }
            free(buffer)
            return md5String as String
        }
        var digest = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CC_SHA256(cStr, CC_LONG(cStr.count - 1), &digest)
        return digest.reduce("") {
            $0 + String(format: "%02x", $1)
        }
    }
}

extension String {
    // html标签文本 转换为 富文本（不带有标签）
    public func getAttributeString() -> NSAttributedString? {
        do {
            if let data = self.data(using: .unicode) {
                var myAttribute: NSDictionary? = [NSAttributedString.Key.foregroundColor: UIColor.init(hexString: "555555"),
                                   NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                let attrStr = try NSAttributedString(data: data, options: [
                    .documentType: NSAttributedString.DocumentType.html
                    ], documentAttributes: &myAttribute)
                return attrStr
            }
        } catch {
            let err = error as? LocalizedError
            printLog(err?.errorDescription ?? "\(self) html标签文本转富文本失败")
        }
        return nil
    }
}

