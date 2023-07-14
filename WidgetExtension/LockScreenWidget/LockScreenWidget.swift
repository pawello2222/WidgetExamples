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
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), percent: 67)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), percent: 67)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let midnight = Calendar.current.startOfDay(for: currentDate)
        let nextDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

        let hoursPassedSinceMidnight = Calendar.current.dateComponents([.hour], from: midnight, to: currentDate).hour ?? 0
        let passedFractionOfDay = hoursPassedSinceMidnight * 100 / 24

        let entries = [SimpleEntry(date: currentDate, percent: passedFractionOfDay)]
        let timeline = Timeline(entries: entries, policy: .after(nextDate))
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let percent: Int
}

private struct LockScreenWidgetEntryView: View {
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    @ViewBuilder
    var body: some View {
        switch family {
        case .accessoryInline:
            accessoryInlineView
        case .accessoryRectangular:
            accessoryRectangularView
        case .accessoryCircular:
            accessoryCircularView
        default:
            systemSmallView
        }
    }

    private var accessoryInlineView: some View {
        Text("Percent: \(entry.percent)")
    }

    private var accessoryRectangularView: some View {
        VStack {
            Text("Percent: \(entry.percent)")
                .font(.headline)
            Capsule()
                .foregroundStyle(.secondary)
                .frame(maxWidth: 100)
                .opacity(0.5)
                .overlay(alignment: .leading) {
                    Capsule()
                        .foregroundStyle(.primary)
                        .frame(maxWidth: CGFloat(entry.percent))
                }
        }
    }

    private var accessoryCircularView: some View {
        Text("\(entry.percent)")
            .font(.title)
            .foregroundStyle(.primary)
            .fixedSize()
            .padding()
            .background {
                Circle()
                    .foregroundStyle(.secondary)
            }
    }

    private var systemSmallView: some View {
        Text("\(entry.percent)")
            .font(.title)
            .foregroundStyle(.red)
    }
}

struct LockScreenWidget: Widget {
    private let kind: String = WidgetKind.lockScreen

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LockScreenWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Lock Screen Widget")
        .description("A Widget that can be displayed on both the lock screen and the home screen.")
        .supportedFamilies([.accessoryCircular, .accessoryRectangular, .accessoryInline, .systemSmall])
    }
}
