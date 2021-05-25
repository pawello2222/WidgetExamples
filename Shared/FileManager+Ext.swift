//
//  FileManager+Ext.swift
//  WidgetExamples
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Foundation

extension FileManager {
    static let appGroupContainerURL = FileManager.default
        .containerURL(forSecurityApplicationGroupIdentifier: "group.com.pawelwiszenko.WidgetExamples")!
}

extension FileManager {
    static let luckyNumberFilename = "LuckyNumber.txt"
}
