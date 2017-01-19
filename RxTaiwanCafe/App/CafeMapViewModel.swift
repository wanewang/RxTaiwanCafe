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
    var cafeInofs: Observable<[CafeAnnotationViewModel]> { get }
    var cafeDidSelect: PublishSubject<CafeAnnotationViewModel> { get }
    var infoDetail: Observable<CafeInfoViewModel> { get }
}

class CafeMapViewModel: CafeMapViewModelProtocol {
    
    weak var coordinatorDelegate: CafeMapViewModelCoordinatorDelegate?
    let userLocation: Observable<CLLocationCoordinate2D>
    let cafeInofs: Observable<[CafeAnnotationViewModel]>
    let cafeDidSelect: PublishSubject<CafeAnnotationViewModel> = .init()
    let infoDetail: Observable<CafeInfoViewModel>

    private let disposeBag = DisposeBag()
    
    init(
        depedency: (
            locationFetcher: LocationFetcher,
            cache: DiskCache?
        ),
        input: Observable<[CafeInformation]>
    ) {
        let localList = input.shareReplay(1)
        userLocation = depedency.locationFetcher.userLocation.shareReplay(1)
        cafeInofs = localList
            .map {
                $0.flatMap(CafeAnnotationViewModel.init)
            }
        infoDetail = cafeDidSelect
            .withLatestFrom(localList) { (cafeViewModel, infos) -> CafeInformation in
                let result = infos.filter {
                    cafeViewModel.subtitle == $0.address
                }
                guard let info = result.first else {
                    throw DataError.none
                }
                return info
            }.map(CafeInfoViewModel.init)
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
    }
    
}
