//
//  CafeMapViewController.swift
//  RxTaiwanCafe
//
//  Created by Wane Wang on 1/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit
import MapKit
import PermissionScope
import RxSwift
import RxMKMapView

class CafeMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    private lazy var pscope: PermissionScope = {
        let pscope = PermissionScope()
        pscope.headerLabel.text = "嗨!"
        pscope.bodyLabel.text = "Cafe Nomad"
        pscope.closeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        pscope.closeButton.setTitle("Ｘ", for: .normal)
        pscope.closeButtonTextColor = .black
        pscope.addPermission(LocationWhileInUsePermission(), message: "在地圖上顯示位置")
        return pscope
    }()
    private let viewModel: CafeMapViewModelProtocol
    private let disposeBag = DisposeBag()
    
    init(_ vm: CafeMapViewModelProtocol) {
        self.viewModel = vm
        super.init(nibName: "\(CafeMapViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pscope.show()
        registerBinding()
    }
    
    private func registerBinding() {
        viewModel
            .userLocation
            .filter {
                $0.latitude != 0 && $0.longitude != 0
            }.subscribe(onNext: { [weak self] (coordinate) in
                self?.mapView.setRegion(MKCoordinateRegion.init(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            }).addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
