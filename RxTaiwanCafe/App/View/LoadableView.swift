//
//  LoadableView.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/20/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class LoadableView: UIView, Viewable {
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.xibSetup()
        self.initSetup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.xibSetup()
        self.initSetup()
    }
    
    open func initSetup() {}
    
}

protocol Viewable {
    func viewName() -> String
}

extension Viewable {
    func viewName() -> String {
        return "\(self)"
    }
}

extension Viewable where Self: UIView {
    
    func viewName() -> String {
        // parsing xib name from class -> ProjectName.ClassName
        let className = NSStringFromClass(type(of: self))
        let names = className.components(separatedBy: ".")
        return names[1]
    }
    
    func xibSetup() {
        // for IBDesingable usage
        #if TARGET_INTERFACE_BUILDER
            let bundle = Bundle.init(for: type(of: self))
        #else
            // xib error if not added this line
            let bundle = Bundle.main
        #endif
        let nib = UINib(nibName: self.viewName(), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.layer.bounds
            view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(view)
        }
    }
}
