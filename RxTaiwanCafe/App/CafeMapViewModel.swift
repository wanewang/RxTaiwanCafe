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
            locationFetcher: LocationFetcher,
            cache: DiskCache?
        ),
        input: Observable<[CafeInformation]>
    ) {
        userLocation = depedency.locationFetcher.userLocation.shareReplay(1)
        let localList = input.shareReplay(1)
        localList
            .filter { (cafeList) -> Bool in
                return try depedency.cache?.get(at: "cafe.json") == nil
            }.subscribe(onNext: { (cafeList) in
                do {
                    let data = try JSONSerialization.data(withJSONObject: cafeList.flatMap { try? $0.foundationJSON() }, options: .init(rawValue: 0))
                    try depedency.cache?.save(data, to: "cafe.json")
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
