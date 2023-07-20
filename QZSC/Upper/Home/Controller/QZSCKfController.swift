//
//  QZSCKfController.swift
//  QZSC
//
//  Created by zzk on 2023/7/19.
//

import UIKit
import RxCocoa
import RxSwift

class QZSCKfController: QZSCBaseController {
    
    private var dataLists = [String]() {
        didSet {
            table.reloadData()
        }
    }
    
    private let dBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setNavBar()
        addSubviews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        ZHWDMessageViewModel.loadAllMessageList { result in
            self.loadData()
//        }
    }
    
    private func setNavBar() {
        navTitle = "客服"
    }

    private func addSubviews() {
        view.addSubview(table)
        view.addSubview(inputV)
        table.snp.makeConstraints { make in
            make.top.equalTo(navBar.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
        }
        inputV.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(50 + kHomeIndicatorHeight())
        }
        
        /// 底部栏键盘高度自适应
        QZSCKeyboardListener.shared.keyboardHeight.bind { [weak self] height in
            guard let self = self else { return }
            let offsetHeight = height > 0 ? height - kHomeIndicatorHeight() : 0
            self.inputV.snp.updateConstraints { make in
                make.bottom.equalTo(-offsetHeight)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }.disposed(by: dBag)
        
        inputV.refreshHandle = { [weak self] in
            guard let `self` = self else { return }
            var mutLists = [String]()
            mutLists.append("您好，请问有什么可以帮助您的吗？")
            mutLists.append(contentsOf: QZSCKfManager.shared.historyMessages)
            self.dataLists = mutLists
        }
    }
    
    private func loadData() {
        var mutLists = [String]()
        mutLists.append("您好，请问有什么可以帮助您的吗？")
        mutLists.append(contentsOf: QZSCKfManager.shared.historyMessages)
        dataLists = mutLists
        inputV.isHidden = false
        table.reloadData()
    }

    // MARK: - Override
    override func viewWillLayoutSubviews() {
        view.sendSubviewToBack(navBar)
    }
    
    // MARK: - lazy
    private lazy var table: UITableView = {
        let table = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - kNavBarFullHeight - kStatusBarHeight), style: .plain)
        table.separatorStyle = .none
        table.register(QZSCSpeakCell.self)
        table.register(QZSCKfCell.self)
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .clear
        table.rowHeight = UITableView.automaticDimension
        return table
    }()
    
    private lazy var inputV: QZSCMessageInputView = {
        let inputV = QZSCMessageInputView()
        inputV.isHidden = true
        return inputV
    }()
}

extension QZSCKfController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(QZSCKfCell.self)
            cell.data = dataLists[safety: indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(QZSCSpeakCell.self)
            cell.data = dataLists[safety: indexPath.row]
            return cell
        }
        
    }
    
}

