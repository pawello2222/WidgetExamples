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

extension IntentWidget {
    struct Provider: AppIntentTimelineProvider {
        func placeholder(in context: Context) -> Entry {
            .placeholder
        }

        func snapshot(for configuration: IntentWidgetBackgroundIntent, in context: Context) async -> Entry {
            .placeholder
        }

        func timeline(for configuration: IntentWidgetBackgroundIntent, in context: Context) async -> Timeline<Entry> {
            let entry = Entry(background: background(for: configuration))
            return .init(entries: [entry], policy: .never)
        }

        func recommendations() -> [AppIntentRecommendation<IntentWidgetBackgroundIntent>] {
            [
                .init(
                    intent: .init(
                        background: .color,
                        primaryColor: .teal
                    ),
                    description: "Color Background"
                ),
                .init(
                    intent: .init(
                        background: .gradient,
                        primaryColor: .teal,
                        secondaryColor: .yellow
                    ),
                    description: "Gradient Background"
                )
            ]
        }
    }
}

// MARK: - Helpers

extension IntentWidget.Provider {
    private func background(for configuration: IntentWidgetBackgroundIntent) -> IntentWidgetBackground {
        .init(
            type: configuration.background,
            colors: [
                configuration.primaryColor,
                configuration.secondaryColor
            ]
        )
    }
}
