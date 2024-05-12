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

@main
struct WidgetExamplesApp: App {
    var body: some Scene {
        WindowGroup {
            let persistenceController = PersistenceController.shared
            ContentView()
                .environment(\.managedObjectContext, persistenceController.managedObjectContext)
                .modelContainer(for: Product.self)
        }
    }
}

// MARK: - Screenshots

extension WidgetExamplesApp {
    @MainActor
    private func createScreenshot() {
        let view = SharedViewWidgetEntryView(entry: .placeholder)
            .padding(15)
            .frame(width: 150, height: 150)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(15)
            .environment(\.locale, .init(identifier: "en_US"))
        let renderer = ImageRenderer(content: view)
        renderer.scale = 10
        let filename = URL.documentsDirectory.appending(path: "SharedViewWidget.png")
        try? renderer.uiImage?.pngData()?.write(to: filename)
        print(filename)
    }
}
