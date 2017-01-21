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
import MapKit

protocol CafeMapViewModelCoordinatorDelegate: class {
    
}

protocol CafeMapViewModelProtocol: class {
    weak var coordinatorDelegate: CafeMapViewModelCoordinatorDelegate? { get set }
    var userLocation: Observable<CLLocationCoordinate2D> { get }
    var cafeInofs: Observable<[CafeAnnotationViewModel]> { get }
    var cafeDidSelect: PublishSubject<CafeAnnotationViewModel> { get }
    var routeDidStart: PublishSubject<Void> { get }
    var locationRestart: PublishSubject<Void> { get }
    var routes: Observable<MKRoute> { get }
    var infoDetail: Observable<CafeInfoViewModel> { get }
}

class CafeMapViewModel: CafeMapViewModelProtocol {
    
    weak var coordinatorDelegate: CafeMapViewModelCoordinatorDelegate?
    let userLocation: Observable<CLLocationCoordinate2D>
    let cafeInofs: Observable<[CafeAnnotationViewModel]>
    let routes: Observable<MKRoute>
    let cafeDidSelect: PublishSubject<CafeAnnotationViewModel> = .init()
    let routeDidStart: PublishSubject<Void> = .init()
    let locationRestart: PublishSubject<Void> = .init()
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
        routes = routeDidStart
            .withLatestFrom(infoDetail)
            .map { $0.coordinate }
            .withLatestFrom(userLocation) {
                $0
            }.flatMap { (point, userLocation) -> Observable<MKRoute> in
                let directionRequest = MKDirectionsRequest.init()
                directionRequest.transportType = .walking
                directionRequest.source = MKMapItem.init(placemark: MKPlacemark.init(coordinate: userLocation, addressDictionary: nil))
                directionRequest.destination = MKMapItem.init(placemark: MKPlacemark.init(coordinate: point, addressDictionary: nil))
                let directions = MKDirections.init(request: directionRequest)
                return Observable.create({ (observer) -> Disposable in
                    directions.calculate { (directionsResponse, error) -> Void in
                        if let route = directionsResponse?.routes.first {
                            observer.onNext(route)
                        }
                    }
                    return Disposables.create()
                })
            }
        locationRestart
            .bindTo(depedency.locationFetcher.locationStartUpdate)
            .addDisposableTo(disposeBag)
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
