//
//  FileManager+Extensions.swift
//  Widget Examples
//
//  Created by Pawel Wiszenko on 20/07/2023.
//  Copyright © 2023 Tersacore. All rights reserved.
//

import Foundation

extension FileManager {
    static func loadStringFromFile(filename: String) -> String? {
        let url = appGroupContainerURL.appendingPathComponent(filename)
        do {
            return try String(contentsOf: url, encoding: .utf8)
        } catch {
            print(error)
        }
        return nil
    }

    static func saveStringToFile(_ value: String, filename: String) {
        let url = appGroupContainerURL.appendingPathComponent(filename)
        do {
            try value.write(to: url, atomically: false, encoding: .utf8)
        } catch {
            print(error)
        }
    }
}

// MARK: - App Group

extension FileManager {
    static let appGroupContainerURL = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: Shared.appGroupName
    )!
}
