// The MIT License (MIT)
//
// Copyright (c) 2020-Present Paweł Wiszenko
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import Foundation

struct Contact: Identifiable, Hashable, Codable {
    var id = UUID().uuidString
    var name: String
    var dateOfBirth: Date
}

extension Contact {
    static func getAll() -> [Contact] {
        let key = Key.contacts.rawValue
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
    static func from(identifier: String) -> Contact? {
        getAll().first { $0.id == identifier }
    }
}
