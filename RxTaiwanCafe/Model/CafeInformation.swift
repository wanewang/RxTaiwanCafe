//
//  CafeInformation.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import Genome
import CoreLocation

struct CafeInformation: MappableObject {
    let id: String
    let name: String
    let city: String
    let wifi: Double
    let seat: Double
    let quiet: Double
    let tasty: Double
    let cheap: Double
    let music: Double
    let url: String
    let address: String
    let latitude: String
    let longitude: String
    let coordinate: CLLocationCoordinate2D
    
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
        guard let lat = Double(latitude),
            let lng = Double(longitude) else {
                throw DataError.location
        }
        coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
    
    func sequence(_ map: Map) throws {
        try id ~> map["id"]
        try name ~> map["name"]
        try city ~> map["city"]
        try wifi ~> map["wifi"]
        try seat ~> map["seat"]
        try quiet ~> map["quiet"]
        try tasty ~> map["tasty"]
        try cheap ~> map["cheap"]
        try music ~> map["music"]
        try url ~> map["url"]
        try address ~> map["address"]
        try latitude ~> map["latitude"]
        try longitude ~> map["longitude"]
    }
}
