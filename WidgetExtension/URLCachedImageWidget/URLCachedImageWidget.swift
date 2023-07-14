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

private struct Provider: TimelineProvider {
    private static let imageURL = "https://raw.githubusercontent.com/pawello2222/country-flags/main/png1000px/pl.png"

    private static var cancellables = Set<AnyCancellable>()

    // MARK: Cache

    private static let cache = NSCache<NSURL, NSData>()

    private func getImageFromCache(url: URL) -> Data? {
        guard let data = Self.cache.object(forKey: url as NSURL) else {
            return nil
        }
        return data as Data
    }

    private func saveImageToCache(url: URL, data: Data) {
        Self.cache.setObject(data as NSData, forKey: url as NSURL)
    }

    // MARK: TimelineProvider

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
        loadImageData { imageData, isCached in
            let currentDate = Date()
            let nextDate = Calendar.current.date(byAdding: .minute, value: 1, to: currentDate)!
            let entries = [
                SimpleEntry(date: currentDate, imageData: imageData, isCached: isCached),
                SimpleEntry(date: nextDate, imageData: imageData, isCached: isCached)
            ]
            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
    }

    private func loadImageData(completion: @escaping (Data?, Bool) -> Void) {
        guard let url = URL(string: Self.imageURL) else {
            completion(nil, false)
            return
        }
        if let imageData = getImageFromCache(url: url) {
            completion(imageData, true)
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink { _ in } receiveValue: {
                Self.cache.setObject($0 as NSData, forKey: url as NSURL)
                completion($0, false)
            }
            .store(in: &Self.cancellables)
    }
}

private struct SimpleEntry: TimelineEntry {
    let date: Date
    var imageData: Data?
    var isCached = false
}

private struct URLCachedImageWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        if let data = entry.imageData {
            URLImageView(data: data)
                .aspectRatio(contentMode: .fill)
        }
        Text("isCached: \(entry.isCached.description)")
    }
}

struct URLCachedImageWidget: Widget {
    private let kind: String = WidgetKind.urlCachedImage

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            URLCachedImageWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("URLCachedImage Widget")
        .description("A Widget that displays an Image downloaded from an external URL and caches it.")
        .supportedFamilies([.systemSmall])
    }
}
