//
//  LocationFetcher.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/14/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationFetcher {
    let userLocation: Observable<CLLocationCoordinate2D>
    let locationStartUpdate: PublishSubject<Void> = .init()
    private let disposeBag = DisposeBag()
    
    init(_ locationManager: CLLocationManager) {
        locationManager
            .rx.didChangeAuthorizationStatus
            .filter {
                $0 == .authorizedWhenInUse
            }.subscribe(onNext: { (_) in
                locationManager.startUpdatingLocation()
            }).addDisposableTo(disposeBag)
        userLocation = locationManager
            .rx.didUpdateLocations
            .map { (locations) -> CLLocationCoordinate2D in
                guard let location = locations.first else {
                    return CLLocationCoordinate2D.init()
                }
                locationManager.stopUpdatingLocation()
                return location.coordinate
        }
        locationStartUpdate
            .subscribe(onNext: { (_) in
                locationManager.startUpdatingLocation()
            }).addDisposableTo(disposeBag)
    }
    
}
