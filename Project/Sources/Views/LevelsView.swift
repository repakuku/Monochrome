//
//  LevelsView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/14/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct LevelsView: View {
	@EnvironmentObject var viewModel: GameViewModel
	@Environment(\.dismiss) private var dismiss

	@Binding var showInstruction: Bool
	@Binding var showDeletionAlert: Bool

	var body: some View {
		ZStack {
			Theme.backgroundColor
				.ignoresSafeArea()
			VStack(spacing: Sizes.Spacing.normal) {
				LevelsHeaderView(
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
								dismiss()
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

	var body: some View {
		Button {
			action()
		} label: {
			ZStack {
				RowView(
					index: index,
					stars: stars,
					taps: taps,
					isFilled: isFilled
				)
				.frame(height: Sizes.General.roundedViewLength)
				.background(
					RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
						.fill(Theme.backgroundColor)
				)
				.overlay(
					RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
						.stroke(lineWidth: Sizes.Stroke.width)
				)
				.zIndex(1)
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
	@Environment(\.dismiss) private var dismiss

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
						dismiss()
						showDeletionAlert = true
					}
				}

				Spacer()

				RoundedImageView(
					systemName: Images.xmark.rawValue,
					isFilled: false
				) {
					withAnimation {
						dismiss()
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
            LabelText(title: L10n.LevelsView.LabelView.level)
				.frame(width: Sizes.General.roundedViewLength)
			Spacer()
            LabelText(title: L10n.LevelsView.LabelView.stars)
			Spacer()
            LabelText(title: L10n.LevelsView.LabelView.best)
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
		.foregroundColor(Theme.foregroundColor)
	}
}

#Preview {
    LevelsView(
        showInstruction: .constant(false),
        showDeletionAlert: .constant(false)
    )
    .environmentObject(
        GameViewModel(
            gameManager: GameManager(
                gameRepository: GameRepository(),
                levelService: LevelService(),
                levelGenerator: LevelGenerator()
            )
        )
    )
}
