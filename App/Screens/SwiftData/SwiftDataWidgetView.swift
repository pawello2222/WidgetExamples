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

import SwiftData
import SwiftUI
import WidgetKit

struct SwiftDataWidgetView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var products: [Product]

    var body: some View {
        List {
            Section {
                contentView
            } header: {
                headerView
            } footer: {
                footerView
            }
        }
        .navigationTitle("Swift Data")
        .toolbar {
            Button(action: addItem) {
                Label("Add Product", systemImage: "plus")
            }
        }
    }
}

// MARK: - Content

extension SwiftDataWidgetView {
    private var headerView: some View {
        Text("Products")
    }

    private var footerView: some View {
        Text("Count: \(products.count)")
    }

    @ViewBuilder
    private var contentView: some View {
        if products.isEmpty {
            noProductsView
        } else {
            productsView
        }
    }

    private var noProductsView: some View {
        Label("No products", systemImage: "shippingbox")
    }

    private var productsView: some View {
        ForEach(products) {
            Label($0.name, systemImage: "shippingbox")
        }
        .onDelete(perform: deleteItems)
    }
}

// MARK: - Helpers

extension SwiftDataWidgetView {
    private func addItem() {
        withAnimation {
            modelContext.insert(Product())
        }
        reloadWidgetTimelines()
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach {
                modelContext.delete(products[$0])
                try? modelContext.save()
            }
        }
        reloadWidgetTimelines()
    }

    private func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetType.swiftData.kind)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        SwiftDataWidgetView()
            .modelContainer(for: Product.self, inMemory: true)
    }
}
