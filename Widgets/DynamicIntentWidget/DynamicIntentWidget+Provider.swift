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

import WidgetKit

extension DynamicIntentWidget {
    struct Provider: AppIntentTimelineProvider {
        func placeholder(in context: Context) -> Entry {
            .placeholder
        }

        func snapshot(for configuration: DynamicIntentWidgetIntent, in context: Context) async -> Entry {
            .placeholder
        }

        func timeline(for configuration: DynamicIntentWidgetIntent, in context: Context) async -> Timeline<Entry> {
            let entry = Entry(person: person(for: configuration))
            return .init(entries: [entry], policy: .never)
        }

        func recommendations() -> [AppIntentRecommendation<DynamicIntentWidgetIntent>] {
            Person.getAll().map {
                .init(
                    intent: .init(person: .init(id: $0.id, name: $0.name)),
                    description: $0.name
                )
            }
        }
    }
}

// MARK: - Helpers

extension DynamicIntentWidget.Provider {
    private func person(for configuration: DynamicIntentWidgetIntent) -> Person? {
        if let person = configuration.person {
            .init(identifier: person.id)
        } else {
            nil
        }
    }
}
