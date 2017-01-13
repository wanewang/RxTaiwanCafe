//
//  CafeNomadNetwork.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation
import RxSwift

class CafeNomadNetwork {
    
    private let network: Network
    
    init(_ network: Network) {
        self.network = network
    }
    
    func getCafeList() -> Observable<[CafeInformation]> {
        let request = NetworkRequest(method: .get, url: "https://cafenomad.tw/api/v1.0/cafes")
        
        return network.data(request)
            .mapObjects(type: CafeInformation.self)
    }
    
}
