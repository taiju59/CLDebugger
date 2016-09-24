//
//  Visit.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/24.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import Foundation
import CoreLocation

protocol VisitMonitoringDelegate: class {
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didUpdateLocation locations: [CLLocation])
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didFailWithError error: Error)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didUpdateHeading newHeading: CLHeading)
//    @objc optional func visitMonitoring(_ visitMonitoring: VisitMonitoring, shouldDisplayHeadingCalibration manager: CLLocationManager)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didEnterRegion region: CLRegion)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didExitRegion region: CLRegion)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error)
    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
//    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didStartMonitoringFor region: CLRegion)
    func visitMonitoring(_ visitMonitoring: VisitMonitoring, didPauseLocationUpdates manager: CLLocationManager)
    func visitMonitoring(_ visitMonitoring: VisitMonitoring, didResumeLocationUpdates manager: CLLocationManager)
    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?)
    func visitMonitoring(_ visitMonitoring: VisitMonitoring, manager: CLLocationManager, didVisit visit: CLVisit)
}

class VisitMonitoring: NSObject, CLLocationManagerDelegate {

    private var locationManager: CLLocationManager! = nil
    static let sharedInstance = VisitMonitoring()

    weak var delegate: VisitMonitoringDelegate?

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
        locationManager.startMonitoringVisits()
    }

    func stop() {
        locationManager.stopMonitoringVisits()
    }

//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        delegate?.visitMonitoring(self, manager: manager, didUpdateLocation: locations)
//    }

//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        delegate?.visitMonitoring(self, manager: manager, didFailWithError: error)
//    }

//    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
//    }

//    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
//        return true
//    }

//    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
//        delegate?.visitMonitoring(self, manager: manager, didDetermineState: state, for: region)
//    }

//    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
//        delegate?.visitMonitoring(self, manager: manager, didRangeBeacons: beacons, in: region)
//    }

//    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
//        delegate?.visitMonitoring(self, manager: manager, rangingBeaconsDidFailFor: region, withError: error)
//    }

//    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
//        delegate?.visitMonitoring(self, manager: manager, didEnterRegion: region)
//    }

//    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
//        delegate?.visitMonitoring(self, manager: manager, didExitRegion: region)
//    }

//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        delegate?.visitMonitoring(self, manager: manager, monitoringDidFailFor: region, withError: error)
//    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.visitMonitoring(self, manager: manager, didChangeAuthorization: status)
    }

//    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
//        delegate?.visitMonitoring(self, manager: manager, didStartMonitoringFor: region)
//    }

    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        delegate?.visitMonitoring(self, didPauseLocationUpdates: manager)
    }

    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        delegate?.visitMonitoring(self, didResumeLocationUpdates: manager)
    }

    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        delegate?.visitMonitoring(self, manager: manager, didFinishDeferredUpdatesWithError: error)
    }

    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        delegate?.visitMonitoring(self, manager: manager, didVisit: visit)
    }
}
