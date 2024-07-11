//
//  DeleteGameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/27/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct DeleteGameView: View {
	@ObservedObject var viewModel: GameViewModel
	@Binding var viewIsShowing: Bool
	@Binding var showInstruction: Bool

	var body: some View {
		VStack {
			InstructionText(text: "Delete Game Progress?")
				.padding(.bottom)

			BodyText(text: "Do you really want to delete the game progress?")
				.padding(.bottom)
			HStack {
				Button {
					withAnimation {
						viewIsShowing = false
					}
				} label: {
					ButtonTextStroked(text: "Cancel")
				}

				Button {
					withAnimation {
						viewModel.eraserButtonTapped()
						viewIsShowing = false
						showInstruction = true
					}
				} label: {
					ButtonTextFilled(
						text: "Delete",
						backgroundColor: Theme.accentColor,
						foregroundColor: Theme.foregroundColor
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
	DeleteGameView(
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
		viewIsShowing: .constant(true),
		showInstruction: .constant(false)
	)
}
