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
			SquaresView()
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

struct SquaresView: View {
	@Environment(\.colorScheme) var colorScheme

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()
			ForEach(1..<5) { square in
				let size = CGFloat(square * Sizes.Background.initialSquareSize)
				let opacity = colorScheme == .dark ? 0.1 : 0.3
				RoundedRectangle(cornerRadius: Sizes.Background.roundedRectRadius)
					.stroke(lineWidth: Sizes.Background.strokeWidth)
					.fill(
						RadialGradient(
							gradient: Gradient(
									colors: [
										Color(Theme.squaresColor)
											.opacity(opacity * 0.8),
										Color(Theme.squaresColor)
											.opacity(0)
									]
								),
							center: .center,
							startRadius: 100,
							endRadius: 270
						)
					)
					.frame(
						width: size,
						height: size
					)
			}
		}
	}
}

#Preview {
	BackgroundView(game: .constant(Game()))
}
