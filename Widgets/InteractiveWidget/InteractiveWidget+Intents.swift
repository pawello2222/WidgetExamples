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

// MARK: - IncreaseIntent

struct InteractiveWidgetIncreaseIntent: AppIntent {
    static var title: LocalizedStringResource = "Increase Event Counter"

    @Parameter(title: "Event Counter")
    var counter: EventCounterEntity

    init(counter: EventCounter) {
        self.counter = .init(from: counter)
    }

    init() {}

    func perform() async throws -> some IntentResult {
        let key = UserDefaultKey.eventCounter(id: counter.id)
        UserDefaults.appGroup.set(counter.value + 1, forKey: key)
        return .result()
    }
}

// MARK: - ResetIntent

struct InteractiveWidgetResetIntent: AppIntent {
    static var title: LocalizedStringResource = "Reset Event Counter"

    @Parameter(title: "Event Counter")
    var counter: EventCounterEntity

    init(counter: EventCounter) {
        self.counter = .init(from: counter)
    }

    init() {}

    func perform() async throws -> some IntentResult {
        let key = UserDefaultKey.eventCounter(id: counter.id)
        UserDefaults.appGroup.set(0, forKey: key)
        return .result()
    }
}

// MARK: - EventCounterEntity

struct EventCounterEntity: AppEntity, Identifiable, Hashable {
    var id: EventCounter.ID
    var value: Int

    init(id: EventCounter.ID, value: Int) {
        self.id = id
        self.value = value
    }

    init(from counter: EventCounter) {
        id = counter.id
        value = counter.value
    }

    var displayRepresentation: DisplayRepresentation {
        .init(title: "\(value)")
    }

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Event Counter")
    static var defaultQuery = EventCounterEntityQuery()
}

// MARK: - CounterEntityQuery

struct EventCounterEntityQuery: EntityQuery, Sendable {
    func entities(for identifiers: [EventCounterEntity.ID]) async throws -> [EventCounterEntity] {
        identifiers.map {
            let key = UserDefaultKey.eventCounter(id: $0)
            let value = UserDefaults.appGroup.integer(forKey: key)
            return .init(id: $0, value: value)
        }
    }

    func suggestedEntities() async throws -> [EventCounterEntity] {
        [.init(from: .placeholder)]
    }
}
