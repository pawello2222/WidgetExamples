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

import AppIntents
import WidgetKit

struct IntentWidgetIntent: WidgetConfigurationIntent {
    static let title: LocalizedStringResource = "Background Color"
    static let description = IntentDescription("Change the background color of the widget.")

    @Parameter(title: "Background", default: IntentWidgetBackgroundType.color)
    var background: IntentWidgetBackgroundType

    @Parameter(title: "Color", default: IntentWidgetBackgroundColor.teal)
    var primaryColor: IntentWidgetBackgroundColor

    @Parameter(title: "Color 2")
    var secondaryColor: IntentWidgetBackgroundColor?

    init(
        background: IntentWidgetBackgroundType = .color,
        primaryColor: IntentWidgetBackgroundColor = .teal,
        secondaryColor: IntentWidgetBackgroundColor? = nil
    ) {
        self.background = background
        self.primaryColor = primaryColor
        self.secondaryColor = secondaryColor
    }

    init() {}

    static var parameterSummary: some ParameterSummary {
        When(\.$background, .equalTo, IntentWidgetBackgroundType.gradient) {
            Summary {
                \.$background
                \.$primaryColor
                \.$secondaryColor
            }
        } otherwise: {
            Summary {
                \.$background
                \.$primaryColor
            }
        }
    }
}

// MARK: - BackgroundContent

enum IntentWidgetBackgroundType: String, AppEnum {
    case color
    case gradient

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Background")

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .color: DisplayRepresentation(title: "Color"),
        .gradient: DisplayRepresentation(title: "Gradient")
    ]
}

// MARK: - BackgroundColor

enum IntentWidgetBackgroundColor: String, AppEnum {
    case teal
    case yellow

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Color")

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .teal: .init(title: "Teal"),
        .yellow: .init(title: "Yellow")
    ]
}
