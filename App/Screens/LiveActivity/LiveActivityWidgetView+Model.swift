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

// swiftformat:disable redundantNilInit
// swiftlint:disable redundant_optional_initialization
@Observable
final class LiveActivityWidgetViewModel {
    typealias DeliveryActivity = Activity<DeliveryAttributes>

    private(set) var activityViewState: ActivityViewState? = nil
    private var currentActivity: DeliveryActivity? = nil
}

// MARK: - Actions

extension LiveActivityWidgetViewModel {
    func loadDelivery() {
        guard let activity = DeliveryActivity.activities.first else {
            return
        }

        setup(activity: activity, for: activity.attributes.delivery)
    }

    func startDelivery() {
        let delivery = Delivery.sent()
        let expectedArrivalDate = delivery.date
            .adding(.minute, value: Int.random(in: 3 ... 5))
        let attributes = DeliveryAttributes(delivery: delivery)
        let state = DeliveryAttributes.ContentState(
            expectedArrivalDate: expectedArrivalDate,
            deliveryState: .sent
        )
        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: .init(state: state, staleDate: expectedArrivalDate)
            )
            setup(activity: activity, for: delivery)
        } catch {
            print("Couldn't start activity: \(String(describing: error))")
        }
    }

    func updateDelivery(delayed: Bool) {
        Task {
            activityViewState?.isUpdating = true
            try await Task.sleep(for: .seconds(2))
            try await updateActivity(delayed: delayed)
            activityViewState?.isUpdating = false
        }
    }

    func endDelivery(dismissTimeInterval: Double?) {
        Task {
            await endActivity(dismissTimeInterval: dismissTimeInterval)
        }
    }
}

// MARK: - Activity

extension LiveActivityWidgetViewModel {
    private func setup(activity: DeliveryActivity, for delivery: Delivery) {
        currentActivity = activity
        activityViewState = .init(
            activityState: activity.activityState,
            contentState: activity.content.state,
            delivery: delivery
        )
        observe(activity: activity)
    }

    private func observe(activity: DeliveryActivity) {
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

    private func updateActivity(delayed: Bool) async throws {
        guard let activity = currentActivity else {
            return
        }

        guard delayed else {
            try await refreshActivity()
            return
        }

        let delivery = activity.attributes.delivery
        let alertConfiguration = AlertConfiguration(
            title: "Unexpected delay!",
            body: "Delivery #\(delivery.id) has been delayed!",
            sound: .default
        )

        let delay = Int.random(in: 1 ... 3)
        let expectedArrivalDate = activity.content.state.expectedArrivalDate
            .adding(.minute, value: delay)
        let state = DeliveryAttributes.ContentState(
            expectedArrivalDate: expectedArrivalDate,
            deliveryState: .delayed
        )

        await activity.update(
            .init(
                state: state,
                staleDate: state.expectedArrivalDate,
                relevanceScore: 1
            ),
            alertConfiguration: alertConfiguration
        )
    }

    private func refreshActivity() async throws {
        guard let activity = currentActivity else {
            return
        }

        let state = activity.content.state
        await activity.update(
            .init(
                state: state,
                staleDate: state.expectedArrivalDate
            )
        )
    }

    private func endActivity(dismissTimeInterval: Double?) async {
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

        await activity.end(
            .init(
                state: state,
                staleDate: nil
            ),
            dismissalPolicy: dismissalPolicy
        )
    }

    private func resetActivity() {
        currentActivity = nil
        activityViewState = nil
    }
}

// MARK: - ActivityViewState

extension LiveActivityWidgetViewModel {
    struct ActivityViewState {
        var activityState: ActivityState
        var contentState: DeliveryAttributes.ContentState
        var delivery: Delivery

        var isUpdating = false

        var isActive: Bool {
            [.active, .stale].contains(activityState)
        }

        var isStale: Bool {
            activityState == .stale
        }
    }
}
