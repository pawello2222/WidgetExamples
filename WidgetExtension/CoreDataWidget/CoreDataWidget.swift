//
//  CoreDataWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import CoreData
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

private struct CoreDataWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        return Text("Items count: \(itemsCount)")
    }

    var itemsCount: Int {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            return try CoreDataStack.shared.managedObjectContext.count(for: request)
        } catch {
            print(error.localizedDescription)
            return 0
        }
    }
}

struct CoreDataWidget: Widget {
    let kind: String = WidgetKind.coreData

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            CoreDataWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("CoreData Widget")
        .description("A demo showcasing how to use Core Data in a Widget.")
        .supportedFamilies([.systemSmall])
    }
}
