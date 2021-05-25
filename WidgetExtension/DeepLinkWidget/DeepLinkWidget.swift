//
//  DeepLinkWidget.swift
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

private struct DeepLinkWidgetEntryView: View {
    @Environment(\.widgetFamily) var widgetFamily

    var entry: Provider.Entry

    var deeplinkURL: URL {
        URL(string: "widget-DeepLinkWidget://widgetFamily/\(widgetFamily)")!
    }

    @ViewBuilder
    var body: some View {
        if widgetFamily == .systemSmall {
            Text("Tap anywhere")
                .widgetURL(deeplinkURL)
        } else {
            Link("Tap me", destination: deeplinkURL)
        }
    }
}

struct DeepLinkWidget: Widget {
    let kind: String = WidgetKind.deepLink

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DeepLinkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("DeepLink Widget")
        .description("A demo showcasing how to use Deep Links to pass events / information from a Widget to the parent App.")
    }
}
