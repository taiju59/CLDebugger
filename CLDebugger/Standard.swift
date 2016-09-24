//
//  Standard.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/23.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import Foundation
import CoreLocation

protocol StandardDelegate: class {
    func standard(_ standard: Standard, manager: CLLocationManager, didUpdateLocation locations: [CLLocation])
    func standard(_ standard: Standard, manager: CLLocationManager, didFailWithError error: Error)
}

class Standard: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager! = nil
    static let sharedInstance = Standard()

    weak var delegate: StandardDelegate?

    override private init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }

    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }

    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    func start() {
        locationManager.startUpdatingLocation()
    }

    func stop() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.standard(self, manager: manager, didUpdateLocation: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.standard(self, manager: manager, didFailWithError: error)
    }
}
