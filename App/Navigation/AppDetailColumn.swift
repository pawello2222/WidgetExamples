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

struct AppDetailColumn: View {
    @State private var navigationPath = NavigationPath()

    var screen: AppScreen?

    var body: some View {
        NavigationStack(path: $navigationPath) {
            Group {
                if let screen {
                    screen.destination
                } else {
                    ContentUnavailableView(
                        "Select a widget",
                        systemImage: "square.grid.2x2",
                        description: Text("Choose a widget to edit its settings.")
                    )
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .navigationDestination(for: Route.self) {
                if case .deepLink(let widgetFamily) = $0 {
                    DeepLinkWidgetView(widgetFamily: widgetFamily)
                }
            }
        }
        .onOpenURL {
            parse(url: $0)
        }
    }
}

// MARK: - Helpers

extension AppDetailColumn {
    private func parse(url: URL) {
        print("Opened url: \(url)")
        guard
            url.scheme == Shared.DeepLink.scheme,
            url.host == WidgetType.deepLink.kind,
            let widgetFamily = url.queryParameter(name: Shared.DeepLink.widgetFamily)
        else {
            return
        }
        navigationPath.append(Route.deepLink(widgetFamily: widgetFamily))
    }
}

// MARK: - Preview

#Preview {
    AppDetailColumn()
}
