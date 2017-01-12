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
    
    init(_ window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let viewModel = CafeMapViewModel.init(depedency: (locationManager: CLLocationManager.init(), session: URLSession.shared))
        let mapViewController = CafeMapViewController.init(viewModel)
        window.rootViewController = mapViewController
    }
    
}
