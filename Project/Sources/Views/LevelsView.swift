//
//  LevelsView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LevelsView: View {
	@ObservedObject var gameManager: GameManager
	@Binding var levelsViewIsShowing: Bool

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()
			VStack(spacing: 10) {
				HeaderView(levelsViewIsShowing: $levelsViewIsShowing)
				LabelView()
				ScrollView {
					VStack(spacing: 10) {
						ForEach(0..<5, id: \.self) { index in
							RowView(
								index: index,
								target: gameManager.levels[index].targetTaps,
								taps: gameManager.levels[index].taps,
								isFilled: gameManager.levels[index].isCompleted
							)
						}
					}
				}
			}
		}
	}
}

struct RowView: View {
	let index: Int
	let target: Int
	let taps: Int
	let isFilled: Bool

	var body: some View {
		HStack {
			if isFilled {
				RoundedSquareTextViewFilled(text: String(index))
			} else {
				RoundedSquareTextView(text: String(index))
			}
			Spacer()
			TapsText(value: target)
				.frame(width: Sizes.Levels.targetColumnWidth)
			Spacer()
			TapsText(value: taps)
				.frame(width: Sizes.Levels.tapsColumnWidth)
		}
		.background(
			RoundedRectangle(cornerRadius: Sizes.General.roundedRectRadius)
				.strokeBorder(
					Color(Theme.buttonStrokeColor),
					lineWidth: Sizes.Stroke.width
				)
		)
		.padding(.horizontal)
		.frame(maxWidth: Sizes.Levels.maxRowWidth)
	}
}

struct HeaderView: View {
	@Binding var levelsViewIsShowing: Bool

	var body: some View {
		ZStack {
			HStack {
				Spacer()
				Button {
					levelsViewIsShowing = false
				} label: {
					RoundedImageViewFilled(systemName: Images.xmark.description)
				}
			}
		}
		.padding()
	}
}

struct LabelView: View {
	var body: some View {
		HStack {
			LabelText(title: "Level")
				.frame(width: Sizes.General.roundedViewLength)
			Spacer()
			LabelText(title: "Target")
				.frame(width: Sizes.Levels.targetColumnWidth)
			Spacer()
			LabelText(title: "Taps")
				.frame(width: Sizes.Levels.tapsColumnWidth)
		}
		.padding(.horizontal)
		.frame(maxWidth: Sizes.Levels.maxRowWidth)
	}
}

#Preview {
	LevelsView(gameManager: GameManager(), levelsViewIsShowing: .constant(true))
}