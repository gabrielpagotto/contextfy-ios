//
//  PlayerView.swift
//  ContextFy
//
//  Created by Gabriel Pagotto on 14/05/24.
//

import SwiftUI

struct PlayerView: View {
	@Environment(\.dismiss) private var dismiss
	
	@State private var musicProgress = 30.0
	@State private var avaliationIndex: Int? = nil
	
	private let avaliationOptions = [("😞", "Muito ruim"), ("😔", "Ruim"), ("😐", "Normal"), ("🙂", "Bom"), ("😄", "Muito bom")]
	
	var body: some View {
		NavigationView {
			VStack {
				Spacer()
				GeometryReader { geometry in
					CachedImageView(urlString: "https://i.scdn.co/image/ab67616d0000b273ed96587b9a84f44f2f115a2e")
						.frame(width: geometry.size.width, height: geometry.size.width)
						.cornerRadius(Constants.defaultCornerRadius)
				}
				.padding()
				VStack {
					HStack {
						VStack(alignment: .leading) {
							Text("Decida")
								.bold()
								.font(.title)
							Text("Milionário e José Rico")
								.foregroundStyle(.secondary)
						}
						Spacer()
						Menu(avaliationIndex == nil ? "Avaliar" : "\(avaliationOptions[avaliationIndex!].0) \(avaliationOptions[avaliationIndex!].1)") {
							ForEach(Array(avaliationOptions.enumerated()), id: \.element.0) { index, item in
								Button {
									avaliationIndex = index
								} label: {
									Text("\(item.0) \(item.1)")
										.font(.system(size: 30))
								}
							}
						}
					}
					
					
					// Player controller
					VStack {
						Slider(value: $musicProgress, in: 1...100)
						
						HStack {
							Text("0:21")
							Spacer()
							Text("-1:45")
						}
						.font(.callout)
						.foregroundColor(.secondary)
					}
					
					HStack {
						Spacer()
						Button {
							
						} label: {
							Image(systemName: "backward.end.fill")
								.font(.system(size: 30))
						}
						
						Spacer()
						Button {
							
						} label: {
							Image(systemName: "play.circle.fill")
								.font(.system(size: 60))
						}
						.controlSize(.extraLarge)
						Spacer()
						Button {
							
						} label: {
							Image(systemName: "forward.end.fill")
								.font(.system(size: 30))
						}
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
		}
	}
}

#Preview {
	PlayerView()
}
