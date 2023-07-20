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

import WidgetKit

extension CoreDataWidget {
    struct Entry: TimelineEntry {
        var date: Date = .now
        var documentInfo: DocumentInfo?
    }
}

// MARK: - DocumentInfo

extension CoreDataWidget.Entry {
    struct DocumentInfo {
        let count: Int
        let lastItem: Document?
    }
}

extension CoreDataWidget.Entry.DocumentInfo {
    struct Document {
        var name: String
        var creationDate: Date
    }
}

// MARK: - Data

extension CoreDataWidget.Entry {
    static var empty: Self {
        .init()
    }

    static var placeholder: Self {
        .init(documentInfo: .placeholder)
    }
}

extension CoreDataWidget.Entry.DocumentInfo {
    static var placeholder: Self {
        .init(count: 1, lastItem: .placeholder)
    }
}

extension CoreDataWidget.Entry.DocumentInfo.Document {
    static var placeholder: Self {
        .init(name: "Document 1", creationDate: .now)
    }
}
