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
                WidgetHeaderView(title: "Analog Clock")
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
            .fill(.background)
            .stroke(.gray)
            .overlay {
                hourHandView
            }
            .overlay {
                minuteHandView
            }
            .overlay {
                secondHandView
            }
            .overlay {
                knobView
            }
            .frame(width: 100, height: 100)
            .frame(maxWidth: .infinity)
    }

    private var hourHandView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(gradient())
            .frame(width: 4, height: 50)
            .clockRotation(.hourHand)
    }

    private var minuteHandView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(gradient())
            .frame(width: 3, height: 70)
            .clockRotation(.miniuteHand)
    }

    private var secondHandView: some View {
        RoundedRectangle(cornerRadius: 10)
            .fill(gradient())
            .frame(width: 2, height: 90)
            .clockRotation(.secondHand)
    }

    private var knobView: some View {
        Circle()
            .fill(.brown)
            .frame(width: 3, height: 3)
    }
}

// MARK: - Helpers

extension AnalogClockWidget.EntryView {
    private func gradient() -> LinearGradient {
        .init(
            gradient: .init(
                stops: [
                    .init(color: .brown, location: 0.5),
                    .init(color: .clear, location: 0.5)
                ]
            ),
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

extension View {
    fileprivate func clockRotation(_ period: ClockRotationPeriod) -> some View {
        modifier(
            ClockRotationModifier(
                period: period,
                timezone: .current,
                anchor: .center
            )
        )
    }
}
