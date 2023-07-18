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

import AppIntents
import WidgetKit

struct DynamicIntentWidgetIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Person"
    static let description = IntentDescription("Person information.")

    @Parameter(title: "Person")
    var person: PersonEntity?

    init(person: PersonEntity? = nil) {
        self.person = person
    }

    init() {}

    static var parameterSummary: some ParameterSummary {
        Summary {
            \.$person
        }
    }
}

// MARK: - PersonEntity

struct PersonEntity: AppEntity, Identifiable, Hashable {
    var id: Person.ID
    var name: String

    init(id: Person.ID, name: String) {
        self.id = id
        self.name = name
    }

    init(from person: Person) {
        id = person.id
        name = person.name
    }

    var displayRepresentation: DisplayRepresentation {
        .init(title: "\(name)")
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Person")
    static var defaultQuery = PersonEntityQuery()
}

// MARK: - PersonEntityQuery

struct PersonEntityQuery: EntityQuery, Sendable {
    func entities(for identifiers: [PersonEntity.ID]) async throws -> [PersonEntity] {
        Person.getAll()
            .filter { identifiers.contains($0.id) }
            .map(PersonEntity.init)
    }

    func suggestedEntities() async throws -> [PersonEntity] {
        Person.getAll().map(PersonEntity.init)
    }
}
