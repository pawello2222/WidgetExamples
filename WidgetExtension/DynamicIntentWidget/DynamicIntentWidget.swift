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

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), contact: .friend1)
    }

    func getSnapshot(
        for configuration: DynamicPersonSelectionIntent,
        in context: Context,
        completion: @escaping (SimpleEntry) -> Void
    ) {
        let entry = SimpleEntry(date: Date(), contact: .friend1)
        completion(entry)
    }

    func getTimeline(
        for configuration: DynamicPersonSelectionIntent,
        in context: Context,
        completion: @escaping (Timeline<Entry>) -> Void
    ) {
        let entries = [SimpleEntry(date: Date(), contact: contact(for: configuration))]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }

    func contact(for configuration: DynamicPersonSelectionIntent) -> Contact? {
        guard
            let identifier = configuration.person?.identifier,
            let contact = Contact.from(identifier: identifier)
        else {
            return nil
        }
        return contact
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var contact: Contact?
}

private struct DynamicIntentWidgetEntryView: View {
    var entry: Provider.Entry

    @ViewBuilder
    var body: some View {
        if let contact = entry.contact {
            contactView(for: contact)
        } else {
            Text("Edit Widget to choose contact")
        }
    }

    private func contactView(for contact: Contact) -> some View {
        VStack {
            Text(contact.name)
                .fontWeight(.semibold)
            Group {
                Text("Date of birth:")
                Text(contact.dateOfBirth, style: .date)
                    .multilineTextAlignment(.center)
            }
            .font(.footnote)
            .foregroundColor(.gray)
        }
    }
}

struct DynamicIntentWidget: Widget {
    private let kind: String = WidgetKind.dynamicIntent

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicPersonSelectionIntent.self, provider: Provider()) { entry in
            DynamicIntentWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Dynamic Intent Widget")
        .description("A Widget that has dynamically configurable data.")
        .supportedFamilies([.systemSmall])
    }
}
