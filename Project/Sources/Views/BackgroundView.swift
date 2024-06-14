//
//  BackgroundView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct BackgroundView: View {
	@Binding var game: Game
	@Binding var showMenu: Bool

	var body: some View {
		VStack {
			TopView(game: $game, showMenu: $showMenu)
			Spacer()
			BottomView(game: $game)
		}
		.padding()
	}
}

struct TopView: View {
	@Binding var game: Game
	@Binding var showMenu: Bool

	var body: some View {
		VStack {
			HStack {
				Button {
					withAnimation {
						game.restart()
						showMenu = false
					}
				} label: {
					RoundedImageViewStroked(systemName: Images.arrow.description)
				}
				Spacer()
				Button {
					withAnimation {
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageViewStroked(systemName: Images.list.description)
					} else {
						RoundedImageViewFilled(systemName: Images.list.description)
					}
				}
			}
			HStack {
				Spacer()
				Button {
					withAnimation {
						game.getFieldHint()
						showMenu.toggle()
					}
				} label: {
					if showMenu {
						RoundedImageViewStroked(systemName: Images.questionmark.description)
							.transition(.scale)
					}
				}
			}
		}
	}
}

struct BottomView: View {
	@Binding var game: Game

	var body: some View {
		HStack {
			NumberView(title: "Target", text: String(game.targetSteps))
			Spacer()
			NumberView(title: "Taps", text: String(game.steps))
			Spacer()
			NumberView(title: "Level", text: String(game.level))
		}
	}
}

struct NumberView: View {
	let title: String
	let text: String

	var body: some View {
		HStack {
			VStack(spacing: Sizes.Spacing.normal) {
				LabelText(title: title)
				RoundedRectTextView(text: text)
			}
		}
	}
}

#Preview {
	BackgroundView(game: .constant(Game()), showMenu: .constant(true))
}
