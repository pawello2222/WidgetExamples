//
//  DynamicIntentWidget.swift
//  WidgetExamples
//
//  Created by Pawel on 03/11/2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import SwiftUI
import WidgetKit

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), contact: .friend1)
    }

    func getSnapshot(for configuration: DynamicPersonSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date(), contact: .friend1)
        completion(entry)
    }

    func getTimeline(for configuration: DynamicPersonSelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let entries = [SimpleEntry(date: Date(), contact: contact(for: configuration))]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }

    func contact(for configuration: DynamicPersonSelectionIntent) -> Contact {
        if let id = configuration.person?.identifier, let contact = Contact.fromId(id) {
            return contact
        }
        return .friend1
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    let contact: Contact
}

private struct DynamicIntentWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.contact.name)
                .fontWeight(.semibold)
            Group {
                Text("Date of birth:")
                Text(entry.contact.dateOfBirth, style: .date)
                    .multilineTextAlignment(.center)
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
    }
}

struct DynamicIntentWidget: Widget {
    let kind: String = "DynamicIntentWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicPersonSelectionIntent.self, provider: Provider()) { entry in
            DynamicIntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dynamic Intent Widget")
        .description("A Widget that has dynamically configurable data.")
        .supportedFamilies([.systemSmall])
    }
}
