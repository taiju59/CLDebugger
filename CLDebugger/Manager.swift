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

enum EventType: Int {
    case success = 0
    case failer = 1
}

struct LocationInfo {
    let locationInfoType: LocationInfoType
    let event: EventType
    let description: String
    init(_ locationInfoType: LocationInfoType, event: EventType, description: String) {
        self.locationInfoType = locationInfoType
        self.event = event
        self.description = description
    }
}

protocol ManagerDelegate: class {
    func manager(_ manager: Manager, didUpdateInfo locationInfo: LocationInfo)
}

class Manager: NSObject, StandardDelegate {

    static let sharedInstance = Manager()

    weak var delegate: ManagerDelegate?

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
        let locationInfo = LocationInfo(type, event: .success, description: description)
        delegate?.manager(self, didUpdateInfo: locationInfo)
    }

    func failer(_ type: LocationInfoType, description: String) {
        let locationInfo = LocationInfo(type, event: .failer, description: description)
        delegate?.manager(self, didUpdateInfo: locationInfo)
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

        return managerInfo.joined(separator: "")
    }

    private func getLocationInfoStr(_ location: CLLocation) -> String {
        var locationInfo = [String]()
        locationInfo.append("lat: \(location.coordinate.latitude)")
        locationInfo.append("lon: \(location.coordinate.longitude)")
        locationInfo.append("timestamp: \(location.timestamp)")
        locationInfo.append("altitude: \(location.altitude)")

        return locationInfo.joined(separator: "")
    }

}
