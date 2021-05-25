//
//  AppGroupWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

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

    var luckyNumberFromUserDefaults: Int {
        UserDefaults.appGroup.integer(forKey: UserDefaults.Keys.luckyNumber.rawValue)
    }

    var luckyNumberFromFile: Int {
        let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
        guard let text = try? String(contentsOf: url, encoding: .utf8) else { return 0 }
        return Int(text) ?? 0
    }
}

struct AppGroupWidget: Widget {
    let kind: String = WidgetKind.appGroup

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            AppGroupWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("AppGroup Widget")
        .description("A demo showcasing how to use an App Group to share data between an App and its Widget.")
        .supportedFamilies([.systemSmall])
    }
}
