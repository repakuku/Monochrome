//
//  GameView.swift
//  Monochrome
//
//  Created by Alexey Turulin on 6/11/24.
//  Copyright © 2024 repakuku. All rights reserved.
//

import SwiftUI

struct GameView: View {
	@StateObject private var viewModel = GameViewModel(
		gameManager:
			GameManager(
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
	)

	@State private var showMenu = false
	@State private var showResult = false
	@State private var showInstruction = true
	@State private var showDeletionAlert = false

	var body: some View {
		ZStack {
			if showInstruction {
				InstructionView()
			}

			if !viewModel.isTutorialLevel {
				BackgroundView(
					viewModel: viewModel,
					showMenu: $showMenu,
					showInstruction: $showInstruction,
					showDeletionAlert: $showDeletionAlert
				)
				.blur(radius: (showResult || showDeletionAlert) ? Sizes.Blur.max : Sizes.Blur.min)
				.disabled((showResult || showDeletionAlert))
			}

			if showDeletionAlert {
				DeleteGameView(
					viewModel: viewModel,
					viewIsShowing: $showDeletionAlert,
					showInstruction: $showInstruction
				)
				.zIndex(2)
				.transition(.scale)
			} else if showResult {
				ResultView(
					viewModel: viewModel
				)
				.zIndex(1)
				.transition(.scale)
			} else {
				FieldView(
					viewModel: viewModel,
					showMenu: $showMenu,
					showInstruction: $showInstruction
				)
				.transition(.scale)
				.zIndex(1)
				.disabled(viewModel.isLevelCompleted)
			}
		}
		.onChange(
			of: viewModel.isLevelCompleted
		) { isCompleted in
			if isCompleted {
				DispatchQueue.main.asyncAfter(
					deadline: .now() + 0.6
				) {
					withAnimation {
						showResult = true
					}
				}
			} else {
				withAnimation {
					showResult = false
				}
			}
		}
		.onTapGesture {
			withAnimation {
				showMenu = false
			}
		}
		.statusBarHidden()
	}
}

struct InstructionView: View {
	var body: some View {
		VStack {
			InstructionText(
				text: "Tap on the cell"
			)
			.padding(.bottom, Sizes.Padding.large)
		}
	}
}

#Preview {
	GameView()
}
