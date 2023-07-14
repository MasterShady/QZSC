//
//  UIView+Frame.swift
//  DF_MSZ
//
//  Created by fanyebo on 2022/12/21.
//

import UIKit

extension UIView {
    
    /// x 的位置
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }
    
    /// y 的位置
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }

    /// height: 视图的高度
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.height = newValue
            self.frame = tempFrame
        }
    }

    /// width: 视图的宽度
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size.width = newValue
            self.frame = tempFrame
        }
    }

    /// size: 视图的zize
    public var size: CGSize {
        get {
            return self.frame.size
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.size = newValue
            self.frame = tempFrame
        }
    }

    /// centerX: 视图的X中间位置
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.x = newValue
            self.center = tempCenter
        }
    }

    /// centerY: 视图Y的中间位置
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set(newValue) {
            var tempCenter: CGPoint = self.center
            tempCenter.y = newValue
            self.center = tempCenter;
        }
    }

    /// top 上端横坐标(y)
    public var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.y = newValue
            self.frame = tempFrame
        }
    }

    /// left 左端横坐标(x)
    public var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            var tempFrame: CGRect = self.frame
            tempFrame.origin.x = newValue
            self.frame = tempFrame
        }
    }

    /// bottom 底端纵坐标 (y + height)
    public var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set(newValue) {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }

    /// right 底端纵坐标 (x + width)
    public var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set(newValue) {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
}

// MARK:关于UIView的 圆角、阴影、边框 的设置
extension UIView {

    /// 添加圆角
    /// - Parameters:
    ///  - conrners: 具体哪个圆角
    ///  - radius: 圆角的大小
    public func addCorner(conrners: UIRectCorner , radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }

    /// 给继承于view的类添加阴影
    /// - Parameters:
    ///  - shadowColor: 阴影的颜色
    ///  - shadowOffset: 阴影的偏移度：CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移]);
    ///  - shadowOpacity: 阴影的透明度
    ///  - shadowRadius: 阴影半径，默认 3
    public func addShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
        // 设置阴影颜色
        layer.shadowColor = shadowColor.cgColor
        // 设置透明度
        layer.shadowOpacity = shadowOpacity
        // 设置阴影半径
        layer.shadowRadius = shadowRadius
        // 设置阴影偏移量
        layer.shadowOffset = shadowOffset
    }

    /// 添加阴影和圆角并存
    /// - Parameters:
    ///  - conrners: 具体哪个圆角
    ///  - radius: 圆角大小
    ///  - shadowColor: 阴影的颜色
    ///  - shadowOffset: 阴影的偏移度：CGSizeMake(X[正的右偏移,负的左偏移], Y[正的下偏移,负的上偏移]);
    ///  - shadowOpacity: 阴影的透明度
    ///  - shadowRadius: 阴影半径，默认 3
    public func addCornerAndShadow(superview: UIView, conrners: UIRectCorner , radius: CGFloat = 3, shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float, shadowRadius: CGFloat = 3) {
    
        let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: conrners, cornerRadii: CGSize(width: radius, height: radius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    
        let subLayer = CALayer()
        let fixframe = self.frame
        subLayer.frame = fixframe
        subLayer.cornerRadius = shadowRadius
        subLayer.backgroundColor = shadowColor.cgColor
        subLayer.masksToBounds = false
        // shadowColor阴影颜色
        subLayer.shadowColor = shadowColor.cgColor
        // shadowOffset阴影偏移,x向右偏移3，y向下偏移2，默认(0, -3),这个跟shadowRadius配合使用
        subLayer.shadowOffset = shadowOffset
        // 阴影透明度，默认0
        subLayer.shadowOpacity = shadowOpacity
        // 阴影半径，默认3
        subLayer.shadowRadius = shadowRadius
        superview.layer.insertSublayer(subLayer, below: self.layer)
    }

    /// 添加边框
    /// - Parameters:
    ///  - width: 边框宽度
    ///  - color: 边框颜色
    public func addBorder(borderWidth: CGFloat, borderColor: UIColor) {
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
    }

    /// 添加顶部的 边框
    /// - Parameters:
    ///  - borderWidth: 边框宽度
    ///  - borderColor: 边框颜色
    public func addBorderTop(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: 0, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加顶部的 内边框
    /// - Parameters:
    ///  - borderWidth: 边框宽度
    ///  - borderColor: 边框颜色
    ///  - padding: 边框距离边上的距离
    public func addBorderTopWithPadding(borderWidth: CGFloat, borderColor: UIColor, padding: CGFloat) {
        addBorderUtility(x: padding, y: 0, width: frame.width - padding*2, height: borderWidth, color: borderColor)
    }

    /// 添加底部的 边框
    /// - Parameters:
    ///  - borderWidth: 边框宽度
    ///  - borderColor: 边框颜色
    public func addBorderBottom(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: frame.height - borderWidth, width: frame.width, height: borderWidth, color: borderColor)
    }

    /// 添加左边的 边框
    /// - Parameters:
    ///  - borderWidth: 边框宽度
    ///  - borderColor: 边框颜色
    public func addBorderLeft(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: 0, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }

    /// 添加右边的 边框
    /// - Parameters:
    ///  - borderWidth: 边框宽度
    ///  - borderColor: 边框颜色
    public func addBorderRight(borderWidth: CGFloat, borderColor: UIColor) {
        addBorderUtility(x: frame.width - borderWidth, y: 0, width: borderWidth, height: frame.height, color: borderColor)
    }
    
    public func addBorderUtility(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, color: UIColor) {
        let line = CALayer();
        line.frame = CGRect(x: x, y: y, width: width, height: height);
        line.backgroundColor = color.cgColor;
        self.layer.addSublayer(line);
    }

    /// 画圆环
    /// - Parameters:
    ///  - fillColor: 内环的颜色
    ///  - strokeColor: 外环的颜色
    ///  - strokeWidth: 外环的宽度
    public func drawCircle(fillColor: UIColor, strokeColor: UIColor, strokeWidth: CGFloat) {
        let ciecleRadius = self.width > self.height ? self.height : self.width
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: ciecleRadius, height: ciecleRadius), cornerRadius: ciecleRadius / 2)
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = strokeWidth
        self.layer.addSublayer(shapeLayer)
    }
}

