//
//  LockScreenWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 20.09.2022.
//  Copyright © 2022 Pawel Wiszenko. All rights reserved.
//

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
        let nextRefreshDate = Calendar.current.date(byAdding: .hour, value: 1, to: currentDate)!

        let hoursPassedSinceMidnight = Calendar.current.dateComponents([.hour], from: midnight, to: currentDate).hour ?? 0
        let passedFractionOfDay = hoursPassedSinceMidnight * 100 / 24

        let entries = [SimpleEntry(date: currentDate, percent: passedFractionOfDay)]
        let timeline = Timeline(entries: entries, policy: .after(nextRefreshDate))
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
