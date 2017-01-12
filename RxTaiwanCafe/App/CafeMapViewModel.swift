//
//  CafeMapViewModel.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

protocol CafeMapViewModelCoordinatorDelegate: class {
    
}

protocol CafeMapViewModelProtocol: class {
    weak var coordinatorDelegate: CafeMapViewModelCoordinatorDelegate? { get set }
    var userLocation: Observable<CLLocationCoordinate2D> { get }
}

class CafeMapViewModel: CafeMapViewModelProtocol {
    weak var coordinatorDelegate: CafeMapViewModelCoordinatorDelegate?
    let userLocation: Observable<CLLocationCoordinate2D>
    private let locationManager: CLLocationManager
    private let disposeBag = DisposeBag()
    
    
    init(
        depedency: (
            locationManager: CLLocationManager,
            session: URLSession
        )
    ) {
        locationManager = depedency.locationManager
        depedency.locationManager
            .rx.didChangeAuthorizationStatus
            .filter {
                $0 == .authorizedWhenInUse
            }.subscribe(onNext: { (_) in
                depedency.locationManager.startUpdatingLocation()
            }).addDisposableTo(disposeBag)
        userLocation = locationManager
            .rx.didUpdateLocations
            .map { (locations) -> CLLocationCoordinate2D in
                guard let location = locations.first else {
                    return CLLocationCoordinate2D.init()
                }
                depedency.locationManager.stopUpdatingLocation()
                return location.coordinate
            }
    }
    
}
