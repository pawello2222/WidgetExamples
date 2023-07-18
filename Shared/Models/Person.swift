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

struct Person: Codable, Hashable, Identifiable {
    var id = UUID().uuidString
    var name: String
    var dateOfBirth: Date
}

// MARK: - Helpers

extension Person {
    static func getAll() -> [Self] {
        let key = UserDefaultKey.persons
        guard let persons: [Self] = UserDefaults.appGroup.getArray(forKey: key) else {
            let persons = Self.defaultFriends
            UserDefaults.appGroup.setArray(persons, forKey: key)
            return persons
        }
        return persons
    }
}

// MARK: - Convenience

extension Person {
    init?(identifier: String) {
        if let person = Self.getAll().first(where: { $0.id == identifier }) {
            self = person
        } else {
            return nil
        }
    }
}

// MARK: - Data

extension Person {
    static let defaultFriends: [Self] = [
        .friend1, .friend2
    ]

    static let friend1: Self = {
        let date = Calendar.current.date(byAdding: .month, value: -2, to: .now)!
        return .init(name: "Friend 1", dateOfBirth: date)
    }()

    static let friend2: Self = {
        let date = Calendar.current.date(byAdding: .year, value: -3, to: .now)!
        return .init(name: "Friend 2", dateOfBirth: date)
    }()
}
