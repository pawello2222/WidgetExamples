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

extension LiveActivityView {
    struct TimeView: View {
        let state: DeliveryAttributes.ContentState

        var body: some View {
            Image(systemName: "square")
                .hidden()
                .padding(7)
                .overlay {
                    contentView
                }
        }
    }
}

// MARK: - Content

extension LiveActivityView.TimeView {
    @ViewBuilder
    private var contentView: some View {
        if state.deliveryState == .arrived {
            Image(systemName: "flag.checkered")
                .imageScale(.large)
        } else {
            Text("\(remainingTimeInMinutes)m")
        }
    }
}

// MARK: - Helpers

extension LiveActivityView.TimeView {
    private var remainingTimeInMinutes: Int {
        let seconds = Date().distance(to: state.expectedArrivalDate)
        return Int(seconds / 60)
    }
}

// MARK: - Preview

#Preview {
    HStack {
        ForEach(DeliveryAttributes.previewStates, id: \.self) {
            LiveActivityView.TimeView(
                state: $0
            )
            .border(.red)
        }
    }
    .scaleEffect(2)
}
