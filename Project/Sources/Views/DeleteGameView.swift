//
//  DeleteGameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/27/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct DeleteGameView: View {
	@EnvironmentObject var viewModel: GameViewModel

	@Binding var viewIsShowing: Bool
	@Binding var showInstruction: Bool

	var body: some View {
		VStack {
            InstructionText(text: L10n.DeleteGameView.title)
				.padding(.bottom)

            BodyText(text: L10n.DeleteGameView.message)
				.padding(.bottom)
			HStack {
				Button {
					withAnimation {
						viewIsShowing = false
					}
				} label: {
                    ButtonTextStroked(text: L10n.DeleteGameView.cancel)
				}

				Button {
					withAnimation {
						viewModel.eraserButtonTapped()
						viewIsShowing = false
						showInstruction = true
					}
				} label: {
					ButtonTextFilled(
                        text: L10n.DeleteGameView.delete,
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
		viewIsShowing: .constant(true),
		showInstruction: .constant(false)
	)
	.environmentObject(
		GameViewModel(
			gameManager: GameManager(
				gameRepository: GameRepository(),
				levelRepository: LevelRepository(),
				levelService: LevelService()
			)
		)
	)
}
