//
//  BasePicker.swift
//  ferental
//
//  Created by 刘思源 on 2023/1/6.
//

import Foundation


protocol PickerProtocol{
    associatedtype DataType where DataType : Equatable
    
    //选中的类型, 单选 = DataType 多选 = [DataType]
    associatedtype SelectedType
    
    var title: NSAttributedString { get set }
    var selectedHandler: (SelectedType) -> () { get set }
    
    //子类重写该方法来更新选中项
    func setSelectedData(_ data:SelectedType)
}

class BasePicker<DataType: Equatable, SelectedType> : BaseView, PickerProtocol{
    typealias DataType = DataType
    typealias SelectedType = SelectedType
    var title: NSAttributedString
    var selectedHandler: (SelectedType) -> ()
    var selectedData: SelectedType?
    
    
    func setSelectedData(_ data:SelectedType){
        selectedData = data
    }
    
    init(title:NSAttributedString,selectedHandler:@escaping (SelectedType) -> ()) {
        self.title = title
        self.selectedHandler = selectedHandler
        super.init(frame: .zero)
        self.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configSubviews() {
        addSubview(header)
        header.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
    }
    
    override func layoutSubviews() {
        self.addCorner(conrners: [.topLeft, .topRight], radius: 12)
        header.addBorderBottom(borderWidth: 1, borderColor: .init(hexString: "eeeeee"))
        //header.addBorder(with: UIColor(hexString:"eeeeee"), width: 1, borderType: .bottom)
    }
    
    
    @objc func onCancelClick(sender: UIButton){
        self.popDismiss()
    }
    
    @objc func onConfirmClick(sender: UIButton){
        self.selectedHandler(self.selectedData!)
    }
    
    lazy var header: UIView = {
        let header = UIView()
        let cancelBtn = UIButton()
        header.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(22)
            make.centerY.equalToSuperview()
        }
        cancelBtn.chain.normalTitle(text: "取消").font(.boldSystemFont(ofSize: 14)).normalTitleColor(color: .init(hexString: "#585960"))
        cancelBtn.addTarget(self, action: #selector(onCancelClick(sender:)), for: .touchUpInside)
        
//        cancelBtn.addBlock(for: .touchUpInside) { [weak self] _ in
//
//        }
        
        let comfirmBtn = UIButton()
        header.addSubview(comfirmBtn)
        comfirmBtn.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-22)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 44, height: 28))
        }
        comfirmBtn.chain.normalTitle(text: "完成").font(.boldSystemFont(ofSize: 14)).normalTitleColor(color: .white).backgroundColor(.init(hexString: "#2B2B2B")).corner(radius: 6).clipsToBounds(true)
        
        
        comfirmBtn.addTarget(self, action: #selector(onConfirmClick(sender:)), for: .touchUpInside)
        

        
        
        let titleLabel = UILabel()
        header.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        titleLabel.attributedText = self.title
        
        return header
    }()
    
    

}
