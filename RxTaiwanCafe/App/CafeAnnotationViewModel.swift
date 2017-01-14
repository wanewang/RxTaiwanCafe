//
//  CafeAnnotationViewModel.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/14/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import MapKit

class CafeAnnotationViewModel: NSObject, MKAnnotation {
    
    private let name: String
    private let address: String
    private let location: CLLocationCoordinate2D
    var title: String? {
        return name
    }
    var subtitle: String? {
        return address
    }
    var coordinate: CLLocationCoordinate2D {
        return location
    }
    
    init?(_ cafeInfo: CafeInformation) {
        guard let lat = Double(cafeInfo.latitude),
            let lng = Double(cafeInfo.longitude) else {
            return nil
        }
        name = cafeInfo.name
        address = cafeInfo.address
        location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
