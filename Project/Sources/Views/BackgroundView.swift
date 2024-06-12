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

	var body: some View {
		VStack {
			TopView(game: $game)
			Spacer()
			BottomView(game: $game)
		}
		.padding()
	}
}

struct TopView: View {
	@Binding var game: Game

	var body: some View {
		HStack {
			if !game.showInstructions {
				Button {
					withAnimation {
						game.restart()
					}
				} label: {
					RoundedImageViewStroked(systemName: Images.arrow.description)
				}
				.transition(.offset(x: -Sizes.Transition.normalOffset))
			}
			Spacer()
		}
	}
}

struct BottomView: View {
	@Binding var game: Game

	var body: some View {
		HStack {
			NumberView(title: "Steps", text: String(game.steps))
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
	BackgroundView(game: .constant(Game()))
}
