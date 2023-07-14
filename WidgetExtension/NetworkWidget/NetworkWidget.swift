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

import Combine
import SwiftUI
import WidgetKit

private var cancellables = Set<AnyCancellable>()

private struct Provider: TimelineProvider {
    private let currencyWebRepository = CurrencyWebRepository()

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
            .sink {
                switch $0 {
                case .failure(let error):
                    print(error.localizedDescription)
                    let entries = [
                        SimpleEntry(date: currentDate),
                        SimpleEntry(date: nextDate)
                    ]
                    let timeline = Timeline(entries: entries, policy: .atEnd)
                    completion(timeline)
                case .finished:
                    print("Request completed")
                }
            } receiveValue: {
                let entries = [
                    SimpleEntry(date: currentDate, currencyRate: $0),
                    SimpleEntry(date: nextDate, currencyRate: $0)
                ]
                let timeline = Timeline(entries: entries, policy: .atEnd)
                completion(timeline)
            }
            .store(in: &cancellables)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var currencyRate: CurrencyRatesResource.Response?
}

private struct NetworkWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            Text(entry.date, style: .date)
            Text(text)
        }
    }

    private var text: String {
        guard let currencyRate = entry.currencyRate, let firstRate = currencyRate.rates.first else {
            return "?"
        }
        return "\(currencyRate.base)/\(firstRate.key): \(firstRate.value)"
    }
}

struct NetworkWidget: Widget {
    private let kind: String = WidgetKind.network

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NetworkWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Network Widget")
        .description("A demo showcasing how to load data from a network request and populate the Widget Timeline.")
        .supportedFamilies([.systemSmall])
    }
}
