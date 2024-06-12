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
	var body: some View {
		HStack {
			NumberView(title: "Score", text: "0")
			Spacer()
			NumberView(title: "Level", text: "1")
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
