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

struct AppGroupWidgetView: View {
    @AppStorage(UserDefaultKey.luckyNumber, store: .appGroup)
    private var luckyNumber = 0

    var body: some View {
        List {
            Section {
                contentView
            } header: {
                headerView
            }
        }
        .navigationTitle("App Group")
        .onChange(of: luckyNumber) {
            saveNumberToFile()
            reloadWidgetTimelines()
        }
    }
}

// MARK: - Content

extension AppGroupWidgetView {
    private var headerView: some View {
        Text("Lucky number")
    }

    @ViewBuilder
    private var contentView: some View {
        numberView
        buttonView
    }

    private var numberView: some View {
        Label("Your lucky number is \(luckyNumber)", systemImage: "star")
    }

    private var buttonView: some View {
        Button {
            generateLuckyNumber()
        } label: {
            Text("Generate new number")
        }
    }
}

// MARK: - Helpers

extension AppGroupWidgetView {
    private func generateLuckyNumber() {
        luckyNumber = Int.random(in: 1 ... 99)
    }

    private func saveNumberToFile() {
        FileManager.saveStringToFile(
            String(luckyNumber),
            filename: Shared.luckyNumberFilename
        )
    }

    private func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetType.appGroup.kind)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AppGroupWidgetView()
    }
}
