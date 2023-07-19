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

import ActivityKit
import SwiftUI

struct LiveActivityWidgetView: View {
    @State private var model = LiveActivityWidgetViewModel()

    var body: some View {
        List {
            contentView
        }
        .navigationTitle("Live Activity")
    }
}

// MARK: - Content

extension LiveActivityWidgetView {
    @ViewBuilder
    private var contentView: some View {
        if let state = model.activityViewState {
            updateDeliveryView
            endDeliveryView
            liveActivityView(state: state)
        } else {
            startDeliveryView
        }
    }

    private var startDeliveryView: some View {
        Section("Start Delivery") {
            Button("Start") {
                model.onStartDelivery()
            }
        }
    }

    private var updateDeliveryView: some View {
        Section("Update Delivery") {
            Button("Update") {
                model.onUpdateDelivery(isDelay: false)
            }
            Button("Delay (with alert)") {
                model.onUpdateDelivery(isDelay: true)
            }
        }
    }

    private var endDeliveryView: some View {
        Section("End Delivery") {
            Button("Dismiss now") {
                model.onEndDelivery(dismissTimeInterval: 0)
            }
            Button("Dismiss in 10 seconds") {
                model.onEndDelivery(dismissTimeInterval: 10)
            }
            Button("Dismiss by system") {
                model.onEndDelivery(dismissTimeInterval: nil)
            }
        }
    }

    private func liveActivityView(state: LiveActivityWidgetViewModel.ActivityViewState) -> some View {
        Section("Live Activity Preview") {
            LiveActivityView(
                delivery: state.delivery,
                state: state.contentState,
                isStale: state.isStale
            )
            .containerShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LiveActivityWidgetView()
    }
}
