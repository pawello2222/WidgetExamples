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

enum AppScreen: Hashable, CaseIterable {
    case appGroup
    case coreData
    case dynamicIntent
    case liveActivity
    case sharedView
    case swiftData
}

// MARK: - Identifiable

extension AppScreen: Identifiable {
    var id: AppScreen { self }
}

// MARK: - Computed Properties

extension AppScreen {
    var title: String {
        switch self {
        case .appGroup:
            "App Group"
        case .coreData:
            "Core Data"
        case .dynamicIntent:
            "Dynamic Intent"
        case .liveActivity:
            "Live Activity"
        case .sharedView:
            "Shared View"
        case .swiftData:
            "Swift Data"
        }
    }

    var icon: String {
        "square.grid.2x2.fill"
    }
}

// MARK: - Destination

extension AppScreen {
    @ViewBuilder
    var view: some View {
        switch self {
        case .appGroup:
            AppGroupWidgetView()
        case .coreData:
            CoreDataWidgetView()
        case .dynamicIntent:
            DynamicIntentWidgetView()
        case .liveActivity:
            LiveActivityWidgetView()
        case .sharedView:
            SharedViewWidgetView()
        case .swiftData:
            SwiftDataWidgetView()
        }
    }
}
