//
//  ResultView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/12/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct ResultView: View {
	@ObservedObject var gameManager: GameManager

	var body: some View {
		if gameManager.levelId == 0 {
			AlertView(
				gameManager: gameManager,
				title: "Great Start!",
				stars: 0,
				message: "In Monochrome, your goal is to make all cells the same color by tapping to flip their colors. Each tap affects the selected cell and its row and column. Solve each puzzle with the fewest taps. \n\nGood luck!", // swiftlint:disable:this line_length
				showReplayButton: false
			)
		} else {
			AlertView(
				gameManager: gameManager,
				title: "Level Done!",
				stars: gameManager.getStarsForLevel(id: gameManager.levelId),
				message: "Level \(gameManager.levelId) mastered in \(gameManager.taps) taps!",
				showReplayButton: true
			)
		}
	}
}

struct AlertView: View {
	@ObservedObject var gameManager: GameManager

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
							gameManager.restartLevel()
						}
					} label: {
						ButtonTextStroked(text: "Replay")
					}
				}
				Button {
					withAnimation {
						gameManager.nextLevel()
					}
				} label: {
					ButtonTextFilled(text: "Next Level")
				}
			}
		}
		.padding()
		.frame(width: Sizes.General.alertViewLength)
		.background(
			Color(Theme.backgroundColor)
		)
		.clipShape(
			RoundedRectangle(cornerRadius: Sizes.General.cornerRadius)
		)
		.shadow(radius: Sizes.Shadow.radius, x: Sizes.Shadow.xOffset, y: Sizes.Shadow.yOffset)
	}
}

#Preview {
	ResultView(
		gameManager: GameManager(
			levelRepository: LevelRepository(),
			levelService: LevelService()
		)
	)
}
