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

import AVFoundation
import OSLog

final class AudioPlayer {
    private enum State {
        case playing
        case paused
        case stopped
        case disabled
    }

    static let shared = AudioPlayer()

    private var logger: Logger = .audioPlayer
    private var player: AVAudioPlayer?
    private var state: State

    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            state = .stopped
        } catch {
            state = .disabled
            logger.error("AVAudioSession init error: \(error)")
        }
    }

    var isEnabled: Bool {
        state != .disabled
    }

    var isPlaying: Bool {
        state == .playing
    }
}

// MARK: - Actions

extension AudioPlayer {
    func play(sound: Sound) {
        guard isEnabled else {
            return
        }
        player = player ?? createPlayer(for: sound)
        if let player {
            state = .playing
            player.play()
        }
    }

    func pause() {
        guard isEnabled, let player else {
            return
        }
        state = .paused
        player.pause()
    }

    func stop() {
        guard isEnabled else {
            return
        }
        state = .stopped
        player?.stop()
        player = nil
    }
}

// MARK: - Helpers

extension AudioPlayer {
    private func createPlayer(for sound: Sound) -> AVAudioPlayer? {
        do {
            return try AVAudioPlayer(contentsOf: sound.url)
        } catch {
            logger.error("Error creating player: \(error)")
            return nil
        }
    }
}
