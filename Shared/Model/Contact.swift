//
//  Contact.swift
//  WidgetExamples
//
//  Created by Pawel on 03/11/2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Foundation

struct Contact: Hashable, Codable {
    var name: String
    var dateOfBirth: Date
}

extension Contact: Identifiable {
    var id: String { name }
}

extension Contact {
    static func getAll() -> [Contact] {
        let key = UserDefaults.Keys.contacts.rawValue
        guard let contacts: [Contact] = UserDefaults.appGroup.getArray(forKey: key) else {
            let contacts: [Contact] = [.friend1, .friend2]
            UserDefaults.appGroup.setArray(contacts, forKey: key)
            return contacts
        }
        return contacts
    }

    static let friend1: Contact = {
        let date = Calendar.current.date(byAdding: .month, value: -2, to: Date())!
        return Contact(name: "Friend 1", dateOfBirth: date)
    }()

    static let friend2: Contact = {
        let date = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
        return Contact(name: "Friend 2", dateOfBirth: date)
    }()
}

extension Contact {
    static func fromId(_ id: String) -> Contact? {
        getAll().first { $0.id == id }
    }
}
