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

extension URLImageWidget {
    struct Provider: TimelineProvider {
        private static let imageURL
            = "https://raw.githubusercontent.com/pawello2222/country-flags/main/png1000px/pl.png"
        private static let cache = NSCache<NSURL, NSData>()
        private static var cancellables = Set<AnyCancellable>()
        private static var requestCount = 0

        func placeholder(in context: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.placeholder)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            Self.requestCount += 1
            loadImage { image in
                let currentDate = Date()
                let nextDate = currentDate.adding(.minute, value: 1)
                let entries = [
                    Entry(date: currentDate, image: image, requestCount: Self.requestCount),
                    Entry(date: nextDate, image: .isLoading, requestCount: Self.requestCount)
                ]
                completion(.init(entries: entries, policy: .atEnd))
            }
        }
    }
}

// MARK: - Helpers

extension URLImageWidget.Provider {
    private func loadImage(completion: @escaping (Loadable<Image>) -> Void) {
        guard let url = URL(string: Self.imageURL) else {
            completion(.failed(error: "Invalid URL"))
            return
        }
        if let imageData = getImageFromCache(url: url) {
            guard let image = image(from: imageData) else {
                completion(.failed(error: "Cache error"))
                return
            }
            completion(.cached(value: image))
            return
        }
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure:
                    completion(.failed(error: "Request error"))
                case .finished:
                    break
                }
            } receiveValue: {
                Self.cache.setObject($0 as NSData, forKey: url as NSURL)
                guard let image = image(from: $0) else {
                    completion(.failed(error: "Image error"))
                    return
                }
                completion(.loaded(value: image))
            }
            .store(in: &Self.cancellables)
    }

    private func image(from data: Data) -> Image? {
        guard let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}

// MARK: - Cache

extension URLImageWidget.Provider {
    private func getImageFromCache(url: URL) -> Data? {
        guard let data = Self.cache.object(forKey: url as NSURL) else {
            return nil
        }
        return data as Data
    }

    private func saveImageToCache(url: URL, data: Data) {
        Self.cache.setObject(data as NSData, forKey: url as NSURL)
    }
}
