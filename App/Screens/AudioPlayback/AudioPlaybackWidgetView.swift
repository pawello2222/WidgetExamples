// The MIT License (MIT)
//
// Copyright (c) 2024-Present Paweł Wiszenko
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

struct AudioPlaybackWidgetView: View {
    @AppStorage(UserDefaultKey.isAudioPlaying, store: .appGroup)
    private var isPlaying = false

    var body: some View {
        List {
            Section {
                contentView
            } header: {
                headerView
            }
        }
        .onChange(of: isPlaying) {
            reloadWidgetTimelines()
        }
    }
}

// MARK: - Content

extension AudioPlaybackWidgetView {
    private var headerView: some View {
        Text("Audio Playback")
    }

    @ViewBuilder
    private var contentView: some View {
        stateView
        buttonsView
    }

    private var stateView: some View {
        Text(isPlaying ? "Playing..." : "Paused")
    }

    private var buttonsView: some View {
        AudioPlaybackWidgetButtonsView(isPlaying: isPlaying)
    }
}

// MARK: - Helpers

extension AudioPlaybackWidgetView {
    private func reloadWidgetTimelines() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetType.audioPlayback.kind)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        AudioPlaybackWidgetView()
    }
}
