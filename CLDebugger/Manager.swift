//
//  Manager.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/23.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import Foundation
import CoreLocation

enum LocationInfoType: Int {
    case standard = 0
}

class Manager: NSObject, StandardDelegate {

    static let sharedInstance = Manager()

    override private init() {
        super.init()
        Standard.sharedInstance.delegate = self
    }

    func requestAlwaysAuthorization(_ type: LocationInfoType) {
        switch type {
        case .standard:
            Standard.sharedInstance.requestAlwaysAuthorization()
        }
    }

    func requestWhenInUseAuthorization(_ type: LocationInfoType) {
        switch type {
        case .standard:
            Standard.sharedInstance.requestWhenInUseAuthorization()
        }
    }

    func start(_ type: LocationInfoType) {
        switch type {
        case .standard:
            Standard.sharedInstance.start()
        }
    }

    func stop(_ type: LocationInfoType) {
        switch type {
        case .standard:
            Standard.sharedInstance.stop()
        }
    }

    func success(_ type: LocationInfoType, description: String) {
        print("-----success-----")
        print(description)
        print("----------")
    }

    func failer(_ type: LocationInfoType, description: String) {
        print("-----failer-----")
        print(description)
        print("----------")
    }

    func standard(_ standard: Standard, manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        let locationInfoStr = getLocationInfoStr(manager.location!)
        let managerInfoStr = getManagerInfoStr(manager)
        let description = "**location info**\n\(locationInfoStr)\n**manager info**\n\(managerInfoStr)"

        success(.standard, description: description)
    }

    func standard(_ standard: Standard, manager: CLLocationManager, didFailWithError error: Error) {
        failer(.standard, description: "error: \(error.localizedDescription)")
    }

    private func getManagerInfoStr(_ manager: CLLocationManager) -> String {

        let authorizationStatus: String
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            authorizationStatus = "authorizedAlways"
        case .authorizedWhenInUse:
            authorizationStatus = "authorizedWhenInUse"
        case .denied:
            authorizationStatus = "denied"
        case .notDetermined:
            authorizationStatus = "notDetermined"
        case .restricted:
            authorizationStatus = "restricted"
        }

        let desiredAccuracy: String
        switch manager.desiredAccuracy {
        case kCLLocationAccuracyBestForNavigation:
            desiredAccuracy = "BestForNavigation"
        case kCLLocationAccuracyBest:
            desiredAccuracy = "Best"
        case kCLLocationAccuracyNearestTenMeters:
            desiredAccuracy = "NearestTenMeters"
        case kCLLocationAccuracyHundredMeters:
            desiredAccuracy = "HundredMeters"
        case kCLLocationAccuracyKilometer:
            desiredAccuracy = "Kilometer"
        case kCLLocationAccuracyThreeKilometers:
            desiredAccuracy = "ThreeKilometers"
        default:
            desiredAccuracy = "other(\(manager.desiredAccuracy)m)"
        }

        var managerInfo = [String]()
        managerInfo.append("authorizationStatus: \(authorizationStatus)")
        managerInfo.append("distanceFilter: \(manager.distanceFilter)")
        managerInfo.append("desiredAccuracy: \(desiredAccuracy)")
        managerInfo.append("pausesLocationUpdatesAutomatically: \(manager.pausesLocationUpdatesAutomatically)")
        managerInfo.append("allowsBackgroundLocationUpdates: \(manager.allowsBackgroundLocationUpdates)")

        return managerInfo.joined(separator: "\n")
    }

    private func getLocationInfoStr(_ location: CLLocation) -> String {
        var locationInfo = [String]()
        locationInfo.append("lat: \(location.coordinate.latitude)")
        locationInfo.append("lon: \(location.coordinate.longitude)")
        locationInfo.append("timestamp: \(location.timestamp)")
        locationInfo.append("altitude: \(location.altitude)")

        return locationInfo.joined(separator: "\n")
    }

}
