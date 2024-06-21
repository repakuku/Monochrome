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
			VStack(spacing: Sizes.Spacing.normal) {
				HeaderView(levelsViewIsShowing: $levelsViewIsShowing)
				LabelView()
				ScrollView {
					VStack(spacing: Sizes.Spacing.normal) {
						ForEach(1..<gameManager.numberOfLevels, id: \.self) { index in
							Button {
								gameManager.selectLevel(id: index)
								levelsViewIsShowing = false
							} label: {
								RowView(
									index: index,
									stars: gameManager.getStarsForLevel(id: index),
									taps: gameManager.getTapsForLevel(id: index),
									isFilled: gameManager.getStatusForLevel(id: index)
								)
							}
						}
					}
				}
			}
		}
	}
}

struct RowView: View {
	let index: Int
	let stars: Int
	let taps: Int
	let isFilled: Bool

	var body: some View {
		HStack {
			RoundedTextView(text: String(index), isFilled: isFilled)
			Spacer()
			StarsView(stars: stars)
				.frame(width: Sizes.Levels.starsColumnWidth)
			Spacer()
			TapsText(value: taps)
				.frame(width: Sizes.Levels.tapsColumnWidth)
		}
		.background(
			RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
				.stroke(
					Color(Theme.buttonStrokeColor),
					lineWidth: Sizes.Stroke.width
				)
		)
		.padding(.horizontal)
		.frame(maxWidth: Sizes.Levels.maxRowWidth, minHeight: Sizes.Levels.minRowHeight)
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
					RoundedImageView(systemName: Images.xmark.rawValue, isFilled: true)
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
			LabelText(title: "Stars")
				.frame(width: Sizes.Levels.starsColumnWidth)
			Spacer()
			LabelText(title: "Best")
				.frame(width: Sizes.Levels.tapsColumnWidth)
		}
		.padding(.horizontal)
		.frame(maxWidth: Sizes.Levels.maxRowWidth)
	}
}

struct StarsView: View {
	let stars: Int

	var body: some View {
		HStack {
			ForEach(0..<3, id: \.self) { index in
				Image(systemName: index < stars ? Images.starFilled.rawValue : Images.star.rawValue)
			}
		}
		.foregroundColor(Color(Theme.textColor))
	}
}

#Preview {
	LevelsView(
		gameManager: GameManager(
			levelRepository: LevelRepository(),
			levelService: LevelService()
		),
		levelsViewIsShowing: .constant(true)
	)
}
