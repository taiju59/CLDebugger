//
//  RLMModel.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/12/31.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import Foundation
import CoreLocation
import RealmSwift

class InfoData: Object {
    let locationInfoType = RealmOptional<Int>()
    dynamic var event = 0
    let latitude = RealmOptional<Double>()
    let longitude = RealmOptional<Double>()
    dynamic var body = ""
    dynamic var insertDate = Date()

    func toInfo() -> Info {
        return Info(
            locationInfoType.value == nil ? nil:LocationInfoType(rawValue: locationInfoType.value!),
            event: EventType(rawValue: event)!,
            location: latitude.value == nil ? nil:CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude.value!), longitude: CLLocationDegrees(longitude.value!)),
            description: body
        )
    }
}
