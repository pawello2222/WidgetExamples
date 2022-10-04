//
//  Widget+Kind.swift
//  WidgetExamples
//
//  Created by Pawel Wiszenko on 25.05.2021.
//  Copyright © 2021 Pawel Wiszenko. All rights reserved.
//

import Foundation

enum WidgetKind {
    static var appGroup: String { widgetKind(#function) }
    static var clock: String { widgetKind(#function) }
    static var coreData: String { widgetKind(#function) }
    static var countdown: String { widgetKind(#function) }
    static var deepLink: String { widgetKind(#function) }
    static var dynamicIntent: String { widgetKind(#function) }
    static var environment: String { widgetKind(#function) }
    static var intent: String { widgetKind(#function) }
    static var lockScreen: String { widgetKind(#function) }
    static var network: String { widgetKind(#function) }
    static var preview: String { widgetKind(#function) }
    static var timer: String { widgetKind(#function) }
    static var urlImage: String { widgetKind(#function) }
    static var urlCachedImage: String { widgetKind(#function) }

    private static func widgetKind(_ kind: String) -> String {
        kind + "Widget"
    }
}
