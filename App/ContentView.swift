//
//  ContentView.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import CoreData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @AppStorage(Key.luckyNumber.rawValue, store: .appGroup) private var luckyNumber = 0

    @State private var contacts = Contact.getAll()

    @FetchRequest(entity: Item.entity(), sortDescriptors: []) private var items: FetchedResults<Item>

    var body: some View {
        List {
            appGroupWidgetSection
            coreDataWidgetSection
            deepLinkWidgetSection
            dynamicIntentWidgetSection
            previewWidgetSection
        }
        .listStyle(InsetGroupedListStyle())
    }
}

extension ContentView {
    private var appGroupWidgetSection: some View {
        Section(header: Text("AppGroup Widget")) {
            Text("Lucky number: \(luckyNumber)")
            Button("Generate new lucky number") {
                luckyNumber = Int.random(in: 1 ... 99)
                WidgetCenter.shared.reloadTimelines(ofKind: "AppGroupWidget")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
        }
        .onChange(of: luckyNumber) { _ in
            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
            try? String(luckyNumber).write(to: url, atomically: false, encoding: .utf8)
        }
    }
}

extension ContentView {
    private var coreDataWidgetSection: some View {
        Section(header: Text("CoreData Widget")) {
            Text("Items count: \(items.count)")
            Button("Add new item") {
                let context = CoreDataStack.shared.workingContext
                let item = Item(context: context)
                item.name = "test"
                item.count = 1
                CoreDataStack.shared.saveWorkingContext(context: context)
                WidgetCenter.shared.reloadTimelines(ofKind: "CoreDataWidget")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
            Button("Delete all items") {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                do {
                    try CoreDataStack.shared.managedObjectContext.executeAndMergeChanges(deleteRequest)
                } catch {
                    print(error.localizedDescription)
                }
                WidgetCenter.shared.reloadTimelines(ofKind: "CoreDataWidget")
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.red)
        }
        .onChange(of: luckyNumber) { _ in
            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
            try? String(luckyNumber).write(to: url, atomically: false, encoding: .utf8)
        }
    }
}

extension ContentView {
    private var deepLinkWidgetSection: some View {
        Section(header: Text("DeepLink Widget")) {
            Text("")
                .onOpenURL { url in
                    if url.scheme == "widget-DeepLinkWidget", url.host == "widgetFamily" {
                        let widgetFamily = url.lastPathComponent
                        print("Opened from widget of size: \(widgetFamily)")
                    }
                }
        }
    }
}

extension ContentView {
    private var dynamicIntentWidgetSection: some View {
        Section(header: Text("Dynamic Intent Widget")) {
            ForEach(contacts.indices, id: \.self) { index in
                HStack {
                    TextField("", text: $contacts[index].name, onCommit: {
                        saveContacts()
                    })
                    DatePicker("", selection: $contacts[index].dateOfBirth, displayedComponents: .date)
                        .onChange(of: contacts[index].dateOfBirth) { _ in
                            saveContacts()
                        }
                }
            }
        }
    }

    private func saveContacts() {
        let key = UserDefaults.Keys.contacts.rawValue
        UserDefaults.appGroup.setArray(contacts, forKey: key)
        WidgetCenter.shared.reloadTimelines(ofKind: "DynamicIntentWidget")
    }
}

extension ContentView {
    private var previewWidgetSection: some View {
        let entry = PreviewWidgetEntry(date: Date(), systemImageName: "star.fill")
        return Section(header: Text("Preview Widget")) {
            HStack {
                PreviewWidgetEntryView(entry: entry)
                    .frame(width: 200, height: 200)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
