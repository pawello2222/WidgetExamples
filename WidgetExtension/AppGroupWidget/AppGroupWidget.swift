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
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [SimpleEntry(date: midnight)]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
}

private struct AppGroupWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text("Lucky number")
                .font(.callout)
            Text("From UserDefaults: \(luckyNumberFromUserDefaults)")
            Text("From File: \(luckyNumberFromFile)")
        }
        .font(.footnote)
    }

    private var luckyNumberFromUserDefaults: Int {
        UserDefaults.appGroup.integer(forKey: UserDefaults.Keys.luckyNumber.rawValue)
    }

    private var luckyNumberFromFile: Int {
        let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            return 0
        }
        return Int(text) ?? 0
    }
}

struct AppGroupWidget: Widget {
    private let kind: String = WidgetKind.appGroup

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppGroupWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AppGroup Widget")
        .description("A demo showcasing how to use an App Group to share data between an App and its Widget.")
        .supportedFamilies([.systemSmall])
    }
}
