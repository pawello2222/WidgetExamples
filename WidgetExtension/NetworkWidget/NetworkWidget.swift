//
//  NetworkWidget.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import Combine
import SwiftUI
import WidgetKit

private var cancellables = Set<AnyCancellable>()

private struct Provider: TimelineProvider {
    let currencyWebRepository = CurrencyWebRepository()

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        let currentDate = Date()
        let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
        currencyWebRepository.fetchAPIResource(CurrencyRatesResource("EUR", date: currentDate))
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    print(error.localizedDescription)
                    let entries = [
                        SimpleEntry(date: currentDate),
                        SimpleEntry(date: nextDate),
                    ]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                case .finished:
                    print("Request completed")
                }
            }, receiveValue: {
                let entries = [
                    SimpleEntry(date: currentDate, currencyRate: $0),
                    SimpleEntry(date: nextDate, currencyRate: $0),
                ]
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            })
            .store(in: &cancellables)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var currencyRate: CurrencyRatesResource.Response?
}

private struct NetworkWidgetEntryView: View {
    var entry: Provider.Entry

    var text: String {
        guard let currencyRate = entry.currencyRate, let firstRate = currencyRate.rates.first else {
            return "?"
        }
        return "\(currencyRate.base)/\(firstRate.key): \(firstRate.value)"
    }

    var body: some View {
        VStack {
            Text(entry.date, style: .date)
            Text(text)
        }
    }
}

struct NetworkWidget: Widget {
    let kind: String = WidgetKind.network

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NetworkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Network Widget")
        .description("A demo showcasing how to load data from a network request and populate the Widget Timeline.")
        .supportedFamilies([.systemSmall])
    }
}
