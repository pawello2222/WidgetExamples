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

extension CountdownWidget {
    struct EntryView: View {
        let entry: Entry

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

extension CountdownWidget.EntryView {
    private var headerView: some View {
        HStack {
            Text("Countdown")
                .font(.headline)
            Spacer()
        }
    }

    @ViewBuilder
    private var contentView: some View {
        HStack {
            Text("Timer:")
            timerView
                .foregroundStyle(textColor)
                .id(entry.countdownState)
            Spacer()
        }
    }

    @ViewBuilder
    private var timerView: some View {
        switch entry.countdownState {
        case .counting, .nearEnd:
            Text(entry.displayDate, style: .timer)
        case .end:
            Text("End")
        }
    }
}

// MARK: - Helpers

extension CountdownWidget.EntryView {
    private var textColor: Color {
        switch entry.countdownState {
        case .counting:
            .primary
        case .nearEnd:
            .red
        case .end:
            .secondary
        }
    }
}
