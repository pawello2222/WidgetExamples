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

import Foundation

enum DeepLink {
    static let widgetScheme = "widget"
    static let widgetFamilyParamName = "widgetFamily"
}

// MARK: - Builder

extension DeepLink {
    class Builder {
        private var components = URLComponents()

        init(widget: WidgetType) {
            components.scheme = DeepLink.widgetScheme
            components.host = widget.kind
        }

        @discardableResult
        func widgetFamily(_ value: String) -> Self {
            createQueryItemsIfNeeded()
            components.queryItems?.append(
                .init(
                    name: DeepLink.widgetFamilyParamName,
                    value: value
                )
            )
            return self
        }

        func build() -> URL {
            components.url!
        }

        private func createQueryItemsIfNeeded() {
            if components.queryItems == nil {
                components.queryItems = []
            }
        }
    }
}
