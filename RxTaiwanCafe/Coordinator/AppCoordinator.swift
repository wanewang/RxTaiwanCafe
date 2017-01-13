//
//  AppCoordinator.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit
import CoreLocation
import Genome
import RxSwift

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let network: CafeNomadNetwork
    private let cache: DiskCache?
    private let location: LocationFetcher
    
    init(_ window: UIWindow) {
        self.window = window
        self.network = CafeNomadNetwork(NetworkProvider.init(session: URLSession.shared))
        self.cache = DiskCache(FileManager.default)
        self.location = LocationFetcher(CLLocationManager())
    }
    
    func start() {
        let cacheInfos: Observable<[CafeInformation]>
        if let data = try? cache?.get(at: "cafe.json"),
            let node = try? data?.makeNode(),
            let n = node,
            let list = try? [CafeInformation](node: n) {
            cacheInfos = Observable.just(list)
        } else {
            cacheInfos = network.getCafeList()
        }
        let viewModel = CafeMapViewModel(depedency: (
            locationFetcher: location,
            cache: cache
            ), input: cacheInfos)
        let mapViewController = CafeMapViewController(viewModel)
        window.rootViewController = mapViewController
    }
    
}
