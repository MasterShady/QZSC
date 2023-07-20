//
//  QZSCCustomAlert.swift
//  QZSC
//
//  Created by zzk on 2023/2/21.
//

import UIKit
import RxCocoa
import RxSwift

public class QZSCCustomAlert: UIView {
    
    var interaction: Bool = false
    
    private var backGroundView: UIView
    private var targetView: UIView
    private var orginSize: CGSize
    
    private let disposeBag = DisposeBag()
    
    public var autoBackClickDismiss: Bool = true {
        didSet {
            backGroundView.isUserInteractionEnabled = autoBackClickDismiss
        }
    }

    public init(frame: CGRect, containerView: UIView) {
        let  screenSize = UIScreen.main.bounds.size
        
        targetView = containerView
        orginSize = targetView.size

        backGroundView = UIView(frame: CGRect.init(x: 0,
                                                   y: 0,
                                                   width: screenSize.width,
                                                   height: screenSize.height))
        
        
        super.init(frame: frame)
        
        backGroundView.backgroundColor = .black
        addSubview(backGroundView)
        
        targetView.frame = CGRect(x: 0, y: 0, width: orginSize.width, height: orginSize.height)
        targetView.center = backGroundView.center
        addSubview(targetView)
        
        let tap = UITapGestureRecognizer()
        backGroundView.addGestureRecognizer(tap)
        tap.rx.event.subscribe(onNext: { [weak self] _ in
            guard let `self` = self else { return }
            self.dismiss()
        }).disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if interaction {
            return nil
        }
        return super.hitTest(point, with: event)
    }
    
    public func show() {
        backGroundView.alpha = 0
        targetView.alpha = 0
        keyWindow?.addSubview(self)
        
        UIView.animate(withDuration: 0.2) {
            self.backGroundView.alpha = 0.4
            self.targetView.alpha = 1.0
        }
        
    }
    
    public func dismiss() {
        self.removeFromSuperview()
    }
    
}
