//
//  Utils.swift
//  CLDebugger
//
//  Created by Taiju Aoki on 2016/09/26.
//  Copyright © 2016年 Taiju Aoki. All rights reserved.
//

import Foundation

extension Date {
    func formatString() -> String {
        let formatter = DateFormatter()
        formatter.locale     = Locale.autoupdatingCurrent
        formatter.dateFormat = "MM/dd HH:mm:ss"

        return formatter.string(from: self)
    }
}
