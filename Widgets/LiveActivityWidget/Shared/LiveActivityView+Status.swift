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

import SwiftUI

extension LiveActivityView {
    struct StatusView: View {
        let delivery: Delivery
        let state: DeliveryAttributes.ContentState

        var body: some View {
            VStack {
                statusView
                gaugeView
            }
            .padding(.vertical)
        }
    }
}

// MARK: - Content

extension LiveActivityView.StatusView {
    private var statusView: some View {
        HStack {
            Text("\(delivery.date, style: .time)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Spacer()
            Text(state.deliveryState.name)
                .font(.headline)
                .contentTransition(.opacity)
            Spacer()
            Text("\(state.expectedArrivalDate, style: .time)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }

    private var gaugeView: some View {
        Gauge(value: currentTimeInterval, in: timeIntervalRange) {
            EmptyView()
        } currentValueLabel: {
            EmptyView()
        } minimumValueLabel: {
            Image(systemName: "truck.box")
        } maximumValueLabel: {
            Image(systemName: "house")
        }
        .gaugeStyle(.accessoryLinear)
        .tint(Gradient(colors: [.blue, .green]))
    }
}

// MARK: - Helpers

extension LiveActivityView.StatusView {
    private var timeIntervalRange: ClosedRange<TimeInterval> {
        startTimeInterval ... endTimeInterval
    }

    private var startTimeInterval: TimeInterval {
        delivery.date.timeIntervalSince1970
    }

    private var currentTimeInterval: TimeInterval {
        min(Date().timeIntervalSince1970, endTimeInterval)
    }

    private var endTimeInterval: TimeInterval {
        state.expectedArrivalDate.timeIntervalSince1970
    }
}

// MARK: - Preview

#Preview {
    LiveActivityView.StatusView(
        delivery: .sent(minutesAgo: 3),
        state: .arrived
    )
    .border(.red)
}
