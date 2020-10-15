//
//  UserDefaults+Ext.swift
//  WidgetExamplesWidgetExtension
//
//  Created by Pawel on 15/10/2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Foundation

extension UserDefaults {
    static let appGroup = UserDefaults(suiteName: "group.com.pawelwiszenko.WidgetExamples")!
}

extension UserDefaults {
    enum Keys: String {
        case luckyNumber
    }
}
