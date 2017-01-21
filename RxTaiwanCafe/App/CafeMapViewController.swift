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
import RxCocoa
import RxMKMapView

class CafeMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cafeInfoView: CafeInfoView! {
        didSet {
            cafeInfoView.isHidden = true
        }
    }
    @IBOutlet weak var cafeInfoViewTopConstraint: NSLayoutConstraint!
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
        bindViewModel()
        bindViewAction()
    }
    
    private func bindViewModel() {
        viewModel.cafeInofs
            .subscribe(onNext: { [weak self] (infos) in
                self?.mapView.addAnnotations(infos)
            }).addDisposableTo(disposeBag)
        viewModel.userLocation
            .map { $0.latitude == 0 && $0.longitude == 0 }
            .bindTo(cafeInfoView.routeButton.rx.isHidden)
            .addDisposableTo(disposeBag)
        viewModel.userLocation
            .filter {
                $0.latitude != 0 && $0.longitude != 0
            }.subscribe(onNext: { [weak self] (coordinate) in
                self?.mapView.setRegion(MKCoordinateRegion.init(center: coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.01, longitudeDelta: 0.01)), animated: true)
            }).addDisposableTo(disposeBag)
        viewModel.infoDetail
            .subscribe(onNext: { [weak self] (infoViewModel) in
                self?.cafeInfoView.config(infoViewModel)
            }).addDisposableTo(disposeBag)
        viewModel.routes
            .subscribe(onNext: { [weak self] (route) in
                self?.mapView.overlays.forEach { (lay) in
                    if lay is MKPolyline {
                        self?.mapView.remove(lay)
                    }
                }
                self?.mapView.add(route.polyline)
            }).addDisposableTo(disposeBag)
    }
    
    private func bindViewAction() {
        mapView.rx.didDeselectAnnotationView
            .map { _ in true }
            .bindTo(cafeInfoView.rx.isHidden)
            .addDisposableTo(disposeBag)
        mapView.rx.didSelectAnnotationView
            .map { annotaion -> CafeAnnotationViewModel in
                guard let data = annotaion.annotation as? CafeAnnotationViewModel else {
                    throw DataError.none
                }
                return data
            }.bindTo(viewModel.cafeDidSelect)
            .addDisposableTo(disposeBag)
        cafeInfoView.routeButton
            .rx.tap
            .bindTo(viewModel.routeDidStart)
            .addDisposableTo(disposeBag)
        locationButton
            .rx.tap
            .bindTo(viewModel.locationRestart)
            .addDisposableTo(disposeBag)
        let searchStatus = searchButton
            .rx.tap
            .scan(false) { (oldValue, newValue) in
                !oldValue
            }.shareReplay(1)
        searchStatus
            .bindTo(searchButton.rx.isSelected)
            .addDisposableTo(disposeBag)
        searchStatus
            .observeOn(MainScheduler.instance)
            .map { status -> CGFloat in
                status ? 150 : 20
            }.subscribe(onNext: { [weak self] (value) in
                self?.cafeInfoViewTopConstraint.constant = value
                UIView.animate(withDuration: 0.5, animations: {
                    self?.view.layoutIfNeeded()
                })
            }).addDisposableTo(disposeBag)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? CafeAnnotationViewModel else {
            return nil
        }
        if let pin = mapView.dequeueReusableAnnotationView(withIdentifier: "reuseAnnotation") {
            pin.annotation = annotation
            return pin
        }
        let pin = MKPinAnnotationView.init(annotation: annotation, reuseIdentifier: "reuseAnnotation")
        pin.canShowCallout = true
        return pin
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = .darkGray
            polylineRenderer.lineWidth = 5
        }
        return polylineRenderer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
