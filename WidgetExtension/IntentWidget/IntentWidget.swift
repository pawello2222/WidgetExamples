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

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), bgColor: .orange)
    }

    func getSnapshot(for configuration: BackgroundColorSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), bgColor: .orange)
        completion(entry)
    }

    func getTimeline(for configuration: BackgroundColorSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = [SimpleEntry(date: Date(), bgColor: configuration.bgColor)]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let bgColor: BackgroundColor
}

private struct IntentWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            bgColor
            Text(entry.date, style: .date)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }

    @ViewBuilder
    private var bgColor: some View {
        switch entry.bgColor {
        case .blue:
            Color.blue
        case .red:
            Color.red
        case .green:
            Color.green
        case .orange:
            Color.orange
        default:
            Color.primary.colorInvert()
        }
    }
}

struct IntentWidget: Widget {
    private let kind: String = WidgetKind.intent

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: BackgroundColorSelectionIntent.self, provider: Provider()) { entry in
            IntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Intent Widget")
        .description("A Widget that has a configurable background color.")
        .supportedFamilies([.systemSmall])
    }
}
