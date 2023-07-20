//
//  UILable+Extension.swift
//  QZSC
//
//  Created by zzk on 2023/6/26.
//

import UIKit

extension UILabel {
    
    class func createSameLbl(text: String?, color: UIColor?, font: UIFont?) -> UILabel {
        let lbl = UILabel()
        lbl.text = text
        lbl.font = font
        lbl.textColor = color
        return lbl
    }
    
}
