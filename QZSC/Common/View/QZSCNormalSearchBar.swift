//
//  QZSCNormalSearchBar.swift
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

import Foundation
import UIKit

@objc public protocol QZSCNormalSearchBarDelegate {
    @objc optional func searchBarDidChangedWithNewKey(_ searckBar: QZSCNormalSearchBar, newKey: String)

    @objc optional func searchBarDidBeginEditing(_ searckBar: QZSCNormalSearchBar)

    @objc optional func searchBarDidEndEditing(_ searchBar: QZSCNormalSearchBar)

    @objc optional func searchBarShouldReturn(_ searchBar: QZSCNormalSearchBar) -> Bool

    @objc optional func searchBarDidCancelEditing(_ searchBar: QZSCNormalSearchBar)
}

open class QZSCNormalSearchBar: UIView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // 搜索图标 是否显示，true 显示
    @objc public var showSearchIcon: Bool = true {
        didSet {
            searchIcon.isHidden = !showSearchIcon
            inputField.snp.remakeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }

    //回调delegate
    @objc public weak var delegate: QZSCNormalSearchBarDelegate?

    @objc public var placeHolder: String? {
        didSet {
            if let p = placeHolder {
                inputField.attributedPlaceholder = NSAttributedString(string: p,
                                                                      attributes: [.foregroundColor: UIColor(hex: 0x999999)])
            }
        }
    }

    @objc public var inputColor: UIColor? {
        didSet {
            inputField.textColor = inputColor
        }
    }
    
    @objc public var inputFont: UIFont? {
        didSet {
            inputField.font = inputFont
        }
    }

    @objc public var searchBtnColor: UIColor? {
        didSet {
            searchBtn.setTitleColor(searchBtnColor, for: .normal)
        }
    }

    public var disableStyle: Bool? {
        didSet {
            if let d = disableStyle {
                inputField.isEnabled = !d
            }
        }
    }

    @objc public var inputBackgroundColor: UIColor? {
        didSet {
            inputField.backgroundColor = inputBackgroundColor
            backgroundColor = inputBackgroundColor
            contentBg.backgroundColor = inputBackgroundColor
        }
    }

    @objc public var text: String {
        get {
            return inputField.text ?? ""
        }
        set {
            inputField.text = newValue
        }
    }
    
    // 圆角设置，默认圆角true（防止部分情况下，光标被切割圆角）
    public var contentBGMaskBounds: Bool = true {
        didSet {
            let radius: CGFloat = (contentBGMaskBounds ? 17 : 0)
            contentBg.layer.cornerRadius = radius
        }
    }

    public var inputDone: Bool {
        let range = inputField.markedTextRange
        return (range == nil || range!.isEmpty)
    }

    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    public func startEditing() {
        inputField.becomeFirstResponder()
    }
    public func stopEditing() {
        if inputField.isFirstResponder {
            inputField.resignFirstResponder()
        }
    }

    public func stopEditingAndClear() {
        inputField.resignFirstResponder()
        inputField.text = ""
    }

    @objc private func searchBtnClick(_ sender: UIButton) {
        stopEditing()
        delegate?.searchBarDidEndEditing?(self)
    }

    @objc private func textChanged(_ input: UITextField) {
        if input.markedTextRange == nil { // 高亮字符为空，才执行
            delegate?.searchBarDidChangedWithNewKey?(self, newKey: inputField.text ?? "")
        }
    }

    private func setupUI() {
        addSubview(contentBg)
        contentBg.addSubview(searchIcon)
        contentBg.addSubview(inputField)
        addSubview(searchBtn)

        contentBg.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(0)
        }

        searchIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(contentBg.snp.left).offset(10)
            make.centerY.equalTo(contentBg.snp.centerY)
        }
        searchBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(65)
            make.right.equalTo(contentBg)
        }
        inputField.snp.makeConstraints { (make) in
            make.left.equalTo(searchIcon.snp.right).offset(7)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(searchBtn.snp.left)
        }
        
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if contentBGMaskBounds {
            contentBg.layer.cornerRadius = contentBg.bounds.height / 2
        }
    }

    // MARK: lazy
    private lazy var contentBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xf8f8f8)
        view.layer.cornerRadius = 17
        view.layer.masksToBounds = true
//        view.layer.borderColor = COLORC0C1C9.cgColor
//        view.layer.borderWidth = 1
        return view
    }()

    private lazy var searchIcon: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "home_search")
        return img
    }()

    private lazy var inputField: UITextField = {
        let input = UITextField()
        input.delegate = self
        input.clearButtonMode = .whileEditing
        input.returnKeyType = .search
        input.font = UIFont.systemFont(ofSize: 13)
        input.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        return input
    }()

    private lazy var searchBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(COLOR333333, for: .normal)
        btn.setTitle("搜索", for: .normal)
        btn.addTarget(self, action: #selector(searchBtnClick(_:)), for: .touchUpInside)
        return btn
    }()
}

extension QZSCNormalSearchBar: UITextFieldDelegate {
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.searchBarDidBeginEditing?(self)
    }

    public func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.searchBarDidEndEditing?(self)
    }

    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let ret = delegate?.searchBarShouldReturn?(self)
        if let _ = ret {
            return true
        }
        return true
    }
}

