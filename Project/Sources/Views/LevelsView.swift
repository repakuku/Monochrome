//
//  LevelsView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LevelsView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var levelsViewIsShowing: Bool
	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		ZStack {
			Color(Theme.backgroundColor)
				.ignoresSafeArea()
			VStack(spacing: Sizes.Spacing.normal) {
				LevelsHeaderView(
					viewModel: viewModel,
					viewIsShowing: $levelsViewIsShowing,
					showInstruction: $showInstruction,
					showDeletionAlert: $showDeletionAlert
				)

				LabelView()

				ScrollView {
					VStack(spacing: Sizes.Spacing.double) {
						ForEach(1..<viewModel.numberOfLevels, id: \.self) { index in
							RoundedRowView(
								index: index,
								stars: viewModel.getStarsForLevel(id: index),
								taps: viewModel.getTapsForLevel(id: index),
								isFilled: viewModel.getStatusForLevel(id: index)
							) {
								viewModel.selectLevel(id: index)
								levelsViewIsShowing = false
							}
						}
					}
				}
			}
		}
	}
}

struct RoundedRowView: View {
	let index: Int
	let stars: Int
	let taps: Int
	let isFilled: Bool
	let action: () -> Void

	@State private var isPressed = false

	var body: some View {
		Button {
			withAnimation {
				action()
				isPressed = true
			}
		} label: {
			ZStack {
				RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
					.fill(Color(Theme.foregroundColor))
					.frame(height: Sizes.General.roundedViewLength)
					.offset(y: 4)

				RowView(
					index: index,
					stars: stars,
					taps: taps,
					isFilled: isFilled
				)
				.frame(height: Sizes.General.roundedViewLength)
				.background(
					RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
						.fill(Color(Theme.backgroundColor))
				)
				.overlay(
					RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
						.stroke(lineWidth: Sizes.Stroke.width)
				)
				.zIndex(1)
				.offset(y: isPressed ? 4 : 0)
			}
			.padding(.horizontal)
			.frame(maxWidth: Sizes.Levels.maxRowWidth, minHeight: Sizes.Levels.minRowHeight)
		}
		.buttonStyle(ClearButtonStyle())
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
			Spacer()
			TapsText(value: taps)
				.frame(width: Sizes.General.roundedViewLength)
		}
	}
}

struct LevelsHeaderView: View {
	@ObservedObject var viewModel: GameViewModel

	@Binding var viewIsShowing: Bool
	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		ZStack {
			HStack {
				RoundedImageView(
					systemName: Images.eraser.rawValue,
					isFilled: false
				) {
					withAnimation {
						viewIsShowing = false
						showDeletionAlert = true
					}
				}

				Spacer()

				RoundedImageView(
					systemName: Images.xmark.rawValue,
					isFilled: false
				) {
					withAnimation {
						viewIsShowing = false
					}
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
			Spacer()
			LabelText(title: "Best")
				.frame(width: Sizes.General.roundedViewLength)
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
		.foregroundColor(Color(Theme.foregroundColor))
	}
}

#Preview {
	LevelsView(
		viewModel: GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(
					levelRepository: LevelRepository(
						levelsJsonUrl: Endpoints.levelsJsonUrl
					)
				),
				levelRepository: LevelRepository(
					levelsJsonUrl: Endpoints.levelsJsonUrl
				),
				levelService: LevelService()
			)
		),
		levelsViewIsShowing: .constant(true),
		showInstruction: .constant(false),
		showDeletionAlert: .constant(false)
	)
}
