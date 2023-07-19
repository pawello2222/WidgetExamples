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
import WidgetKit

struct LiveActivityWidget: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) {
            LiveActivityView(
                delivery: $0.attributes.delivery,
                state: $0.state,
                isStale: $0.isStale
            )
            .widgetURL(deeplinkURL)
        } dynamicIsland: {
            dynamicIsland(
                delivery: $0.attributes.delivery,
                state: $0.state,
                isStale: $0.isStale
            )
            .widgetURL(deeplinkURL)
        }
    }
}

// MARK: - Content

extension LiveActivityWidget {
    private func dynamicIsland(
        delivery: Delivery,
        state: DeliveryAttributes.ContentState,
        isStale: Bool
    ) -> DynamicIsland {
        DynamicIsland {
            expandedContent(
                delivery: delivery,
                state: state,
                isStale: isStale
            )
        } compactLeading: {
            LiveActivityView.IconView(state: state, isStale: isStale)
        } compactTrailing: {
            LiveActivityView.TimeView(state: state)
        } minimal: {
            LiveActivityView.IconView(state: state, isStale: isStale)
        }
    }

    @DynamicIslandExpandedContentBuilder
    private func expandedContent(
        delivery: Delivery,
        state: DeliveryAttributes.ContentState,
        isStale: Bool
    ) -> DynamicIslandExpandedContent<some View> {
        DynamicIslandExpandedRegion(.leading) {
            LiveActivityView.IconView(state: state, isStale: isStale)
        }
        DynamicIslandExpandedRegion(.trailing) {
            LiveActivityView.TimeView(state: state)
        }
        DynamicIslandExpandedRegion(.center) {
            LiveActivityView.TitleView(delivery: delivery)
        }
        DynamicIslandExpandedRegion(.bottom) {
            LiveActivityView.StatusView(delivery: delivery, state: state)
        }
    }
}

// MARK: - Helpers

extension LiveActivityWidget {
    private var deeplinkURL: URL {
        var components = URLComponents()
        components.scheme = Shared.DeepLink.scheme
        components.host = WidgetType.liveActivity.kind
        return components.url!
    }
}

// MARK: - Preview

#Preview(
    as: .dynamicIsland(.expanded),
    using: DeliveryAttributes(delivery: .sent(minutesAgo: 3))
) {
    LiveActivityWidget()
} contentStates: {
    DeliveryAttributes.ContentState.sent
    DeliveryAttributes.ContentState.delayed
    DeliveryAttributes.ContentState.arrived
}
