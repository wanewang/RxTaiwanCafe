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
    
    private let disposeBag = DisposeBag()
    
    
    init(
        depedency: (
            locationManager: CLLocationManager,
            defaults: UserDefaults,
            cache: DiskCache?
        ),
        input: Observable<[CafeInformation]>
    ) {
        depedency.locationManager
            .rx.didChangeAuthorizationStatus
            .filter {
                $0 == .authorizedWhenInUse
            }.subscribe(onNext: { (_) in
                depedency.locationManager.startUpdatingLocation()
            }).addDisposableTo(disposeBag)
        userLocation = depedency.locationManager
            .rx.didUpdateLocations
            .map { (locations) -> CLLocationCoordinate2D in
                guard let location = locations.first else {
                    return CLLocationCoordinate2D.init()
                }
                depedency.locationManager.stopUpdatingLocation()
                return location.coordinate
            }
        let localList = input.shareReplay(1)
        localList
            .filter { (cafeList) -> Bool in
                return depedency.defaults.value(forKey: "network.date") as? Date == nil
            }.subscribe(onNext: { (cafeList) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: cafeList.flatMap { try? $0.foundationJSON() }, options: .init(rawValue: 0))
                    try depedency.cache?.save(data, to: "cafe.json")
                    depedency.defaults.set(Date(), forKey: "network.date")
                } catch {
                    print(error)
                }
            }).addDisposableTo(disposeBag)
        localList
            .subscribe(onNext: { (cafeList) in
                print(cafeList.first)
                print(cafeList.last)
            }).addDisposableTo(disposeBag)
    }
    
}
