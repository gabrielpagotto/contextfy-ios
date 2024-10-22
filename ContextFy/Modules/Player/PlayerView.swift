//
//  PlayerView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct PlayerView: View {
	@Environment(\.dismiss) private var dismiss
	
	@State private var musicProgress = 0.0
	
	@EnvironmentObject private var homeViewModel: HomeController
	@EnvironmentObject private var playerViewModel: PlayerViewModel
	
	private let avaliationOptions = [("😞", "Muito ruim"), ("😔", "Ruim"), ("😐", "Normal"), ("🙂", "Bom"), ("😄", "Muito bom")]
	
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				GeometryReader { geometry in
					CachedImageView(urlString: playerViewModel.playingTrack?.images.first?.url ?? "")
						.frame(width: geometry.size.width, height: geometry.size.width)
						.cornerRadius(Constants.defaultCornerRadius)
				}
				.padding()
				VStack {
					HStack {
						VStack(alignment: .leading) {
							Text(playerViewModel.playingTrack?.name ?? "")
								.bold()
								.font(.title)
							Text(playerViewModel.playingTrack?.artists.map(\.name).joined(separator: ", ") ?? "")
								.foregroundStyle(.secondary)
						}
						Spacer()
						Menu(playerViewModel.playingTrack?.rate == nil ? "Avaliar" : "\(avaliationOptions[playerViewModel.playingTrack!.rate!.rate].0) \(avaliationOptions[playerViewModel.playingTrack!.rate!.rate].1)") {
							ForEach(Array(avaliationOptions.enumerated()), id: \.element.0) { index, item in
								Button {
									Task {
										await playerViewModel.rateCurrentTrack(rate: index, contextId: homeViewModel.context!.id)
									}
								} label: {
									Text("\(item.0) \(item.1)")
										.font(.system(size: 30))
								}
							}
						}.disabled(homeViewModel.context == nil)
					}
					
					
					// Player controller
					VStack {
						Slider(value: $musicProgress, in: 1...100, onEditingChanged: { value in
							playerViewModel.seekToTime(value: musicProgress)
						} )
						
						HStack {
							Text(playerViewModel.currentTimeInMinutes)
							Spacer()
							Text(playerViewModel.durationTimeInMinutes)
						}
						.font(.callout)
						.foregroundColor(.secondary)
					}
					
					HStack {
						Spacer()
						Button {
							playerViewModel.playingTrack = homeViewModel.previousTrack(for: playerViewModel.playingTrack!)
						} label: {
							Image(systemName: "backward.end.fill")
								.font(.system(size: 30))
						}
						.disabled(playerViewModel.playingTrack == nil || homeViewModel.previousTrack(for: playerViewModel.playingTrack!) == nil)
						
						Spacer()
						Button {
							playerViewModel.playPauseSong()
						} label: {
							Image(systemName: playerViewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
								.font(.system(size: 60))
						}
						.controlSize(.extraLarge)
						Spacer()
						Button {
							playerViewModel.playingTrack = homeViewModel.nextTrack(for: playerViewModel.playingTrack!)
						} label: {
							Image(systemName: "forward.end.fill")
								.font(.system(size: 30))
						}
						.disabled(playerViewModel.playingTrack == nil || homeViewModel.nextTrack(for: playerViewModel.playingTrack!) == nil)
						Spacer()
					}
				}
				.padding()
			}
			.navigationTitle("Tocando agora")
			.navigationBarTitleDisplayMode(.inline)
			.toolbar {
				ToolbarItem(placement: .cancellationAction) {
					Button {
						dismiss()
					} label: {
						Text("Fechar")
					}
				}
			}
			.onChange(of: playerViewModel.progress) { musicProgress = playerViewModel.progress }
			.onChange(of: playerViewModel.playingTrack) {
				guard let playingTrack = playerViewModel.playingTrack  else { return }
				homeViewModel.recommendations = homeViewModel.recommendations.map({
					$0.sptfTrackId == playingTrack.id && $0.rate != playingTrack.rate  ? playingTrack : $0
				})
			}
		}
	}
}

#Preview {
	PlayerView()
}
