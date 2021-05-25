//
//  CountdownWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import SwiftUI
import WidgetKit

private struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), displayDate: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), displayDate: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        let currentDate = Date()
        let firstDate = Calendar.current.date(byAdding: .second, value: 50, to: currentDate)!
        let secondDate = Calendar.current.date(byAdding: .second, value: 60, to: currentDate)!

        let entries = [
            SimpleEntry(date: currentDate, displayDate: secondDate),
            SimpleEntry(date: firstDate, displayDate: secondDate, isDateClose: true),
        ]

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let displayDate: Date
    var isDateClose = false
}

private struct CountdownWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        Text(entry.displayDate, style: .timer)
            .foregroundColor(entry.isDateClose ? .red : .primary)
    }
}

struct CountdownWidget: Widget {
    let kind: String = WidgetKind.countdown

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CountdownWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Countdown Widget")
        .description("A Widget that displays the remaining time in seconds and changes color when the end date is approaching.")
        .supportedFamilies([.systemSmall])
    }
}
