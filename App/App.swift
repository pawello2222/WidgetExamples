//
//  App.swift
//  WidgetExamples
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
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
