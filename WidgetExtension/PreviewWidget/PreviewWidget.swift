//
//  PreviewWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> PreviewWidgetEntry {
        PreviewWidgetEntry(date: Date(), systemImageName: "photo")
    }

    func getSnapshot(in context: Context, completion: @escaping (PreviewWidgetEntry) -> Void) {
        let entry = PreviewWidgetEntry(date: Date(), systemImageName: "photo")
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let midnight = Calendar.current.startOfDay(for: Date())
        let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!
        let entries = [PreviewWidgetEntry(date: midnight, systemImageName: "photo")]
        let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
        completion(timeline)
    }
}

struct PreviewWidget: Widget {
    let kind: String = WidgetKind.preview

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            PreviewWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Preview Widget")
        .description("A demo showcasing how to display a Widget View directly in the parent App.")
        .supportedFamilies([.systemSmall])
    }
}
