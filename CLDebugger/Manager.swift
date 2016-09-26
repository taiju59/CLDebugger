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
    case visit = 1
}

enum EventType: Int {
    case success = 0
    case failer = 1
    case status = 2
}

struct Info {
    let locationInfoType: LocationInfoType?
    let event: EventType
    let location: CLLocationCoordinate2D?
    let description: String
    init(_ locationInfoType: LocationInfoType? = nil, event: EventType, location: CLLocationCoordinate2D? = nil, description: String) {
        self.locationInfoType = locationInfoType
        self.event = event
        self.location = location
        self.description = description
    }
}

protocol ManagerDelegate: class {
    func manager(_ manager: Manager, didUpdateInfo locationInfo: Info)
}

class Manager: NSObject, StandardDelegate, VisitMonitoringDelegate {

    static let sharedInstance = Manager()

    weak var delegate: ManagerDelegate?

    override private init() {
        super.init()
        Standard.sharedInstance.delegate = self
        VisitMonitoring.sharedInstance.delegate = self
    }

    // MARK: - Status Change Event
    func requestAlwaysAuthorization(_ type: LocationInfoType) {
        let info: Info
        switch type {
        case .standard:
            Standard.sharedInstance.requestAlwaysAuthorization()
            info = Info(type, event: .status, description: "standard requestAlwaysAuthorization")
        case .visit:
            VisitMonitoring.sharedInstance.requestAlwaysAuthorization()
            info = Info(type, event: .status, description: "visit requestAlwaysAuthorization")
        }
        delegate?.manager(self, didUpdateInfo: info)
    }

    func requestWhenInUseAuthorization(_ type: LocationInfoType) {
        let info: Info
        switch type {
        case .standard:
            Standard.sharedInstance.requestWhenInUseAuthorization()
            info = Info(type, event: .status, description: "standard requestWhenInUseAuthorization")
        case .visit:
            VisitMonitoring.sharedInstance.requestWhenInUseAuthorization()
            info = Info(type, event: .status, description: "visit requestWhenInUseAuthorization")
        }
        delegate?.manager(self, didUpdateInfo: info)
    }

    func start(_ type: LocationInfoType) {
        let info: Info
        switch type {
        case .standard:
            Standard.sharedInstance.start()
            info = Info(type, event: .status, description: "standard start")
        case .visit:
            VisitMonitoring.sharedInstance.start()
            info = Info(type, event: .status, description: "visit start")
        }
        delegate?.manager(self, didUpdateInfo: info)
    }

    func stop(_ type: LocationInfoType) {
        let info: Info
        switch type {
        case .standard:
            Standard.sharedInstance.stop()
            info = Info(type, event: .status, description: "standard stop")
        case .visit:
            VisitMonitoring.sharedInstance.stop()
            info = Info(type, event: .status, description: "visit stop")
        }
        delegate?.manager(self, didUpdateInfo: info)
    }

    func visitMonitoring(_ visitMonitoring: VisitMonitoring, didPauseLocationUpdates manager: CLLocationManager) {
        let info = Info(.visit, event: .status, description: "visit didPauseLocationUpdates")
        delegate?.manager(self, didUpdateInfo: info)
    }

    func visitMonitoring(_ visitMonitoring: VisitMonitoring, didResumeLocationUpdates manager: CLLocationManager) {
        let info = Info(.visit, event: .status, description: "visit didResumeLocationUpdates")
        delegate?.manager(self, didUpdateInfo: info)
    }

    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        let info = Info(.visit, event: .status, description: "visit didFinishDeferredUpdatesWithError")
        delegate?.manager(self, didUpdateInfo: info)
    }

    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let info = Info(.visit, event: .status, description: "visit didChangeAuthorization\nstatus: \(getAuthorizationStatus(status))")
        delegate?.manager(self, didUpdateInfo: info)
    }

    // MARK: - Location Event
    func success(_ type: LocationInfoType, location: CLLocationCoordinate2D, description: String) {
        let info = Info(type, event: .success, location: location, description: description)
        delegate?.manager(self, didUpdateInfo: info)
    }

    func failer(_ type: LocationInfoType, description: String) {
        let info = Info(type, event: .failer, description: description)
        delegate?.manager(self, didUpdateInfo: info)
    }

    func standard(_ standard: Standard, manager: CLLocationManager, didUpdateLocation locations: [CLLocation]) {
        let locationInfoStr = getLocationInfoStr(manager.location!)
        let managerInfoStr = getManagerInfoStr(manager)
        let description = "**location info**\n\(locationInfoStr)\n**manager info**\n\(managerInfoStr)"

        success(.standard, location: manager.location!.coordinate, description: description)
    }

    func standard(_ standard: Standard, manager: CLLocationManager, didFailWithError error: Error) {
        failer(.standard, description: "error: \(error.localizedDescription)")
    }

    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didVisit visit: CLVisit) {
        let visitInfoStr = getVisitInfoStr(visit)
        let managerInfoStr = getManagerInfoStr(manager)
        let description = "**visit info**\n\(visitInfoStr)\n**manager info**\n\(managerInfoStr)"

        success(.visit, location: visit.coordinate, description: description)
    }

    private func getManagerInfoStr(_ manager: CLLocationManager) -> String {

        let authorizationStatus = getAuthorizationStatus(CLLocationManager.authorizationStatus())

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
        locationInfo.append("timestamp: \(location.timestamp.formatString())")
        locationInfo.append("altitude: \(location.altitude)")
        locationInfo.append("horizontalAccuracy: \(location.horizontalAccuracy)")

        return locationInfo.joined(separator: "\n")
    }

    private func getVisitInfoStr(_ visit: CLVisit) -> String {
        var visitInfo = [String]()
        visitInfo.append("lat: \(visit.coordinate.latitude)")
        visitInfo.append("lon: \(visit.coordinate.longitude)")
        visitInfo.append("arrivalDate: \(visit.arrivalDate.formatString())")
        visitInfo.append("departureDate: \(visit.departureDate.formatString())")
        visitInfo.append("horizontalAccuracy: \(visit.horizontalAccuracy)")

        return visitInfo.joined(separator: "\n")
    }

    private func getAuthorizationStatus(_ status: CLAuthorizationStatus) -> String {
        switch status {
        case .authorizedAlways:
            return "authorizedAlways"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .denied:
            return "denied"
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        }
    }
}
