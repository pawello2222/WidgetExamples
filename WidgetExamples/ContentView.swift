//
//  ContentView.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage(UserDefaults.Keys.luckyNumber.rawValue, store: UserDefaults.appGroup) private var luckyNumber = 0

    var body: some View {
        List {
            appGroupWidgetSection
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

    var deepLinkWidgetSection: some View {
        Section(header: Text("DeepLink Widget")) {
            Text("Last opened widget")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
