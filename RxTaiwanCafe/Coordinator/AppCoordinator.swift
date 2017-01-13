//
//  AppCoordinator.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit
import CoreLocation

class AppCoordinator: Coordinator {
    
    private let window: UIWindow
    private let network: CafeNomadNetwork
    
    init(_ window: UIWindow) {
        self.window = window
        self.network = CafeNomadNetwork.init(NetworkProvider.init(session: URLSession.shared))
    }
    
    func start() {
        let viewModel = CafeMapViewModel.init(depedency: (locationManager: CLLocationManager.init(), network: network))
        let mapViewController = CafeMapViewController.init(viewModel)
        window.rootViewController = mapViewController
    }
    
}
