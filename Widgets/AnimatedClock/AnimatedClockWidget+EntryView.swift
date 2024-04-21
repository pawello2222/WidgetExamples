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

import ClockRotationEffect
import SwiftUI

extension AnalogClockWidget {
    struct EntryView: View {
        let entry: Entry

        var body: some View {
            VStack(alignment: .leading) {
                WidgetHeaderView(title: "Animated Clock")
                Spacer()
                contentView
                Spacer()
            }
            .containerBackground(.clear, for: .widget)
        }
    }
}

// MARK: - Content

extension AnalogClockWidget.EntryView {
    private var contentView: some View {
        Circle()
            .fill(.white)
            .stroke(.brown)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .fill(.blue)
                    .modifier(
                        ClockRotationModifier(
                            period: .secondHand,
                            timezone: .current,
                            anchor: .top
                        )
                    )
            }
    }

    private var handView: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.blue)
    }
}

// MARK: - Helpers

extension AnalogClockWidget.EntryView {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "en_US_POSIX")
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
}
