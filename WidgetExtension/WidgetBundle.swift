//
//  WidgetBundle.swift
//  WidgetExtension
//
//  Created by Pawel Wiszenko on 15.10.2020.
//  Copyright © 2020 Pawel Wiszenko. All rights reserved.
//

import SwiftUI
import WidgetKit

@main
struct WidgetExamplesWidgetBundle: WidgetBundle {
    var body: some Widget {
        WidgetBundle1().body
        WidgetBundle2().body
        WidgetBundle3().body
    }
}

struct WidgetBundle1: WidgetBundle {
    var body: some Widget {
        AppGroupWidget()
        ClockWidget()
        CoreDataWidget()
        CountdownWidget()
        DeepLinkWidget()
    }
}

struct WidgetBundle2: WidgetBundle {
    var body: some Widget {
        EnvironmentWidget()
        NetworkWidget()
        PreviewWidget()
        TimerWidget()
        URLImageWidget()
    }
}

struct WidgetBundle3: WidgetBundle {
    var body: some Widget {
        IntentWidget()
        DynamicIntentWidget()
    }
}
