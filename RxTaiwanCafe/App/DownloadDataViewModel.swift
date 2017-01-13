//
//  DownloadDataViewModel.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

protocol DownloadDataViewModelCoordinatorDelegate: class {
    
}

protocol DownloadDataViewModelProtocol: class {
    weak var coordinatorDelegate: DownloadDataViewModelCoordinatorDelegate? { get set }
}

class DownloadDataViewModel: DownloadDataViewModelProtocol {
    weak var coordinatorDelegate: DownloadDataViewModelCoordinatorDelegate?

}
