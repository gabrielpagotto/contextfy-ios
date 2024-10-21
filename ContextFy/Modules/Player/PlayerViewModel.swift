//
//  PlayerViewModel.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 21/10/24.
//

import Foundation
import SwiftUI
import AVKit

@MainActor
final class PlayerViewModel : ObservableObject {
	
	var player: AVPlayer?
	var timeObserverToken: Any?
	
	@Published var playingTrack: TrackModel? {
		didSet {
			if let track = playingTrack {
				loadSong(previewUrl: track.previewUrl)
			} else {
				isPlaying = false
				player?.pause()
				seekToTime(value: 0.0)
			}
		}
	}
	
	@Published var isPlaying: Bool = false
	@Published var currentTime: Double = 0
	@Published var duration: Double = 0
	
	var progress: Double { (currentTime / duration) * 100 }
	
	var currentTimeInMinutes: String { convertToMinutesAndSeconds(currentTime) }
	var durationTimeInMinutes: String { convertToMinutesAndSeconds(duration) }
	
	init() {
		NotificationCenter.default.addObserver(self,
											   selector: #selector(playerDidFinishPlaying),
											   name: .AVPlayerItemDidPlayToEndTime,
											   object: nil)
	}
	
	deinit { NotificationCenter.default.removeObserver(self) }
	
	func loadSong(previewUrl: String) {
		guard let url = URL(string: previewUrl) else { return }
		
		player = AVPlayer(url: url)
		player?.play()
		isPlaying = true
		
		addPeriodicTimeObserver()
		
		if let currentItem = player?.currentItem {
			let asset = currentItem.asset
			Task {
				do {
					let durationValue = try await asset.load(.duration)
					self.duration = CMTimeGetSeconds(durationValue)
				} catch {
					print("Erro loading duration: \(error.localizedDescription)")
				}
			}
		}
	}
	
	func playPauseSong() {
		guard let player = player else { return }
		
		if isPlaying {
			player.pause()
		} else {
			player.play()
		}
		isPlaying.toggle()
	}
	
	func seekToTime(value: Double) {
		let seconds = (value / 100) * duration
		
		guard let player = player else { return }
		let targetTime = CMTime(seconds: seconds, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
		
		player.seek(to: targetTime)
	}
	
	private func addPeriodicTimeObserver() {
		let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
		timeObserverToken = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
			Task { @MainActor in
				self?.currentTime = CMTimeGetSeconds(time)
			}
		}
	}
	
	private func removePeriodicTimeObserver() {
		if let timeObserverToken = timeObserverToken {
			player?.removeTimeObserver(timeObserverToken)
			self.timeObserverToken = nil
		}
	}
	
	private func convertToMinutesAndSeconds(_ totalSeconds: Double) -> String {
		let minutes = Int(totalSeconds) / 60
		let seconds = Int(totalSeconds) % 60
		return String(format: "%02d:%02d", minutes, seconds)
	}
	
	@objc private func playerDidFinishPlaying(notification: Notification) {
		isPlaying = false
		seekToTime(value: 0.0)
	}
}
