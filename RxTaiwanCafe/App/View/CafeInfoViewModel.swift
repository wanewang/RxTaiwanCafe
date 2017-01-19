//
//  CafeInfoViewModel.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/19/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

struct CafeInfoViewModel {
    
    let name: String
    let city: String
    let wifi: Int
    let seat: Int
    let quiet: Int
    let tasty: Int
    let cheap: Int
    let music: Int
    let url: String
    let address: String
    
    init(_ information: CafeInformation) {
        self.name = information.name
        self.city = information.city
        self.wifi = information.wifi
        self.seat = information.seat
        self.quiet = information.quiet
        self.tasty = information.tasty
        self.cheap = information.cheap
        self.music = information.music
        self.url = information.url
        self.address = information.address
    }
    
}
