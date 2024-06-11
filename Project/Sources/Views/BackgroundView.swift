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
			TopView()
			Spacer()
			BottomView(game: $game)
		}
		.padding()
		.background(
			Color(Theme.backgroundColor)
		)
	}
}

struct TopView: View {
	var body: some View {
		HStack {
			RoundedImageViewStroked(systemName: Images.arrow.description)
			Spacer()
			RoundedImageViewFilled(systemName: Images.list.description)
		}
	}
}

struct BottomView: View {
	@Binding var game: Game

	var body: some View {
		HStack {
			NumberView(title: "Score", text: game.score.formatted())
			Spacer()
			NumberView(title: "Level", text: game.level.formatted())
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
