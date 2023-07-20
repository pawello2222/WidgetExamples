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

struct DeliveryAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        let expectedArrivalDate: Date
        let deliveryState: DeliveryState
    }

    let delivery: Delivery
}

// MARK: - Data

extension DeliveryAttributes {
    static let previewStates: [DeliveryAttributes.ContentState] = [
        .sent, .delayed, .arrived
    ]
}

extension DeliveryAttributes.ContentState {
    static let sent: Self = .init(
        expectedArrivalDate: .now.adding(.minute, value: 3),
        deliveryState: .sent
    )

    static let delayed: Self = .init(
        expectedArrivalDate: .now.adding(.minute, value: 12),
        deliveryState: .delayed
    )

    static let arrived: Self = .init(
        expectedArrivalDate: .now,
        deliveryState: .arrived
    )
}
