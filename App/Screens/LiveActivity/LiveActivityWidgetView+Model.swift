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
import Foundation
import Observation

@Observable
final class LiveActivityWidgetViewModel {
    // swiftformat:disable redundantNilInit
    private(set) var activityViewState: ActivityViewState? = nil

    private var currentActivity: Activity<DeliveryAttributes>? = nil
}

// MARK: - Actions

extension LiveActivityWidgetViewModel {
    func onStartDelivery() {
        do {
            let delivery = Delivery.sent()
            let expectedArrivalDate = delivery.date.adding(.minute, value: Int.random(in: 5 ... 10))
            let attributes = DeliveryAttributes(delivery: delivery)
            let state = DeliveryAttributes.ContentState(
                expectedArrivalDate: expectedArrivalDate,
                deliveryState: .sent
            )
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: nil)
            )
            setup(activity: activity, for: delivery)
        } catch {
            print("Couldn't start activity: \(String(describing: error))")
        }
    }

    func onUpdateDelivery(isDelay: Bool) {
        Task {
            activityViewState?.isUpdating = true
            try await updateDelivery(isDelay: isDelay)
            activityViewState?.isUpdating = false
        }
    }

    func onEndDelivery(dismissTimeInterval: Double?) {
        Task {
            await endDelivery(dismissTimeInterval: dismissTimeInterval)
        }
    }
}

// MARK: - Activity

extension LiveActivityWidgetViewModel {
    private func setup(activity: Activity<DeliveryAttributes>, for delivery: Delivery) {
        currentActivity = activity

        activityViewState = .init(
            delivery: delivery,
            activityState: activity.activityState,
            contentState: activity.content.state
        )

        observe(activity: activity)
    }

    private func observe(activity: Activity<DeliveryAttributes>) {
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask { @MainActor in
                    for await activityState in activity.activityStateUpdates {
                        if activityState == .dismissed {
                            self.resetActivity()
                        } else {
                            self.activityViewState?.activityState = activityState
                        }
                    }
                }
                group.addTask { @MainActor in
                    for await content in activity.contentUpdates {
                        self.activityViewState?.contentState = content.state
                    }
                }
            }
        }
    }

    private func resetActivity() {
        currentActivity = nil
        activityViewState = nil
    }

    private func updateDelivery(isDelay: Bool) async throws {
        guard let activity = currentActivity else {
            return
        }

        try await Task.sleep(for: .seconds(2))

        var alertConfig: AlertConfiguration?
        let state: DeliveryAttributes.ContentState
        if isDelay {
            let delivery = activity.attributes.delivery

            alertConfig = AlertConfiguration(
                title: "Unexpected delay!",
                body: "Delivery \(delivery.id) has been delayed!",
                sound: .default
            )

            let delay = Int.random(in: 5 ... 15)
            let expectedArrivalDate = activity.content.state.expectedArrivalDate.adding(.minute, value: Int.random(in: 1 ... 3))

            state = DeliveryAttributes.ContentState(
                expectedArrivalDate: expectedArrivalDate,
                deliveryState: .delayed
            )
        } else {
            state = DeliveryAttributes.ContentState(
                expectedArrivalDate: activity.content.state.expectedArrivalDate,
                deliveryState: .sent
            )
        }

        await activity.update(
            .init(
                state: state,
                staleDate: Date.now + 15,
                relevanceScore: isDelay ? 100 : 50
            ),
            alertConfiguration: alertConfig
        )
    }

    fileprivate func endDelivery(dismissTimeInterval: Double?) async {
        guard let activity = currentActivity else {
            return
        }

        let state = DeliveryAttributes.ContentState(
            expectedArrivalDate: .now,
            deliveryState: .arrived
        )

        let dismissalPolicy: ActivityUIDismissalPolicy
        if let dismissTimeInterval {
            if dismissTimeInterval <= 0 {
                dismissalPolicy = .immediate
            } else {
                dismissalPolicy = .after(.now + dismissTimeInterval)
            }
        } else {
            dismissalPolicy = .default
        }

        await activity.end(ActivityContent(state: state, staleDate: nil), dismissalPolicy: dismissalPolicy)
    }
}

// MARK: - ActivityViewState

extension LiveActivityWidgetViewModel {
    struct ActivityViewState: Sendable {
        var delivery: Delivery
        var activityState: ActivityState
        var contentState: DeliveryAttributes.ContentState

        var isUpdating = false

        var isActive: Bool {
            [.active, .stale].contains(activityState)
        }

        var isStale: Bool {
            activityState == .stale
        }
    }
}
