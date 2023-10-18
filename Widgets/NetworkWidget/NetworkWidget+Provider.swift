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

extension NetworkWidget {
    struct Provider: TimelineProvider {
        private static let countryCodes = ["POL", "ESP", "ITA", "MEX"]
        private static var cancellables = Set<AnyCancellable>()
        private let webRepository = CountryWebRepository()

        func placeholder(in context: Context) -> Entry {
            .placeholder
        }

        func getSnapshot(in context: Context, completion: @escaping (Entry) -> Void) {
            completion(.placeholder)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
            loadCountry(code: Self.countryCodes.randomElement()!) { country in
                let currentDate = Date()
                let nextDate = currentDate.adding(.minute, value: 1)
                let entries = [
                    Entry(date: currentDate, country: country),
                    Entry(date: nextDate, country: .isLoading)
                ]
                completion(.init(entries: entries, policy: .atEnd))
            }
        }
    }
}

// MARK: - Helpers

extension NetworkWidget.Provider {
    private func loadCountry(
        code: String,
        completion: @escaping (Loadable<Entry.Country>) -> Void
    ) {
        webRepository.fetchAPIResource(CountryResource(code: code))
            .receive(on: DispatchQueue.main)
            .sink {
                switch $0 {
                case .failure:
                    completion(.failed(error: "Request error"))
                case .finished:
                    break
                }
            } receiveValue: {
                completion(.loaded(value: country(from: $0)))
            }
            .store(in: &Self.cancellables)
    }

    private func country(from response: CountryResource.Response) -> Entry.Country {
        .init(
            name: response.name.common,
            capital: response.capital.first ?? "-"
        )
    }
}
