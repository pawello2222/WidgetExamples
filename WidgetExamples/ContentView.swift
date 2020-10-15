//
//  ContentView.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//

import SwiftUI
import WidgetKit

struct ContentView: View {
    @AppStorage(UserDefaults.Keys.luckyNumber.rawValue, store: UserDefaults.appGroup) var luckyNumber = 0

    var body: some View {
        VStack {
            Text("Lucky number: \(luckyNumber)")
            Button("Generate new lucky number") {
                luckyNumber = Int.random(in: 1...99)
                WidgetCenter.shared.reloadTimelines(ofKind: "AppGroupWidget")
            }
        }
        .onChange(of: luckyNumber) { _ in
            let url = FileManager.appGroupContainerURL.appendingPathComponent(FileManager.luckyNumberFilename)
            try? String(luckyNumber).write(to: url, atomically: false, encoding: .utf8)
        }
        .onOpenURL { url in
            if url.scheme == "widget-DeepLinkWidget", url.host == "widgetFamily" {
                let widgetFamily = url.lastPathComponent
                print("Opened from widget of size: \(widgetFamily)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
