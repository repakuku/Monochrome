//
//  ResultView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	@EnvironmentObject var viewModel: GameViewModel

	var body: some View {
		if viewModel.isTutorialLevel {
			ResultAlertView(
				title: "Great Start!",
				stars: 0,
				message: "In Monochrome, your goal is to make all cells the same color by tapping to flip their colors. Each tap affects the selected cell and its row and column. Solve each puzzle with the fewest taps. \n\nGood luck!", // swiftlint:disable:this line_length
				showReplayButton: false
			)
		} else {
			ResultAlertView(
				title: "Level Done!",
				stars: viewModel.getStarsForLevel(id: viewModel.levelId, forCurrentGame: true),
				message: "Level \(viewModel.levelId) mastered in \(viewModel.taps) taps!",
				showReplayButton: true
			)
		}
	}
}

struct ResultAlertView: View {
	@EnvironmentObject var viewModel: GameViewModel

	let title: String
	let stars: Int
	let message: String
	let showReplayButton: Bool

	var body: some View {
		VStack {
			InstructionText(text: title)
				.padding(.bottom)
			if showReplayButton {
				StarsView(stars: stars)
					.padding(.bottom)
			}
			BodyText(text: message)
				.padding(.bottom)
			HStack {
				if showReplayButton {
					Button {
						withAnimation {
							viewModel.restartLevel()
						}
					} label: {
						ButtonTextStroked(text: "Replay")
					}
				}
				Button {
					withAnimation {
						viewModel.nextLevel()
					}
				} label: {
					ButtonTextFilled(
						text: "Next Level",
						backgroundColor: Theme.foregroundColor,
						foregroundColor: Theme.backgroundColor
					)
				}
			}
		}
		.padding()
		.frame(width: Sizes.General.alertViewLength)
		.background(
			Theme.backgroundColor
		)
		.clipShape(
			RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
		)
		.shadow(radius: Sizes.Shadow.radius, x: Sizes.Shadow.xOffset, y: Sizes.Shadow.yOffset)
	}
}

#Preview {
	ResultView()
		.environmentObject(
			GameViewModel(
				gameManager: GameManager(
					gameRepository: GameRepository(
						levelRepository: LevelRepository()
					),
					levelService: LevelService()
				)
			)
		)
}
