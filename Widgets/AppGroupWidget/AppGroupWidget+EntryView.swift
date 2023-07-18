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

extension AppGroupWidget {
    struct EntryView: View {
        var entry: Entry

        var body: some View {
            VStack(alignment: .leading) {
                headerView
                Spacer()
                contentView
                Spacer()
            }
            .containerBackground(.clear, for: .widget)
        }
    }
}

// MARK: - Content

extension AppGroupWidget.EntryView {
    private var headerView: some View {
        HStack {
            Text("App Group")
                .font(.headline)
            Spacer()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        Text("Lucky number")
            .font(.subheadline)
            .bold()
        Group {
            Text("UserDefaults: \(luckyNumberFromUserDefaults)")
            Text("TXT File: \(luckyNumberFromFile)")
        }
        .font(.footnote)
        .foregroundStyle(.secondary)
    }
}

// MARK: - Helpers

extension AppGroupWidget.EntryView {
    private var luckyNumberFromUserDefaults: Int {
        UserDefaults.appGroup.integer(forKey: UserDefaultKey.luckyNumber)
    }

    private var luckyNumberFromFile: Int {
        let url = FileManager.appGroupContainerURL.appendingPathComponent(Shared.luckyNumberFilename)
        guard let text = try? String(contentsOf: url, encoding: .utf8) else {
            return 0
        }
        return Int(text) ?? 0
    }
}
