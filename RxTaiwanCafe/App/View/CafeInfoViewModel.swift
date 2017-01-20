//
//  CafeInfoViewModel.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/19/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import CoreLocation

struct CafeInfoViewModel {
    
    let name: String
    let city: String
    let wifi: Double
    let seat: Double
    let quiet: Double
    let tasty: Double
    let cheap: Double
    let music: Double
    let url: String
    let coordinate: CLLocationCoordinate2D
    
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
        self.coordinate = information.coordinate
    }
    
}
