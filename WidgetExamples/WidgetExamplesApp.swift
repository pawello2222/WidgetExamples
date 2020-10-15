//
//  WidgetExamplesApp.swift
//  WidgetExamples
//
//  Created by Pawel on 15/10/2020.
//

import SwiftUI

@main
struct WidgetExamplesApp: App {
    var body: some Scene {
        let moc = CoreDataStack.shared.managedObjectContext
        return WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, moc)
        }
    }
}
