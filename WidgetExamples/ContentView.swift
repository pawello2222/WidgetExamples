//
//  ContentView.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//

import CoreData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext

    @AppStorage(UserDefaults.Keys.luckyNumber.rawValue, store: UserDefaults.appGroup) private var luckyNumber = 0

    @FetchRequest(entity: Item.entity(), sortDescriptors: []) private var items: FetchedResults<Item>

    var body: some View {
        List {
            appGroupWidgetSection
            coreDataWidgetSection
            deepLinkWidgetSection
            previewWidgetSection
        }
        .listStyle(InsetGroupedListStyle())
    }

    var appGroupWidgetSection: some View {
        Section(header: Text("AppGroup Widget")) {
            Text("Lucky number: \(luckyNumber)")
            Button("Generate new lucky number") {
                luckyNumber = Int.random(in: 1...99)
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

    var coreDataWidgetSection: some View {
        return Section(header: Text("CoreData Widget")) {
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

    var deepLinkWidgetSection: some View {
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

    var previewWidgetSection: some View {
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
