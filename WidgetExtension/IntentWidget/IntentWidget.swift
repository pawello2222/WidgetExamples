//
//  IntentWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 03.11.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

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

    @ViewBuilder
    var bgColor: some View {
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

    var body: some View {
        ZStack {
            bgColor
            Text(entry.date, style: .date)
                .font(.subheadline)
                .multilineTextAlignment(.center)
        }
    }
}

struct IntentWidget: Widget {
    let kind: String = WidgetKind.intent

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: BackgroundColorSelectionIntent.self, provider: Provider()) { entry in
            IntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Intent Widget")
        .description("A Widget that has a configurable background color.")
        .supportedFamilies([.systemSmall])
    }
}
