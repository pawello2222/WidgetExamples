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

import CoreData
import SwiftUI
import WidgetKit

struct CoreDataWidgetView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @FetchRequest(entity: Document.entity(), sortDescriptors: [])
    private var documents: FetchedResults<Document>

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
        .navigationTitle("Core Data")
        .toolbar {
            Button(action: addItem) {
                Label("Add Document", systemImage: "plus")
            }
        }
    }
}

// MARK: - Content

extension CoreDataWidgetView {
    private var headerView: some View {
        Text("Documents")
    }

    private var footerView: some View {
        Text("Count: \(documents.count)")
    }

    @ViewBuilder
    private var contentView: some View {
        if documents.isEmpty {
            noDocumentsView
        } else {
            documentsView
        }
    }

    private var noDocumentsView: some View {
        Label("No documents", systemImage: "doc.plaintext")
    }

    private var documentsView: some View {
        ForEach(documents) {
            Label($0.name, systemImage: "doc.plaintext")
        }
        .onDelete(perform: deleteItems)
    }
}

// MARK: - Helpers

extension CoreDataWidgetView {
    private func addItem() {
        withAnimation {
            _ = Document(context: managedObjectContext)
            try? managedObjectContext.save()
        }
        reloadWidgetTimelines()
    }

    private func deleteItems(at offsets: IndexSet) {
        withAnimation {
            offsets.forEach {
                managedObjectContext.delete(documents[$0])
                try? managedObjectContext.save()
            }
        }
        reloadWidgetTimelines()
    }

    private func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetType.coreData.kind)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        CoreDataWidgetView()
            .environment(\.managedObjectContext, .preview.managedObjectContext)
    }
}
