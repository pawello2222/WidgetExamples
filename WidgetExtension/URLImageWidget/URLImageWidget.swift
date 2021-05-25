//
//  URLImageWidget.swift
//  WidgetExtension
//
//  Created by Pawel on 15/10/2020.
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

private struct URLImageWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        URLImageView(url: URL(string: "https://raw.githubusercontent.com/hjnilsson/country-flags/master/png1000px/pl.png")!)
            .aspectRatio(contentMode: .fill)
    }
}

struct URLImageWidget: Widget {
    let kind: String = WidgetKind.urlImage

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            URLImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("URLImage Widget")
        .description("A Widget that displays an Image downloaded from an external URL.")
        .supportedFamilies([.systemSmall])
    }
}
