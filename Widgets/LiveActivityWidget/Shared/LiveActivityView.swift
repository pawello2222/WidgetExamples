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

struct LiveActivityView: View {
    let delivery: Delivery
    let state: DeliveryAttributes.ContentState
    let isStale: Bool

    var body: some View {
        VStack {
            contentView
            statusView
        }
        .padding()
    }
}

// MARK: - Content

extension LiveActivityView {
    private var contentView: some View {
        ZStack {
            HStack {
                LiveActivityView.IconView(state: state, isStale: isStale)
                Spacer()
                LiveActivityView.TimeView(state: state)
            }
            .overlay {
                LiveActivityView.TitleView(delivery: delivery)
            }
        }
        .padding([.top, .horizontal])
    }

    private var statusView: some View {
        LiveActivityView.StatusView(
            delivery: delivery,
            state: state
        )
        .padding(.horizontal)
    }
}

// MARK: - Preview

#Preview {
    LiveActivityView(
        delivery: .sent(minutesAgo: 3),
        state: .sent,
        isStale: false
    )
    .border(.red)
}
