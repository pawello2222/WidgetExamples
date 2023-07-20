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

extension IntentWidget {
    struct EntryView: View {
        let entry: Entry

        var body: some View {
            VStack(alignment: .leading) {
                headerView
                Spacer()
                contentView
                Spacer()
            }
            .containerBackground(backgroundView.opacity(0.7), for: .widget)
        }
    }
}

// MARK: - Content

extension IntentWidget.EntryView {
    private var headerView: some View {
        HStack {
            Text("Intent")
                .font(.headline)
            Spacer()
        }
    }

    private var contentView: some View {
        Text("Edit Widget to change the background")
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }

    private var backgroundView: some ShapeStyle {
        LinearGradient(
            colors: gradientColors,
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Helpers

extension IntentWidget.EntryView {
    private var gradientColors: [Color] {
        switch entry.background.type {
        case .color:
            entry.background.colors.prefix(1).compactMap(color)
        case .gradient:
            entry.background.colors.compactMap(color)
        }
    }

    private func color(from backgroundColor: IntentWidgetBackgroundColor?) -> Color? {
        switch backgroundColor {
        case .teal:
            .teal
        case .yellow:
            .yellow
        case .none:
            nil
        }
    }
}
