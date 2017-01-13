//
//  CafeInformation.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import Genome

struct CafeInformation: MappableObject {
    let id: String
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
    let latitude: String
    let longitude: String
    
    
    init(map: Map) throws {
        id = try map.extract("id")
        name = try map.extract("name")
        city = try map.extract("city")
        wifi = try map.extract("wifi")
        seat = try map.extract("seat")
        quiet = try map.extract("quiet")
        tasty = try map.extract("tasty")
        cheap = try map.extract("cheap")
        music = try map.extract("music")
        url = try map.extract("url")
        address = try map.extract("address")
        latitude = try map.extract("latitude")
        longitude = try map.extract("longitude")
    }
}
