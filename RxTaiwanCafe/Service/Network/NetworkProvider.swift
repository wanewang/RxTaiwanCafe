//
//  NetworkProvider.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 10/6/16.
//  Copyright © 2016 OptimisCorp. All rights reserved.
//

import Foundation
import RxSwift

class NetworkProvider: Network {
    // MARK: - Private
    let session: URLSession
    
    // MARK: - Lifecycle
    init(session: URLSession) {
        self.session = session
    }
    
    // MARK: - Public
    
    func json(_ request: NetworkRequest) -> Observable<Any> {
        do {
            let request = try request.buildURLRequest()
            return session.rx.json(request: request).observeOn(MainScheduler.instance)
        } catch let error {
            return Observable.error(error)
        }
    }
    
    func data(_ request: NetworkRequest) -> Observable<Data> {
        do {
            let request = try request.buildURLRequest()
            return session.rx.data(request: request).observeOn(MainScheduler.instance)
        } catch let error {
            return Observable.error(error)
        }
        
    }
    
}
