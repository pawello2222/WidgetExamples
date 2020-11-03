//
//  Contact.swift
//  WidgetExamples
//
//  Created by Pawel on 03/11/2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Foundation

struct Contact {
    let name: String
    let birthday: Date
}

extension Contact: Identifiable {
    var id: String { name }
}

extension Contact {
    static func getAll() -> [Contact] {
        let key = UserDefaults.Keys.contacts.rawValue
        let contacts = UserDefaults.appGroup.object(forKey: key) as? [Contact]
        return contacts ?? [.friend1, .friend2]
    }

    static let friend1: Contact = {
        let birthday = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        return Contact(name: "Friend 1", birthday: birthday)
    }()

    static let friend2: Contact = {
        let birthday = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
        return Contact(name: "Friend 2", birthday: birthday)
    }()
}

extension Contact {
    static func fromId(_ id: String) -> Contact? {
        getAll().first { $0.id == id }
    }
}
