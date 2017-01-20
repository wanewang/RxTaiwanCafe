//
//  CafeInfoView.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/20/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class CafeInfoView: LoadableView {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var wifiLabel: UILabel!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var cheapLabel: UILabel!
    @IBOutlet weak var quietLabel: UILabel!
    @IBOutlet weak var tastyLabel: UILabel!
    @IBOutlet weak var musicLabel: UILabel!
    
    func config(_ vm: CafeInfoViewModel) {
        self.isHidden = false
        nameLabel.text = "\(vm.name)"
        wifiLabel.text = "網路穩定: \(vm.wifi)"
        seatLabel.text = "有位程度: \(vm.seat)"
        cheapLabel.text = "價格便宜: \(vm.cheap)"
        quietLabel.text = "安靜程度: \(vm.quiet)"
        tastyLabel.text = "咖啡好喝: \(vm.tasty)"
        musicLabel.text = "音樂好聽: \(vm.music)"
    }
    
}
